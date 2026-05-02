struct PR: Identifiable {
    let id = UUID()
    let name: String
    let daysAgo: Int
    let weight: Double
    let diff: Double
}