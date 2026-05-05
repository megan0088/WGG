//
//  QuickAddButton.swift
//  WGG
//
//  Created by George Maximillian Theodore on 05/05/26.
//

import SwiftUI

struct QuickAddButton: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.primaryText.opacity(0.5))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.primaryText.opacity(0.1))
                .cornerRadius(8)
        }
    }
}
