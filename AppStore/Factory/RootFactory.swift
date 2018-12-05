import Foundation

class RootFactory {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

//    func makeNewViewController() -> NewViewController {
//        return NewViewController(newAppsGetter: urlSession)
//    }
}
