import Foundation

protocol RecentServiceProtocol {
    func getAppsBySearchDate(offset: Int, completion: @escaping (Result<[App]>) -> Void)
}

extension URLSession: RecentServiceProtocol {
    func getAppsBySearchDate(offset: Int, completion: @escaping (Result<[App]>) -> Void) {
        guard let url = appsBySearchDateUrl else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(CustomError.invalidResponseCode(response.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(CustomError.invalidData))
                return
            }
            do {
                let newestApps = try decoder.decode([App].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(newestApps))
                }
            } catch {
                completion(.failure(error))
            }
            }.resume()
    }
}

private extension URLSession {
    var appsBySearchDateUrl: URL? {
        var components = urlComponents
        components.path = "/appsBySearchDate"
        return components.url
    }
}
