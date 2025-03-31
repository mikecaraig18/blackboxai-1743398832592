import Foundation
import Combine

class PlayerStore: ObservableObject {
    @Published var players: [Player] = []
    @Published var filteredPlayers: [Player] = []
    
    func addPlayer(_ player: Player) {
        players.append(player)
        filterPlayers()
    }
    
    func removePlayer(at index: Int) {
        players.remove(at: index)
        filterPlayers()
    }
    
    func filterPlayers(by level: Int? = nil, gender: String? = nil) {
        filteredPlayers = players
        if let level = level {
            filteredPlayers = filteredPlayers.filter { $0.level == level }
        }
        if let gender = gender {
            filteredPlayers = filteredPlayers.filter { $0.gender == gender }
        }
    }
    
    func availablePlayers() -> [Player] {
        players.filter { $0.isAvailable }
    }
    
    func markPlayerUnavailable(_ playerId: UUID) {
        if let index = players.firstIndex(where: { $0.id == playerId }) {
            players[index].isAvailable = false
        }
    }
}