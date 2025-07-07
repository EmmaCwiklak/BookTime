import SwiftUI

struct BookPreview: View {
    let book: Book
    
    @StateObject private var firebaseManager = FirebaseManager()
    @State private var showReviewView = false
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let thumbnail = book.imageLinks?.thumbnail, let url = URL(string: thumbnail) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 300)
                    }
                }

                Text(book.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(book.authors?.joined(separator: ", ") ?? "Unknown author")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(book.description ?? "No description")
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                if let pages = book.pageCount {
                    HStack {
                        Image(systemName: "book")
                        Text("Number of pages: \(pages)")
                    }
                    .font(.subheadline)

                    HStack {
                        Image(systemName: "clock")
                        Text(book.estimatedReadingTime(userReadingSpeed: userSettings.readingSpeed))
                            .foregroundColor(.blue)
                    }
                    .font(.headline)
                } else {
                    Text("No information about the number of pages")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 12) {
                    Button(action: {
                        firebaseManager.toggleBookStatus(book: book, collection: "favorites")
                    }) {
                        Label("Favorites", systemImage: firebaseManager.isInCollection("favorites") ? "star.fill" : "star")
                            .foregroundColor(firebaseManager.isInCollection("favorites") ? .yellow : .primary)
                    }
                    .buttonStyle(.bordered)

                    Button(action: {
                        firebaseManager.toggleBookStatus(book: book, collection: "saved")
                    }) {
                        Label(firebaseManager.isInCollection("saved") ? "Saved for later" :"Save for later", systemImage: firebaseManager.isInCollection("saved") ? "bookmark.fill" : "bookmark")
                            .foregroundColor(firebaseManager.isInCollection("saved") ? .blue : .primary)
                        
                    }
                    .buttonStyle(.bordered)

                    
                }
                HStack(spacing: 12){
                    Button(action: {
                        showReviewView = true
                    }) {
                        Label("Write a comment", systemImage: "pencil")
                    }
                    .buttonStyle(.bordered)
                    .sheet(isPresented: $showReviewView) {
                        ReviewView(book: book)
                    }
                    
                    Button(action: {
                        firebaseManager.toggleBookStatus(book: book, collection: "read")
                    }) {
                        Label("Read", systemImage: firebaseManager.isInCollection("read") ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(firebaseManager.isInCollection("read") ? .green : .primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationBarTitle("Book preview", displayMode: .inline)
        .onAppear {
            firebaseManager.checkBookInCollections(book: book)
        }
    }
}

