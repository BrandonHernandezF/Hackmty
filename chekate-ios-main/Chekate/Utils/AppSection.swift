import SwiftUI

struct AppSectionDivider: View {
    var body: some View {
        Divider().padding(.leading, 12)
    }
}

struct AppSection<Content: View, Footer: View>: View {
    let icon: Image?
    let title: String?
    let subtitle: String?
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer

    @Environment(\.colorScheme) private var colorScheme

    init(
        icon: Image? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.footer = footer
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if title != nil || icon != nil {
                SectionHeader(icon: icon, title: title, subtitle: subtitle)
            }

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    content()
                }

                Spacer(minLength: 0)
            }
            .asListCard(horizontalPadding: 0)

            footer()
        }
    }
}

extension AppSection where Footer == EmptyView {
    init(
        icon: Image? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(icon: icon, title: title, subtitle: subtitle, content: content, footer: { EmptyView() })
    }
}
