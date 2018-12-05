import Foundation

protocol NewNetworkService {
    func getNewestApps(offset: Int, completion: @escaping ([App]) -> Void)
}

extension URLSession: NewNetworkService {
    func getNewestApps(offset: Int, completion: @escaping ([App]) -> Void) {
        completion([])
    }
}
