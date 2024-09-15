import SwiftUI

extension Image {
    func asResizableIcon(
        foregroundColor color: Color = .black,
        size: CGSize = CGSize(width: 16, height: 16)
    ) -> some View {
        resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .foregroundColor(color)
    }
}
