import Foundation

protocol NewServiceProtocol {
    func getNewestApps(offset: Int, completion: @escaping ([App]) -> Void)
}

extension URLSession: NewServiceProtocol {
    func getNewestApps(offset: Int, completion: @escaping ([App]) -> Void) {
        completion([])
    }
}
