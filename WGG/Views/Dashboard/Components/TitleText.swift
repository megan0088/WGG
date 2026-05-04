//
//  TitleText.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct TitleText: View {
    let text: String
    var isUpper: Bool
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(Color("BrandSecondary"))
            .textCase(isUpper ? .uppercase : .none)
    }
}

#Preview {
    TitleText(text: "Hello World!", isUpper: true)
}
