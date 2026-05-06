//
//  PageTitle.swift
//  WGG
//
//  Created by Stepanus Imanuel on 04/05/26.
//

import SwiftUI

// Tulisan paling atas: Home, Workout, Calendar, Analytics
struct PageTitle: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .bold()
                .foregroundStyle(.primaryText)
        }
    }
}

#Preview {
    PageTitle(title: "Hello World")
}
