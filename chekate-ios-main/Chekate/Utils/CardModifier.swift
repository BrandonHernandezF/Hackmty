import SwiftUI

private struct CardModifier: ViewModifier {
    let horizontalPadding: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    @ViewBuilder func body(content: Content) -> some View {
        content
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.horizontal, horizontalPadding)
    }
}

extension View {
    func asListCard(horizontalPadding: CGFloat = 16) -> some View {
        modifier(CardModifier(horizontalPadding: horizontalPadding))
    }
}
