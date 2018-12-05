import FirebaseAuth

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void)
    func logIn(email: String, password: String, completion: @escaping (Error?) -> Void)
    func logOut()
}

struct AuthService: AuthServiceProtocol {
    private let auth = Auth.auth()

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }

    func logIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }

    func logOut() {
        try? auth.signOut()
    }
}
