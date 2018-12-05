import FirebaseAuth

protocol AuthListening {
    init(delegate: AuthListeningDelegate)
    func listenForAuthState()
}

protocol AuthListeningDelegate: AnyObject {
    func userDidLogIn(_ listener: AuthListening, uid: String)
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
