import SwiftUI

struct CustomTextStyle: ViewModifier {
    enum Style {
        case title
        case subtitle
        case body
    }

    var style: Style
    var fontColor: Color?

    func body(content: Content) -> some View {
        switch style {
        case .title:
            content
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(fontColor ?? .black)
        case .subtitle:
            content
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(fontColor ?? .gray)
        case .body:
            content
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(fontColor ?? .black)
        }
    }
}

extension View {
    func fontStyle(withStyle style: CustomTextStyle.Style, fontColor: Color? = nil) -> some View {
        self.modifier(CustomTextStyle(style: style, fontColor: fontColor))
    }
}
