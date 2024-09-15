import SwiftUI

struct SectionHeader: View {
    let icon: Image?
    let title: String?
    let subtitle: String?

    init(icon: Image? = nil, title: String? = nil, subtitle: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if let icon = icon {
                icon.asResizableIcon(foregroundColor: .gray, size: CGSize(width: 32, height: 32))
            }

            VStack(alignment: .leading) {
                if let title {
                    Text(title)
                        .fontStyle(withStyle: .title)
                        .textCase(.none)
                }

                if let subtitle {
                    Text(subtitle).fontStyle(withStyle: .subtitle)
                }
            }
        }
    }
}
