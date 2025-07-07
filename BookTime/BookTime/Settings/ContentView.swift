import Foundation
import GoogleSignIn
import Firebase
import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userIsLoggedIn: Bool = false
    @Published var currentUserEmail: String? = nil
    @Published var loginErrorMessage: String? = nil
    
    init() {
        checkUserStatus()
    }

    func checkUserStatus() {
        //userIsLoggedIn = Auth.auth().currentUser != nil
        if let user = Auth.auth().currentUser {
                    self.userIsLoggedIn = true
                    self.currentUserEmail = user.email
                } else {
                    self.userIsLoggedIn = false
                    self.currentUserEmail = nil
                }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.loginErrorMessage = "Incorrect login or password. Please try again."
                    self.userIsLoggedIn = false
                    print(error.localizedDescription)
                } else {
                    self.userIsLoggedIn = true
                    self.loginErrorMessage = nil
                }
            }
        }
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.userIsLoggedIn = error == nil
            }
        }
    }
    func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.windows.first?.rootViewController ?? UIViewController()) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.userIsLoggedIn = true
                }
            }
        }
    }
    func signInWithGoogle(presentingVC: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                DispatchQueue.main.async {
                    self.userIsLoggedIn = error == nil
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.userIsLoggedIn = false
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var userSettings = UserSettings()
    
    var body: some View {
        ZStack{
            Color("Color")
                .ignoresSafeArea()
            Group {
                if authViewModel.userIsLoggedIn {
                    MainView()
                        .environmentObject(authViewModel)
                        .environmentObject(userSettings)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
            .onAppear {
                authViewModel.checkUserStatus()
            }
        }
        }
        
}


