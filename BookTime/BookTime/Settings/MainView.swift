import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            NavigationView {
                ProfileView()

            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            
            NavigationView {
                FindBookView()
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Find a Book")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
                    
            }
            .accessibilityIdentifier("Settings")
        }
        .backgroundStyle(.white)
    }
}
#Preview {
    MainView()
} 

