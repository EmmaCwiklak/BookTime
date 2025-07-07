import SwiftUI
import Firebase
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        
        NavigationView {
            
            List {
                if let email = authViewModel.currentUserEmail {
                    VStack(alignment: .leading) {
                        Text("Logged in:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(email)
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                }
                NavigationLink(destination: ReadingTimeView()) {
                    Text("Check your reading time")
                }
                Button(action: authViewModel.logout) {
                    Text("Log out")
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Settings")
        }
    }
    
    private func logOutUser() {
        do {
            try Auth.auth().signOut() // Log out from Firebase
            authViewModel.userIsLoggedIn = false // Ustaw flagę na false
        } catch let error {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}

