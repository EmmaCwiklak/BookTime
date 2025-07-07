import SwiftUI

struct BookRow: View {
    let book: Book
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        HStack(spacing: 5) {
            if let thumbnail = book.imageLinks?.thumbnail, let url = URL(string: thumbnail) {
                AsyncImage(url: url) { image in
                    image.resizable().frame(width:90, height: 120)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "book.fill") // Ikona zastępcza
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(book.title)
                    .font(.headline)

                Text(book.authors?.joined(separator: ", ") ?? "Unknown author")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let pageCount = book.pageCount {
                    Text("📖 \(pageCount) pages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("⏳ \(book.estimatedReadingTime(userReadingSpeed: userSettings.readingSpeed))")
                        .font(.caption)
                        .foregroundColor(.blue)
                } else {
                    Text("No data about pages")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding(.vertical, 5)
    }

    
}
