import Foundation

protocol PopularServiceProtocol {
    func incrementAppViewCount(trackId: Int, completion: @escaping (Result<Int>) -> Void)
    func getPopularApps(completion: @escaping (Result<[App]>) -> Void)
}

extension URLSession: PopularServiceProtocol {
    func incrementAppViewCount(trackId: Int, completion: @escaping (Result<Int>) -> Void) {
        guard let url = getIncrementAppViewCountUrl(trackId: trackId) else {
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
            guard
                let data = data,
                let string = String(data: data, encoding: .utf8),
                let newViewCount = Int(string) else {
                    completion(.failure(CustomError.invalidData))
                    return
            }
            DispatchQueue.main.async {
                completion(.success(newViewCount))
            }
            }.resume()
        finishTasksAndInvalidate()
    }

    func getPopularApps(completion: @escaping (Result<[App]>) -> Void) {
        guard let url = popularAppsUrl else {
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
                let apps = try decoder.decode([App].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apps))
                }
            } catch {
                completion(.failure(error))
            }
            }.resume()
        finishTasksAndInvalidate()
    }
}

private extension URLSession {
    var popularAppsUrl: URL? {
        var components = urlComponents
        components.path = "/popularApps"
        return components.url
    }

    func getIncrementAppViewCountUrl(trackId: Int) -> URL? {
        var components = urlComponents
        components.path = "/incrementAppViewCount"
        components.queryItems = [
            URLQueryItem(name: "trackId", value: String(trackId))
        ]
        return components.url
    }
}
