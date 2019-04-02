import UIKit

protocol ImageLoading {
    func getImage(forUrl url: String, completion: @escaping (Result<(String, UIImage)>) -> Void)
}

class ImageLoader: ImageLoading {
    private let urlSession: URLSession
    private let cache = NSCache<NSString, UIImage>()

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getImage(forUrl url: String, completion: @escaping (Result<(String, UIImage)>) -> Void) {
        if let image = cache.object(forKey: url as NSString) {
            completion(.success((url, image)))
            return
        }
        guard let urlObject = URL(string: url) else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        urlSession.dataTask(with: urlObject) { [weak self] data, response, error in
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
            guard let image = UIImage(data: data) else {
                completion(.failure(CustomError.imageFromDataFailed))
                return
            }
            self?.cache.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async {
                completion(.success((url, image)))
            }
            }.resume()
    }
}
