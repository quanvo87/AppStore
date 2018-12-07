import Foundation

extension String {
    private static let byteCountFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file

        return formatter
    }()

    var toMB: String? {
        guard let byteCount = Int64(self) else {
            return nil
        }
        return String.byteCountFormatter.string(fromByteCount: byteCount)
    }
}
