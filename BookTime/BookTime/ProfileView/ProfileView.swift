import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @State private var favorites: [Book] = []
    @State private var saved: [Book] = []
    @State private var reviews: [Book] = []
    @State private var reviewsList: [Review] = []

    @State private var read: [Book] = []
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    StatisticsView(readBooks: read, savedBooks: saved)
                        .environmentObject(userSettings)
                    Divider()
                    
                    SectionView(title: "Favorites", books: favorites)
                       
                    SectionView(title: "Read", books: read)
                        
                    SectionView(title: "Save for later", books: saved)
                    
                    NavigationLink(destination: ReviewListView()) {
                        HStack {
                            Text("Comments")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .onAppear {
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        fetchBooks(from: "favorites") { self.favorites = $0 }
        fetchBooks(from: "saved") { self.saved = $0 }
        fetchBooks(from: "reviews") { self.reviews = $0 }
        fetchBooks(from: "read") { self.read = $0 }
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
                    description: data["description"] as? String ?? "No description available"
                )
            }
            completion(books)
        }
    }
}

struct StatisticsView: View {
    let readBooks: [Book]
    let savedBooks: [Book]
    @EnvironmentObject var userSettings: UserSettings
    @State private var saved: [Book] = []
    
    private var totalReadingTime: TimeInterval {
        guard userSettings.readingSpeed > 0 else { return 0 }
        let totalPages = readBooks.compactMap { $0.pageCount }.reduce(0, +)
        return (Double(totalPages) * userSettings.readingSpeed) / 60
    }
    
    private var forLaterReadingTime: TimeInterval {
        guard userSettings.readingSpeed > 0 else { return 0 }
        let totalPages = savedBooks.compactMap { $0.pageCount }.reduce(0, +)
        return (Double(totalPages) * userSettings.readingSpeed) / 60
    }
    
    private var formattedReadingTime: (months: Int, days: Int, hours: Int, minutes: Int) {
        let totalMinutes = Int(totalReadingTime)
        
        let minutesInMonth = 30 * 24 * 60
        let minutesInDay = 24 * 60
        let minutesInHour = 60
        let months = totalMinutes / minutesInMonth
        let days = (totalMinutes % minutesInMonth) / minutesInDay
        let hours = (totalMinutes % minutesInDay) / minutesInHour
        let minutes = totalMinutes % minutesInHour
        return (months, days, hours, minutes)
    }
    
    private var forLaterFormattedReadingTime: (minutes: Int, months: Int, days: Int, hours: Int) {
        let totalMinutes = Int(forLaterReadingTime)
        let months = totalMinutes / 43200  // 1 miesiąc = 30 dni * 24h * 60 min
        var temp = totalMinutes % 43200  // Pozostałe minuty po odjęciu miesięcy
        let days = temp / 1440  // 1 dzień = 24h * 60 min
        temp = temp % 1440  // Pozostałe minuty po odjęciu dni
        let hours = temp / 60  // 1 godzina = 60 min
        let minutes = temp % 60  // Reszta minut
        return (minutes, months, days, hours)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                StatisticCard(title: "TOTAL TIME SPENT READING:",
                              values: [(formattedReadingTime.months, "MONTHS"),
                                       (formattedReadingTime.days, "DAYS"),
                                       (formattedReadingTime.hours, "HOURS"),
                                       (formattedReadingTime.minutes, "MINUTES")])
                StatisticCard(title: "READ",
                              values: [(readBooks.count, "")])
                StatisticCard(title: "TO READ",
                              values: [(savedBooks.count, "")])
                StatisticCard(
                    title: "TIME NEEDED TO READ SAVED BOOKS",
                    values: [
                        (forLaterFormattedReadingTime.months, "MONTHS"),
                        (forLaterFormattedReadingTime.days, "DAYS"),
                        (forLaterFormattedReadingTime.hours, "HOURS"),
                        (forLaterFormattedReadingTime.minutes, "MINUTES")
                    ]
                )
            }
            .padding()
        }
    }
}

struct StatisticCard: View {
    let title: String
    let values: [(Int, String)]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            Divider()
            HStack {
                ForEach(values, id: \.0) { value, label in
                    VStack {
                        Text("\(value)").font(.title).bold()
                        if !label.isEmpty {
                            Text(label).font(.caption)
                        }
                    }
                    .frame(maxWidth: values.isEmpty ? 150 : .infinity)
                }
            }
            .padding()
        }
        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 130)
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
    }
}
