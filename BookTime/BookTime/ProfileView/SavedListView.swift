import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SavedListView: View {
    @State private var saved: [Book] = []
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack {
            List {
                ForEach(saved) { savedBook in
                    NavigationLink(destination: BookPreview(book: savedBook)) {
                        BookRow(book: savedBook)
                    }
                }
            }
        }
        .navigationTitle("Saved for later")
        .onAppear {
            fetchData()
        }
    }

    private func fetchData() {
        fetchBooks(from: "saved") { self.saved = $0 }
    }
    
    private func fetchBooks(from collection: String, completion: @escaping ([Book]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).collection(collection).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let books = documents.compactMap { doc -> Book? in
                let data = doc.data()
                
                return Book(
                    title: data["title"] as? String ?? "",
                    authors: [data["author"] as? String ?? ""],
                    pageCount: data["pageCount"] as? Int,
                    imageLinks: ImageLinks(thumbnail: data["cover"] as? String),
                    description: data["description"] as? String ?? "Brak opisu"
                )
            }
            completion(books)
        }
    }
}
