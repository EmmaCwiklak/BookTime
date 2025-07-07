import SwiftUI

struct SectionView: View {
    let title: String
    let books: [Book]
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NavigationLink(destination: destinationView(for: title)) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(books) { book in
                        NavigationLink(destination: BookPreview(book: book)) {
                            VStack {
                                if let imageUrl = book.imageLinks?.thumbnail, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(6)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 150)
                                    }
                                }
                                Text(book.title)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 100)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder
    private func destinationView(for sectionTitle: String) -> some View {
        switch sectionTitle {
        case "Favorites":
            FavouritesListView().environmentObject(userSettings)
        case "Save for later":
            SavedListView().environmentObject(userSettings)
        case "Read":
            ReadListView().environmentObject(userSettings)
       default:
            Text("No view")
        }
    }
}
