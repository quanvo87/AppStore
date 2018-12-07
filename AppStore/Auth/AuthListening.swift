import FirebaseAuth

protocol AuthListening {
    init(delegate: AuthListeningDelegate)
    func listenForAuthState()
}

protocol AuthListeningDelegate: AnyObject {
    func userDidLogIn(_ listener: AuthListening, user: AppStore.User)
    func userDidLogOut(_ listener: AuthListening)
}

class AuthListener: AuthListening {
    private var handle: AuthStateDidChangeListenerHandle?
    private weak var delegate: AuthListeningDelegate?

    required init(delegate: AuthListeningDelegate) {
        self.delegate = delegate
    }

    func listenForAuthState() {
        stopListening()
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let `self` = self else {
                return
            }
            if let user = user {
                let newUser = AppStore.User(uid: user.uid, email: user.email ?? "")
                self.delegate?.userDidLogIn(self, user: newUser)
            } else {
                self.delegate?.userDidLogOut(self)
            }
        }
    }

    private func stopListening() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    deinit {
        stopListening()
    }
}
