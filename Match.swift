import Foundation

struct Match: Identifiable, Codable {
    var id = UUID()
    var courtNumber: Int
    var teams: [[Player]]  // 2 teams of 2 players each
    var startTime: Date
    var status: String  // "Scheduled"/"Ongoing"/"Completed"
    
    var description: String {
        "Court \(courtNumber): \(teams[0][0].name) & \(teams[0][1].name) vs \(teams[1][0].name) & \(teams[1][1].name)"
    }
    
    static let example = Match(
        courtNumber: 1,
        teams: [
            [Player.example, Player.example],
            [Player.example, Player.example]
        ],
        startTime: Date(),
        status: "Scheduled"
    )
}