import SwiftUI

extension String {
    var removeHTMLCode: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
