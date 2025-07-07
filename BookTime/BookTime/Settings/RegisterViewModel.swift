import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    var isPasswordValid: Bool {
        let regex = #"^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$&*]).{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }

    var doPasswordsMatch: Bool {
        return password == confirmPassword
    }
}
