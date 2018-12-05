import FirebaseAuth

protocol AuthListenerProtocol {
    init(delegate: AuthListenerDelegate)
    func listenForAuthState()
}

protocol AuthListenerDelegate: class {
    func userDidLogIn(_ listener: AuthListenerProtocol, uid: String)
    func userDidLogOut(_ listener: AuthListenerProtocol)
}

class AuthListener: AuthListenerProtocol {
    private var handle: AuthStateDidChangeListenerHandle?
    private weak var delegate: AuthListenerDelegate?

    required init(delegate: AuthListenerDelegate) {
        self.delegate = delegate
    }

    func listenForAuthState() {
        stopListening()
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let `self` = self else {
                return
            }
            if let uid = user?.uid {
                self.delegate?.userDidLogIn(self, uid: uid)
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
