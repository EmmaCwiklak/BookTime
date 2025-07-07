import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RecentReviewsView: View {
    @State private var reviews: [Review] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My comments")
                    .font(.title2)
                    .bold()
                Spacer()
                NavigationLink(destination: ReviewListView()) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            ForEach(reviews.prefix(6)) { review in
                NavigationLink(destination: ReviewDetailView(review: review)) {
                    HStack(alignment: .top, spacing: 12) {
                        if let imageUrl = review.imageUrl, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.2)
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Page \(review.pageNumber ?? "-")")
                                .font(.subheadline)
                                .bold()

                            Text(review.previewText())
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("read more…")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear(perform: fetchRecentReviews)
    }

    private func fetchRecentReviews() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("reviews")
            .order(by: "timestamp", descending: true)
            .limit(to: 6)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.reviews = documents.compactMap { doc -> Review? in
                    let data = doc.data()
                    return Review(
                        id: doc.documentID,
                        bookTitle: data["bookTitle"] as? String ?? "",
                        note: data["note"] as? String ?? "",
                        pageNumber: data["pageNumber"] as? String,
                        isFavorite: data["isFavorite"] as? Bool ?? false,
                        imageUrl: data["imageUrl"] as? String 
                    )
                }
            }
    }
}
