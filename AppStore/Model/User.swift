struct User {
    let uid: String
    let username: String

    init(uid: String, email: String) {
        self.uid = uid

        if email.contains("@") {
            username = String(email.split(separator: "@")[0])
        } else {
            username = email
        }
    }
}
