import FirebaseFirestore
import FirebaseAuth

//class FirebaseManager: ObservableObject {
//    private let db = Firestore.firestore()
//    private var userId: String? {
//        Auth.auth().currentUser?.uid
//    }
//
//    func toggleBookStatus(book: Book, collection: String) {
//        guard let userId = userId else { return }
//        let ref = db.collection("users").document(userId).collection(collection).document(book.id)
//
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                ref.delete() // Jeśli książka jest, usuwamy
//            } else {
//                ref.setData([
//                    "title": book.title,
//                    "author": book.authors?.joined(separator: ", ") ?? "Nieznany",
//                    "cover": book.imageLinks?.thumbnail ?? "",
//                    "pageCount": book.pageCount ?? 0
//                ]) // Jeśli nie ma, dodajemy
//            }
//        }
//    }
//
//}
class FirebaseManager: ObservableObject {
    private let db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    // Lokalny stan: czy książka jest w kolekcji
    @Published var collectionsStatus: [String: Bool] = [:] // np. ["favorites": true, "saved": false]

    func toggleBookStatus(book: Book, collection: String) {
        guard let userId = userId else { return }
        let ref = db.collection("users").document(userId).collection(collection).document(book.id)

        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                ref.delete() { _ in
                    DispatchQueue.main.async {
                        self.collectionsStatus[collection] = false
                    }
                }
            } else {
                ref.setData([
                    "title": book.title,
                    "author": book.authors?.joined(separator: ", ") ?? "Unknown",
                    "cover": book.imageLinks?.thumbnail ?? "",
                    "pageCount": book.pageCount ?? 0,
                    "description": book.description ?? "No description"
                ]) { _ in
                    DispatchQueue.main.async {
                        self.collectionsStatus[collection] = true
                    }
                }
            }
        }
    }

    func checkBookInCollections(book: Book) {
        guard let userId = userId else { return }
        let collections = ["favorites", "saved", "read"]

        for collection in collections {
            let ref = db.collection("users").document(userId).collection(collection).document(book.id)

            ref.getDocument { document, error in
                DispatchQueue.main.async {
                    self.collectionsStatus[collection] = (document?.exists ?? false)
                }
            }
        }
    }

    func isInCollection(_ collection: String) -> Bool {
        collectionsStatus[collection] ?? false
    }
}
