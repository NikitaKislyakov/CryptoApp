import SwiftUI

struct XmarkButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss.callAsFunction()
        }, label: {
            Image(systemName: "xmark")
        })
    }
}

#Preview {
    XmarkButton()
}
