import Foundation

class ScheduleGenerator {
    static func generateMatches(players: [Player], courtCount: Int) -> [Match] {
        let availablePlayers = players.filter { $0.isAvailable }
        guard availablePlayers.count >= 4 else { return [] }
        
        let sortedPlayers = availablePlayers.sorted { $0.level > $1.level }
        var matches: [Match] = []
        var playerQueue = sortedPlayers
        
        for court in 1...courtCount {
            guard playerQueue.count >= 4 else { break }
            
            // Find best balanced teams
            let team1 = [playerQueue.removeFirst(), findPartner(for: playerQueue[0], in: playerQueue)]
            let team2 = [playerQueue.removeFirst(), findPartner(for: playerQueue[0], in: playerQueue)]
            
            let match = Match(
                courtNumber: court,
                teams: [team1, team2],
                startTime: Date(),
                status: "Scheduled"
            )
            matches.append(match)
            
            // Remove selected players from queue
            playerQueue.removeAll { player in
                team1.contains(where: { $0.id == player.id }) || 
                team2.contains(where: { $0.id == player.id })
            }
        }
        
        return matches
    }
    
    private static func findPartner(for player: Player, in players: [Player]) -> Player {
        // Try to find opposite gender first
        if let partner = players.first(where: { $0.gender != player.gender }) {
            return partner
        }
        // Fallback to same gender if needed
        return players.first(where: { $0.gender == player.gender && $0.id != player.id }) ?? players[0]
    }
    
    static func balanceByLevel(_ players: [Player]) -> [[Player]] {
        let sorted = players.sorted { $0.level > $1.level }
        return [Array(sorted.prefix(2)), Array(sorted.suffix(2))]
    }
}