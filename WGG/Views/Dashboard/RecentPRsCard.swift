//
//  RecentPRsCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI
import SwiftData

struct RecentPRsCard: View {
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    var prs: [(name: String, weight: Double, diff: Double, daysAgo: Int)] {
        
        let calendar = Calendar.current
        
        let allExercises = Set(
            sessions
                .filter { $0.isCompleted }
                .flatMap { $0.sessionExercises }
                .compactMap { $0.exercise?.name }
        )
        
        return allExercises.compactMap { name in
            
            let occurrences = sessions
                .filter { $0.isCompleted }
                .flatMap { session in
                    session.sessionExercises
                        .filter { $0.exercise?.name == name }
                        .map { (date: session.date, sets: $0.sets) }
                }
            
            let allWeights = occurrences
                .flatMap { $0.sets.map { $0.weight } }
                .sorted(by: >)
            
            guard let best = allWeights.first else { return nil }
            
            let secondBest = allWeights.count > 1 ? allWeights[1] : best
            
            let latestDate = occurrences.map { $0.date }.max() ?? Date()
            
            let diffDays = calendar.dateComponents([.day], from: latestDate, to: Date()).day ?? 0
            
            return (
                name: name,
                weight: best,
                diff: best - secondBest,
                daysAgo: abs(diffDays)
            )
        }
        .sorted { $0.daysAgo < $1.daysAgo }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleText(text: "RECENT PRs", isUpper: false)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(prs, id: \.name) { pr in
                        if pr.diff > 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "trophy")
                                        .foregroundStyle(Color.accent)
                                        .font(.caption)
                                        .padding(.trailing, 4)
                                    
                                    HStack {
                                        Text("\(Int(pr.weight)) kg")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                        Text("+\(Int(pr.diff)) kg")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                    }
                                    .foregroundStyle(Color("Accent"))
                                    
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(pr.name)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(pr.daysAgo) days ago")
                                        .font(.caption)
                                        .foregroundStyle(Color("BrandSecondary"))
                                }
                            }
                            .padding()
                            .frame(width: 180)
                            .background(Color("Card"))
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecentPRsCard()
}
