import Foundation

protocol DeleteServiceProtocol {
    func deleteDatabase(completion: @escaping (Error?) -> Void)
}

extension URLSession: DeleteServiceProtocol {
    func deleteDatabase(completion: @escaping (Error?) -> Void) {
        guard let url = deleteDatabaseUrl else {
            completion(CustomError.invalidUrl)
            return
        }
        dataTask(with: url) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(CustomError.invalidResponseCode(response.statusCode))
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
            }.resume()
    }
}

private extension URLSession {
    var deleteDatabaseUrl: URL? {
        var components = urlComponents
        components.path = "/deleteDatabase"
        return components.url
    }
}
