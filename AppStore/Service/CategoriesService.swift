import Foundation

protocol CategoriesServiceProtocol {
    func getCategories(completion: @escaping (Result<[String]>) -> Void)
    func getAppsForCategory(_ category: String, completion: @escaping (Result<[App]>) -> Void)
}

extension URLSession: CategoriesServiceProtocol {
    func getCategories(completion: @escaping (Result<[String]>) -> Void) {
        guard let url = getCategoriesUrl else {
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
                let genres = try decoder.decode([String].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(genres))
                }
            } catch {
                completion(.failure(error))
            }
            }.resume()
    }

    func getAppsForCategory(_ category: String, completion: @escaping (Result<[App]>) -> Void) {
        guard let url = getAppsForCategoryUrl(category: category) else {
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
    }
}

private extension URLSession {
    var getCategoriesUrl: URL? {
        var components = urlComponents
        components.path = "/appGenres"
        return components.url
    }

    func getAppsForCategoryUrl(category: String) -> URL? {
        var components = urlComponents
        components.path = "/appsForGenre"
        components.queryItems = [URLQueryItem(name: "genre", value: category)]
        return components.url
    }
}
