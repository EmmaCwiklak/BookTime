struct Book: Codable, Identifiable {
    
    var id: String { title + (authors?.joined() ?? "") }
    let title: String
    let authors: [String]?
    let pageCount: Int?
    var imageLinks: ImageLinks?
    var description: String?

    func estimatedReadingTime(userReadingSpeed: Double) -> String {
        
        guard let pageCount = pageCount else { return "lack of data" }
        let totalSeconds = Double(pageCount) * userReadingSpeed
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60

        if hours > 0 {
            return String(format: "%02dh %02dmin", hours, minutes)
        } else {
            return String(format: "%02dmin", minutes)
        }
    }
}

struct ImageLinks: Codable {
    var thumbnail: String?

    var secureThumbnail: String? {
        guard let thumbnail else { return nil }
        return thumbnail.replacingOccurrences(of: "http://", with: "https://")
    }
}
