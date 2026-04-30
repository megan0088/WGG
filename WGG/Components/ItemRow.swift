import SwiftUI

struct ItemRow: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
            Text(item.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
