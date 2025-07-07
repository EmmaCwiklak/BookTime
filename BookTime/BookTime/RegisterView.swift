import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userIsLoggedIn = false
    @State private var showLoginView = false
    @State private var showPasswordMismatch = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userSettings: UserSettings
    private var password2 = ""
    var body: some View {
        if userIsLoggedIn {
            content
        } else {
            if showLoginView {
                LoginView()
            } else {
                content
            }
        }
    }
    
    var content: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [Color("ColorTheme-1"), Color("ColorTheme-2"), Color("ColorTheme-2")], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack {
                Text("Sign up")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold))
                    .padding(.bottom, 100)
                
                VStack(alignment: .leading, spacing: 20.0) {
                    TextField("Email", text: $viewModel.email)
                        .accessibilityIdentifier("RegisterEmailField")
                        .foregroundColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .bold()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
                
                VStack(alignment: .leading, spacing: 20.0) {
                    SecureField("Password", text: $viewModel.password)
                        .accessibilityIdentifier("RegisterPasswordField")
                        .foregroundColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .bold()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 20.0) {
                    SecureField("Repeat Password", text: $viewModel.confirmPassword)
                        .foregroundColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .bold()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
                .padding(.top, 20)
                
                if showPasswordMismatch {
                    Text("Passwords do not match.")
                        .foregroundColor(.red)
                        .padding(.top, 5)
                    }
                
                Button(action: {
                    if viewModel.password == viewModel.confirmPassword {
                        showPasswordMismatch = false
                        authViewModel.register(email: viewModel.email, password: viewModel.password)
                    } else {
                        showPasswordMismatch = true
                    }
                }) {
                    Text("Sign up")
                        .accessibilityIdentifier("RegisterButton")
                        .bold()
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.white))
                }
                .foregroundStyle(Color.black)
                .shadow(radius: 10)
                .padding(.top, 20)
                
                Button(action: signUpWithGoogle) {
                    
                    HStack {
                        Text("Sign up with Google")
                    }
                    .bold()
                    .frame(width: 250, height: 40)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.white))
                }
                .foregroundStyle(Color.black)
                .shadow(radius: 10)
                .padding(.top, 10)
                
                Button(action: { showLoginView = true }) {
                    Text("Already have an account? Log In")
                }
                .padding(.top, 10)
            }
            .frame(width: 400)

        }
        .ignoresSafeArea()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func signUpWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in error: \(error.localizedDescription)")
                } else {
                    print("User signed in with Google successfully")
                    userIsLoggedIn = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
