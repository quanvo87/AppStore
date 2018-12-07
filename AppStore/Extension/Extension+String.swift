import Foundation

extension String {
    private static let byteCountFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file

        return formatter
    }()

    var toMB: String {
        return String.byteCountFormatter.string(fromByteCount: Int64(self)!)
    }
}
