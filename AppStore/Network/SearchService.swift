import Foundation

protocol SearchServiceProtocol {
    func getRecentSearches(uid: String, completion: @escaping ([String]) -> Void)
    func search(query: String, completion: @escaping ([App]) -> Void)
}

class SearchService: SearchServiceProtocol {
    private let searchUrl = "https://us-central1-appstore-e4a8e.cloudfunctions.net/search"
    private let urlSession: URLSession
    private var pendingWorkItem: DispatchWorkItem?

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getRecentSearches(uid: String, completion: @escaping ([String]) -> Void) {
        completion([])
    }

    func search(query: String, completion: @escaping ([App]) -> Void) {
        pendingWorkItem?.cancel()

        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let `self` = self else {
                return
            }
            guard let url = self.getSearchUrl(forQuery: query) else {
                return
            }
            self.urlSession.dataTask(with: url) { data, response, error in
                completion([])
            }
        }

        pendingWorkItem = newWorkItem

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: newWorkItem)
    }
}

private extension SearchService {
    func getSearchUrl(forQuery query: String) -> URL? {
        return URL(string: "")
    }
}
