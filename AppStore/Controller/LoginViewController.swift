import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    private var authService: AuthServiceProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.bringSubviewToFront(titleLabel)
        view.bringSubviewToFront(emailTextField)
        view.bringSubviewToFront(passwordTextField)
        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(signUpButton)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 60)
        configure(button: loginButton)
        configure(button: signUpButton)
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

private extension LoginViewController {
    func configure(button: UIButton) {
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
    }
}
