import Foundation
import Combine

class CourtStore: ObservableObject {
    @Published var matches: [Match] = []
    @Published var waitlist: [Player] = []
    @Published var availableCourts: Int
    
    private var timer: Timer?
    
    init(courtCount: Int = 4) {
        self.availableCourts = courtCount
        startMatchTimer()
    }
    
    func scheduleMatches(players: [Player]) {
        let newMatches = ScheduleGenerator.generateMatches(
            players: players,
            courtCount: availableCourts
        )
        matches.append(contentsOf: newMatches)
        availableCourts -= newMatches.count
    }
    
    func completeMatch(_ matchId: UUID) {
        if let index = matches.firstIndex(where: { $0.id == matchId }) {
            matches[index].status = "Completed"
            availableCourts += 1
        }
    }
    
    func addToWaitlist(_ player: Player) {
        waitlist.append(player)
    }
    
    private func startMatchTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 30.0,
            repeats: true
        ) { [weak self] _ in
            self?.checkForAvailableCourts()
        }
    }
    
    private func checkForAvailableCourts() {
        guard availableCourts > 0, !waitlist.isEmpty else { return }
        scheduleMatches(players: waitlist)
        waitlist.removeAll()
    }
    
    deinit {
        timer?.invalidate()
    }
}