import SwiftUI

struct WatchItemRow: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(item.name)
                .font(.headline)
            Text(item.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
