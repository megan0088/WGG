//
//  SessionCompleteView.swift
//  WGG
//
//  Created by Stepanus Imanuel on 05/05/26.
//

import SwiftUI

struct SessionCompleteView: View {
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                
                VStack {
                    // confetti
                    Text("🎉")
                        .font(.title)
                        .padding(20)
                        .background(Color(#colorLiteral(red: 0.1552130282, green: 0.2034782171, blue: 0, alpha: 1)))
                        .clipShape(Circle())
                    
                    // session complete
                    VStack (spacing: 10){
                        Text("Session Complete")
                            .foregroundStyle(Color("PrimaryText"))
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Pull Day · Wednesday, Apr 29")
                            .foregroundStyle(Color("BrandSecondary"))
                    }
                    .padding(.vertical, 20)
                    
                    // stats
                    HStack(spacing: 36) {
                        VStack(spacing: 8) {
                            Text("1m")
                            Text("Duration")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                        Divider()
                            .frame(height: 64)
                            .background(Color("BrandSecondary"))
                        
                        VStack(spacing: 8) {
                            Text("20")
                            Text("Sets")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                        Divider()
                            .frame(height: 64)
                            .background(Color("BrandSecondary"))
                        
                        VStack(spacing: 8) {
                            Text("6")
                            Text("Exercises")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .background(Color(#colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    
                    // Total volume
                    VStack(alignment: .leading, spacing: 8) {
                        
                        // title
                        TitleText(text: "Total Volume", isUpper: true)
                        
                        // total volume + percentage
                        HStack(alignment: .top, spacing: 4) {
                            
                            Text("6.240 kg")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .font(.title)
                                .padding(.trailing, 20)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundStyle(
                                        Color("Accent")
                                    )
                                Text("+12% vs last week")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color("Accent"))
                            }
                            .padding(8)
                            .font(.footnote)
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity)
                            .background(Color(#colorLiteral(red: 0.05331161618, green: 0.1584380567, blue: 0.05793306977, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color(#colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // new PR
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 18) {
                            // trophy
                            Image(systemName: "trophy")
                                .font(.title2)
                                .padding(12)
                                .background(Color(#colorLiteral(red: 0.215555042, green: 0.277674824, blue: 0, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .fontWeight(.semibold)
                            
                            // detail
                            VStack(alignment: .leading, spacing:8) {
                                Text("NEW PR")
                                    .fontWeight(.bold)
                                    .font(.subheadline)
                                
                                Text("Barbell Row · 70 kg × 8")
                                    .fontWeight(.bold)
                                    .font(.headline)
                                    .foregroundStyle(Color("PrimaryText"))
                                
                                Text("\"New PR. That's what showing up does.\"")
                                    .foregroundStyle(Color("BrandSecondary"))
                                    .font(.caption)
                            }
                        }
                        .foregroundStyle(Color("Accent"))
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(18)
                    .background(Color(#colorLiteral(red: 0.05331161618, green: 0.1584380567, blue: 0.05793306977, alpha: 1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.accent.opacity(0.3), lineWidth: 2.76)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // exercise breakdown
                    VStack (alignment: .leading, spacing: 20) {
                        TitleText(text: "Exercise Breakdown", isUpper: true)
                            .padding(.top, 12)
                        
                        VStack (spacing: 8) {
                            ForEach(0..<3) { index in
                                
                                ExerciseBreakdownCard()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
}

#Preview {
    SessionCompleteView()
}
