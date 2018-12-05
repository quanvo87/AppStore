import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var authService: AuthServiceProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func make(authService: AuthServiceProtocol = AuthService()) -> LoginViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.authService = authService
        return vc
    }

    @IBAction func didTapLogInButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Missing email/password", message: "Please enter a valid email and password.")
            return
        }
        authService.logIn(email: email, password: password) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Login Error", message: error.localizedDescription)
            }
        }
    }

    @IBAction func didTapSignUpButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Missing email/password", message: "Please enter a valid email and password.")
            return
        }
        authService.signUp(email: email, password: password) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Sign Up Error", message: error.localizedDescription)
            }
        }
    }
}
