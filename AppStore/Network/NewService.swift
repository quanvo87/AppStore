import Foundation

protocol NewServiceProtocol {
    func getNewestApps(offset: Int, completion: @escaping (Result<[App]>) -> Void)
}

extension URLSession: NewServiceProtocol {
    func getNewestApps(offset: Int, completion: @escaping (Result<[App]>) -> Void) {
        guard let url = newestAppsUrl else {
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
                completion(.failure(CustomError.noData))
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
    var newestAppsUrl: URL? {
        var components = urlComponents
        components.path = "/newestApps"
        return components.url
    }
}
