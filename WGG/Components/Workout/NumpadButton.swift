//
//  NumpadButton.swift
//  WGG
//
//  Created by George Maximillian Theodore on 05/05/26.
//

import SwiftUI

struct NumpadButton: View {
    let icon: String
    var body: some View {
        Image(systemName: icon)
            .font(.title3)
            .foregroundStyle(Color.primaryText.opacity(0.5))
            .frame(width: 24, height: 24)
            .padding(12)
            .background(Color.primaryText.opacity(0.1))
            .cornerRadius(16)
    }
}
