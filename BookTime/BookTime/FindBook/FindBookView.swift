import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FindBookView: View {
    @State private var searchText = ""
    @State private var books: [Book] = []
    @State private var isLoading = false
    @State private var readingSpeed: Double = 90.0
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        
        NavigationView {
            VStack() {
                HStack {
                    TextField("Search for book...", text: $searchText, onCommit: fetchBooks)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                        .focused($isSearchFieldFocused)
                        .submitLabel(.search)

                    Button(action: {
                        fetchBooks()
                        isSearchFieldFocused = false
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                    }
                }
                .padding()

                if isLoading {
                    ProgressView("Searching...")
                        .padding()
                } else if books.isEmpty && !searchText.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(books) { book in
                        NavigationLink(destination: BookPreview(book: book)) {
                            BookRow(book: book)
                        }
                    }
                    .listStyle(.plain)
                }

                Spacer()
            }
            .navigationBarTitle("Find a book")
            .ignoresSafeArea(.keyboard)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isSearchFieldFocused = true
                }
            }
        }
    }

    private func fetchBooks() {
        guard !searchText.isEmpty else { return }
        isLoading = true

        BookService.shared.fetchBooks(query: searchText) { fetchedBooks in
            self.books = fetchedBooks
            self.isLoading = false
            print("Received books: \(fetchedBooks)")
        }
    }
}
struct FindBookView_Previews: PreviewProvider {
    static var previews: some View {
        FindBookView()
    }
}
