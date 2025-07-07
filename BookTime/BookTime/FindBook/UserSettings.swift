import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserSettings: ObservableObject {
    @Published var readingSpeed: Double = 75.0

    init() {
        fetchReadingSpeed()
    }

    func fetchReadingSpeed() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let speed = document.get("readingSpeed") as? Double {
                DispatchQueue.main.async {
                    if let speed = document.get("Reading Speed") as? Double {
                        DispatchQueue.main.async {
                            self.readingSpeed = speed
                        }
                    }

                }
            }
        }
    }
}
