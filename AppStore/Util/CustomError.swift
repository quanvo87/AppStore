enum CustomError: Error {
    case invalidUrl
    case invalidResponseCode(Int)
    case noData
    case imageFromDataFailed
}
