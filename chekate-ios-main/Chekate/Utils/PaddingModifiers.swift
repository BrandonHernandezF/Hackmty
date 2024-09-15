import SwiftUI

private struct PaddingModifier: ViewModifier {
    let padding: EdgeInsets

    @ViewBuilder func body(content: Content) -> some View {
        content.padding(padding)
    }
}

extension View {
    func withDefaultAppPadding() -> some View {
        modifier(PaddingModifier(padding: EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32)))
    }

    func withDefaultSectionPadding() -> some View {
        modifier(PaddingModifier(padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)))
    }

    func withDefaultContentPadding() -> some View {
        modifier(PaddingModifier(padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))
    }
}
