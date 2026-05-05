//
//  ExerciseBreakdownCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 05/05/26.
//

import SwiftUI

struct ExerciseBreakdownCard: View {
    @State var isExpanded: Bool = false
    var body: some View {
        Button {
            withAnimation(.spring()) { isExpanded.toggle() }
        } label: {
            VStack {
                HStack {
                    VStack (alignment: .leading, spacing: 6) {
                        Text("Pull Up")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primaryText)
                        
                        Text("4 sets · Bodyweight")
                            .foregroundStyle(Color("BrandSecondary"))
                            .fontWeight(.medium)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Best: 70 kg x 8")
                            .foregroundStyle(Color("Accent"))
                            .fontWeight(.bold)
                            .font(.footnote)
                        
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                }
                
                
                if isExpanded {
                    Divider().background(Color.gray.opacity(0.3))
                        .padding(.top, 8)
                    
                    VStack (spacing: 12) {
                        ForEach(0..<4) {_ in
                            HStack {
                                Text("Set 1")
                                    .foregroundStyle(Color("BrandSecondary"))
                                Spacer()
                                Text("BW x 8")
                                    .foregroundStyle(.gray)
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                        }
                    }
                }
            }
            .padding()
            .background(Color("Card"))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primaryText.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(16)
        }
    }
}

#Preview {
    ExerciseBreakdownCard()
}
