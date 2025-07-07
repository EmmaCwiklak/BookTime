import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    //@State private var userIsLoggedIn = false
    @State private var errorMessage = ""
    @State private var showErrorMessage = false
    @State private var showRegisterView = false
    @EnvironmentObject var authViewModel: AuthViewModel
    //@EnvironmentObject var userSettings: UserSettings

    var body: some View {
        if authViewModel.userIsLoggedIn {
                    MainView()
                        .environmentObject(authViewModel)
                } else {
                    if showRegisterView {
                        RegisterView()
                            .environmentObject(authViewModel)
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

                Text("Log in")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold))
                    .padding(.bottom, 100)
                
                VStack(alignment: .leading, spacing: 20.0) {
                    TextField("Email", text: $email)
                        .foregroundColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .bold()
                        //.accessibilityIdentifier("Email")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
                
                
                VStack(alignment: .leading, spacing: 20.0) {
                    SecureField("Password", text: $password)
                        .foregroundColor(.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .bold()
                        //.accessibilityIdentifier("Password")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
                .padding(.top, 20)
                
                Button(action: {
                    authViewModel.login(email: email, password: password)
                }) {
                    Text("Log in")
                        .bold()
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.white))
                        //
                }
                .foregroundStyle(Color.black)
                .shadow(radius: 10)
                .padding(.top, 20)
                .accessibilityIdentifier("LogInButton")
                if let errorMessage = authViewModel.loginErrorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .padding(.top, 10)
                                }

                Button(action: handleGoogleSignIn) {
                    
                    HStack {
                        Text("Log in with Google")
                    }
                    .bold()
                    .frame(width: 250, height: 40)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.white))
                }
                .foregroundStyle(Color.black)
                .shadow(radius: 10)
                .padding(.top, 10)
                
                Button {
                    showRegisterView = true
                } label: {
                    Text("You don't have an account? Register")
                }
                .padding(.top)
                .offset(y: 110)
                
                if showErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .frame(width: 400)
        }
        .ignoresSafeArea()
    }
    
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                errorMessage = "Incorrect login or password. Please try again."
//                showErrorMessage = true
//                print(error.localizedDescription)
//            } else {
//                authViewModel.userIsLoggedIn = true
//                showErrorMessage = false
//                
//            }
//        }
//    }
    
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
                    DispatchQueue.main.async {
                        authViewModel.userIsLoggedIn = true
                        authViewModel.currentUserEmail = Auth.auth().currentUser?.email
                    }
                }
            }
        }
    }
}

#Preview{
    LoginView()
}
