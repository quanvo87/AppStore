enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
