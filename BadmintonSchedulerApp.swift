import SwiftUI

@main
struct BadmintonSchedulerApp: App {
    @StateObject private var playerStore: PlayerStore
    @StateObject private var courtStore: CourtStore
    
    init() {
        let loadedPlayers = PlayerStore.loadSampleData()
        _playerStore = StateObject(wrappedValue: loadedPlayers)
        _courtStore = StateObject(wrappedValue: CourtStore.withSampleMatches(playerStore: loadedPlayers))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerStore)
                .environmentObject(courtStore)
        }
    }
}
