import Foundation

class BookService {
    static let shared = BookService()

    func fetchBooks(query: String, completion: @escaping ([Book]) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            print("Nieprawidłowy URL zapytania")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Błąd pobierania książek: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(" HTTP Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("Brak danych z API")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)

                let books = decodedResponse.items.map { item -> Book in
                    var book = item.volumeInfo
                    
                    if let imageUrl = book.imageLinks?.thumbnail {
                        let secureUrl = imageUrl.replacingOccurrences(of: "http://", with: "https://")
                        book.imageLinks = ImageLinks(thumbnail: secureUrl)
                    }

                    return book
                }

                DispatchQueue.main.async {
                    completion(books)
                }
            } catch {
                print("Błąd dekodowania JSON: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Odpowiedź API: \(jsonString)")
                }
            }
        }.resume()
    }
}
