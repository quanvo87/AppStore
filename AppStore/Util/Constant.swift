import UIKit

let decoder = JSONDecoder()

let imageCache = NSCache<NSString, UIImage>()

let urlComponents: URLComponents = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "us-central1-appstore-e4a8e.cloudfunctions.net"
    return components
}()
