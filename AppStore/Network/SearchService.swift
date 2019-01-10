import Foundation

protocol SearchServiceProtocol {
    func search(query: String, saveSearch: Bool, completion: @escaping (Result<[App]>) -> Void)
    func getRecentSearches(completion: @escaping (Result<[String]>) -> Void)
}

class SearchService: SearchServiceProtocol {
    private let urlSession: URLSession
    private var pendingWorkItem: DispatchWorkItem?

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func search(query: String, saveSearch: Bool, completion: @escaping (Result<[App]>) -> Void) {
        pendingWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let url = self?.getSearchUrl(query: query, saveSearch: saveSearch) else {
                completion(.failure(CustomError.invalidUrl))
                return
            }
            self?.urlSession.dataTask(with: url) { data, response, error in
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

        pendingWorkItem = newWorkItem

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: newWorkItem)
    }

    func getRecentSearches(completion: @escaping (Result<[String]>) -> Void) {
        guard let url = recentSearchesUrl else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
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
                let recentSearches = try decoder.decode([String].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(recentSearches))
                }
            } catch {
                completion(.failure(error))
            }
            }.resume()
    }
}

private extension SearchService {
    func getSearchUrl(query: String, saveSearch: Bool) -> URL? {
        var components = urlComponents
        components.path = "/search"
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "saveSearch", value: saveSearch ? "true" : "false")
        ]
        return components.url
    }

    var recentSearchesUrl: URL? {
        var components = urlComponents
        components.path = "/recentSearches"
        return components.url
    }
}
