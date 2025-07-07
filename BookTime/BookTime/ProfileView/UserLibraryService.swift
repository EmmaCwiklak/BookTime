import Firebase
import FirebaseAuth

class UserLibraryService {
    static let shared = UserLibraryService()

    private init() {}

    func addToLibrary(book: Book, category: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            completion(false)
            return
        }

        let db = Firestore.firestore()

        let bookData: [String: Any] = [
            "id": book.id,
            "title": book.title,
            "author": book.authors?.joined(separator: ", ") ?? "Unknown Author",
            "description": book.description ?? "No description available"
//            "coverId": book.coverId ?? 0,
//            "numberOfPages": book.numberOfPages ?? 0,
//            "publishYear": book.firstPublishYear ?? 0
        ]

        db.collection("users").document(userId).collection(category).document(book.title).setData(bookData) { error in
            if let error = error {
                print("Error adding book to \(category): \(error.localizedDescription)")
                completion(false)
            } else {
                print("Book added to \(category) successfully!")
                completion(true)
            }
        }
    }
}
