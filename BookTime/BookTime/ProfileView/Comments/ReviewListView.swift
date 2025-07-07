import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ReviewListView: View {
    @State private var reviews: [Review] = []
    @State private var showFavoritesOnly = false

    var filteredReviews: [Review] {
        showFavoritesOnly ? reviews.filter { $0.isFavorite } : reviews
    }

    var body: some View {
        VStack {
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show favourites Only")
                
            }
            .padding()
            .accessibilityIdentifier("Show favourites Only")

            List {
                ForEach(filteredReviews) { review in
                    NavigationLink(destination: ReviewDetailView(review: review)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(review.bookTitle)\(review.pageNumber.map { ", s. \($0)" } ?? "")")
                                    .font(.headline)

                                Text(review.previewText())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button(action: {
                                toggleFavorite(for: review)
                            }) {
                                Image(systemName: review.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(review.isFavorite ? .yellow : .gray)
                                    .accessibilityIdentifier("FavoriteIcon_\(review.id)")
                            }
                            .buttonStyle(.plain)
                            
                        }
                        
                    }
                    .accessibilityIdentifier("ReviewCell")
                }
                .onDelete(perform: deleteReview)
            }
            .onAppear {
                fetchReviews()
            }
        }
        .navigationTitle("All comments")
    }

     private func fetchReviews() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).collection("reviews").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.reviews = documents.compactMap { doc -> Review? in
                let data = doc.data()
                return Review(
                    id: doc.documentID,
                    bookTitle: data["bookTitle"] as? String ?? "",
                    note: data["note"] as? String ?? "",
                    pageNumber: data["pageNumber"] as? String,
                    isFavorite: data["isFavorite"] as? Bool ?? false
                    
                )
            }
        }
    }

    private func deleteReview(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        for index in offsets {
            let review = reviews[index]
            Firestore.firestore().collection("users").document(userId).collection("reviews").document(review.id).delete()
        }
        reviews.remove(atOffsets: offsets)
    }

    private func toggleFavorite(for review: Review) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let newStatus = !review.isFavorite

        db.collection("users").document(userId).collection("reviews").document(review.id).updateData(["isFavorite": newStatus]) { error in
            if let error = error {
                print("Błąd aktualizacji ulubionych: \(error.localizedDescription)")
            } else {
                if let index = reviews.firstIndex(where: { $0.id == review.id }) {
                    reviews[index].isFavorite = newStatus
                }
            }
        }
    }
}

struct Review: Identifiable {
    let id: String
    let bookTitle: String
    let note: String
    let pageNumber: String?
    var isFavorite: Bool = false
    var imageUrl: String?
    
    func firstLineOfNote() -> String {
        return note.components(separatedBy: "\n").first ?? "..."
    }

    func previewText() -> String {
        let words = note.split(separator: " ").prefix(5).joined(separator: " ")
        return words + (note.split(separator: " ").count > 5 ? "..." : "")
    }
}
