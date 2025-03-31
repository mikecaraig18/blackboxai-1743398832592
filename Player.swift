import Foundation

struct Player: Identifiable, Codable {
    var id = UUID()
    var name: String
    var level: Int  // 1-5 (skill level)
    var gender: String  // "Male"/"Female"
    var isAvailable: Bool = true
    
    static let example = Player(
        name: "John Doe",
        level: 3,
        gender: "Male"
    )
}