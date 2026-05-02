//
//  PR.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import Foundation

struct PR: Identifiable {
    let id = UUID()
    let name: String
    let daysAgo: Int
    let weight: Double
    let diff: Double
}
