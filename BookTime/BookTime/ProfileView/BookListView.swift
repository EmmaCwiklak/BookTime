//
//  BookListView.swift
//  BookTime
//
//  Created by Emma on 02/03/2025.
//


import SwiftUI

struct BookListView: View {
    let books: [Book]

    var body: some View {
        List(books) { book in
            NavigationLink(destination: BookPreview(book: book)) { // Domyślnie ustawiamy 1.0 dla readingSpeed
                HStack {
                    if let thumbnail = book.imageLinks?.thumbnail, let url = URL(string: thumbnail) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 75)
                                .cornerRadius(5)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 75)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)

                        Text(book.authors?.joined(separator: ", ") ?? "Unknown author")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Books")
    }
}
