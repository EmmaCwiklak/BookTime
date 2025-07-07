import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ReviewView: View {
    let book: Book
    @State private var pageNumber: String = ""
    @State private var comment: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    saveReview()
                }
                .bold()
            }
            .padding()
            

            AsyncImage(url: URL(string: book.imageLinks?.thumbnail ?? ""))
                .frame(width: 150, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(book.title).font(.title2).bold()
                Text(book.authors?.joined(separator: ", ") ?? "").font(.subheadline)
                Text("Estimated reading time: \(book.estimatedReadingTime(userReadingSpeed: userSettings.readingSpeed))")
                    .font(.headline)
            }.padding()

            TextField("Number of page", text: $pageNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            TextEditor(text: $comment)
                .frame(height: 150)
                .border(Color.gray, width: 1)
                .padding()
                .overlay(
                    Text(comment.isEmpty ? "Write a comment..." : "")
                        .foregroundColor(.gray)
                        .padding(8)
                )
        }
        .padding()
    }

    private func saveReview() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let reviewData: [String: Any] = [
            "pageNumber": pageNumber,
            "note": comment,
            "bookTitle": book.title,
            "cover": book.imageLinks?.thumbnail ?? ""
        ]
        db.collection("users").document(userId).collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Błąd zapisu: \(error.localizedDescription)")
            } else {
                print("Recenzja zapisana!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
