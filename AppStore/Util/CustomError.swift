enum CustomError: Error {
    case invalidUrl
    case invalidResponseCode(Int)
    case invalidData
    case imageFromDataFailed
}
