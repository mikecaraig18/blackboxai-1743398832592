import Foundation

extension PlayerStore {
    static func loadSampleData() -> PlayerStore {
        let store = PlayerStore()
        let samplePlayers = [
            Player(name: "Alice Chen", level: 4, gender: "Female"),
            Player(name: "Bob Wilson", level: 3, gender: "Male"),
            Player(name: "Charlie Ng", level: 5, gender: "Male"),
            Player(name: "Diana Park", level: 2, gender: "Female"),
            Player(name: "Ethan Lee", level: 4, gender: "Male"),
            Player(name: "Fiona Zhang", level: 3, gender: "Female"),
            Player(name: "George Kim", level: 1, gender: "Male"),
            Player(name: "Hannah Wong", level: 5, gender: "Female")
        ]
        samplePlayers.forEach { store.addPlayer($0) }
        return store
    }
}

extension CourtStore {
    static func withSampleMatches() -> CourtStore {
        let store = CourtStore()
        let samplePlayers = PlayerStore.loadSampleData().players
        store.scheduleMatches(players: samplePlayers)
        return store
    }
}