import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ReviewDetailView: View {
    @State var review: Review
    @State private var editedNote: String = ""
    @State private var editedPage: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Book title")) {
                Text(review.bookTitle)
            }

            Section(header: Text("Page number")) {
                TextField("Page number", text: $editedPage)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Comment")) {
                TextEditor(text: $editedNote)
                    .frame(minHeight: 150)
            }

            Button("Save changes") {
                updateReview()
            }
        }
        .navigationTitle("Review details")
        .onAppear {
            editedNote = review.note
            editedPage = review.pageNumber ?? ""
        }
    }

    private func updateReview() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("reviews").document(review.id).updateData([
            "note": editedNote,
            "pageNumber": editedPage
        ]) { error in
            if let error = error {
                print("Błąd aktualizacji: \(error.localizedDescription)")
            } else {
                print("Recenzja zaktualizowana!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
