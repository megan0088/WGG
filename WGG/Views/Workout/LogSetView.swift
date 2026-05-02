//
//  LogSetView.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI

struct LogSetView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            
            ScrollView{
                
                VStack(alignment: .leading){
                    HStack{
                        Text(Date(), style: .timer)
                            .font(.headline)
                            .foregroundStyle(Color.accent)
                            .padding(.vertical, 8)
                            .frame(width: 72)
                            .background(Color.accent.opacity(0.1))
                            .cornerRadius(16)
                        Spacer()
                        Text("Pull Day")
                            .font(Font.title.bold())
                            .foregroundStyle(Color.primaryText)
                        Spacer()
                        Text("Finish")
                            .font(.headline)
                            .foregroundStyle(Color.primaryText)
                            .padding(.vertical, 8)
                            .frame(width: 72)
                            .background(Color.primaryText.opacity(0.1))
                            .cornerRadius(16)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Text("Pull Up")
                                .foregroundStyle(Color.accent)
                                .padding(12)
                                .background(Color.accent.opacity(0.1))
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.accent.opacity(0.3), lineWidth: 1)
                                )
                            Text("Barbell Row")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .padding(12)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.accent.opacity(0.3), lineWidth: 0)
                                )
                            Text("Cable Row")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .padding(12)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.accent.opacity(0.3), lineWidth: 0)
                                )
                            Text("Lat Pulldown")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .padding(12)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.accent.opacity(0.3), lineWidth: 0)
                                )
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Pull Up")
                            .font(.title.bold())
                            .foregroundStyle(Color.primaryText)
                        
                        Text("Back · Primary")
                            .font(.caption)
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                    }
                    .padding(.bottom, 16)
                    
                    
                    Text("SET 1 OF 4")
                        .font(.headline)
                        .foregroundStyle(Color.primaryText.opacity(0.5))
                    
                    VStack (alignment: .leading) {
                        Text("WEIGHT")
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                            .font(.subheadline.bold())
                        
                        HStack {
                            Button{
                                
                            } label: {
                                Image(systemName: "minus")
                                    .font(.title3)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .frame(width: 24, height: 24)
                                    .padding(12)
                                    .background(Color.primaryText.opacity(0.1))
                                    .cornerRadius(16)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("100")
                                    .foregroundStyle(Color.primaryText)
                                    .font(.title.bold())
                                
                                Text("kg")
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .frame(width: 24, height: 24)
                                    .padding(12)
                                    .background(Color.primaryText.opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                        
                        HStack {
                            Spacer()
                            
                            Text("+1")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(8)
                            
                            Text("+2.5")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(8)
                            
                            Text("+5")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(8)
                            
                            Spacer()
                        }
                        
                        Divider()
                            .padding(.vertical, 20)
                        
                        HStack {
                            Text("REPS")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .font(.subheadline.bold())
                            
                            Spacer()
                            
                            HStack {
                                Circle()
                                    .fill(Color.accent)
                                    .frame(width: 6, height: 6)
                                    .shadow(color: Color.accent.opacity(0.5), radius: 4)
                                Text("Auto · Watch")
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .font(.subheadline)
                            }
                            .padding(8)
                            .background(Color.primaryText.opacity(0.1))
                            .cornerRadius(16)
                        }
                        
                        HStack {
                            Button{
                                
                            } label: {
                                Image(systemName: "minus")
                                    .font(.title3)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .frame(width: 24, height: 24)
                                    .padding(12)
                                    .background(Color.primaryText.opacity(0.1))
                                    .cornerRadius(16)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("100")
                                    .foregroundStyle(Color.primaryText)
                                    .font(.title.bold())
                                
                                Text("reps")
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .frame(width: 24, height: 24)
                                    .padding(12)
                                    .background(Color.primaryText.opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.primaryText.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.bottom, 16)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                            
                            Text("Log Set")
                        }
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(Color.background)
                        .background(Color.accent)
                        .cornerRadius(16)
                        .padding(.bottom, 20)
                    }
                    
                    Text("THIS EXERCISE")
                        .font(.headline)
                        .foregroundStyle(Color.primaryText.opacity(0.5))
                    
                    SetRow(setNumber: 1, weight: "2.5 kg", reps: 8, status: .completed)
                    SetRow(setNumber: 2, weight: "2.5 kg", reps: 8, status: .active)
                }
                .padding(16)
            }
        }
    }
}

#Preview {
    LogSetView()
}
