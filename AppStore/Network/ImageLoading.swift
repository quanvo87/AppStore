import UIKit

protocol ImageLoading {
    func getImage(forUrl url: String, completion: @escaping (Result<(String, UIImage)>) -> Void)
}

extension URLSession: ImageLoading {
    func getImage(forUrl urlString: String, completion: @escaping (Result<(String, UIImage)>) -> Void) {
        if let image = imageCache.object(forKey: urlString as NSString) {
            completion(.success((urlString, image)))
            return
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        dataTask(with: url) {data, response, error in
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
            imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(.success((urlString, image)))
            }
        }.resume()
        finishTasksAndInvalidate()
    }
}
