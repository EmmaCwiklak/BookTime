import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ReadingTimeView: View {
    @State private var readingSpeed: Double = 75.0 // Domyślna wartość w sekundach na stronę
    @State private var showExampleText = false

    var body: some View {
        VStack(spacing: 20) {
            Text("It is assumed that one page is read in an average of 69-78 seconds.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            Text("You can check how long it will take you to read the sample text below:")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                showExampleText = true
            }) {
                Text("Measure reading time")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .accessibilityIdentifier("MeasureReadingTimeButton")
            .accessibilityIdentifier("MeasureStart")

            Text("Your current reading speed is:")
                .font(.subheadline)
                .padding(.top)

            Text("\(readingSpeed, specifier: "%.1f") seconds per page")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .accessibilityIdentifier("ReadingSpeedLabel")

            Spacer()
        }
        .padding()
        .navigationBarTitle("Check your reading speed", displayMode: .inline)
        .onAppear {
            fetchReadingSpeed()
        }
        .sheet(isPresented: $showExampleText) {
            ExampleTextView(onSave: { measuredSpeed in
                self.readingSpeed = measuredSpeed
                saveReadingSpeed()
            })
        }
    }

    private func saveReadingSpeed() {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("users").document(userId).setData([
                "readingSpeed": readingSpeed
            ], merge: true) { error in
                if let error = error {
                    print("Error saving reading speed: \(error.localizedDescription)")
                } else {
                    print("Reading speed saved successfully.")
                }
            }
        }
    }

    private func fetchReadingSpeed() {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists, let speed = document.get("readingSpeed") as? Double {
                    self.readingSpeed = speed
                } else {
                    print("No reading speed found, using default value.")
                }
            }
        }
    }
}

