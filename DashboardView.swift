import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var courtStore: CourtStore
    @EnvironmentObject var playerStore: PlayerStore
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Court Status Section
                Text("Court Status")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(1...4, id: \.self) { courtNumber in
                        CourtStatusCard(courtNumber: courtNumber)
                    }
                }
                .padding(.horizontal)
                
                // Waitlist Section
                WaitlistView()
                
                // Quick Actions
                QuickActionButtons()
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Badminton Scheduler")
    }
}

struct CourtStatusCard: View {
    @EnvironmentObject var courtStore: CourtStore
    let courtNumber: Int
    
    var currentMatch: Match? {
        courtStore.matches.first { $0.courtNumber == courtNumber && $0.status == "Ongoing" }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Court \(courtNumber)")
                    .font(.headline)
                Spacer()
                Image(systemName: currentMatch != nil ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(currentMatch != nil ? .green : .red)
            }
            
            if let match = currentMatch {
                Text(match.description)
                    .font(.caption)
                Text("Started: \(match.startTime, style: .time)")
                    .font(.caption2)
            } else {
                Text("Available")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if currentMatch != nil {
                Button("Complete Match") {
                    if let matchId = currentMatch?.id {
                        courtStore.completeMatch(matchId)
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct WaitlistView: View {
    @EnvironmentObject var courtStore: CourtStore
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Waitlist")
                    .font(.title2.bold())
                Spacer()
                Text("\(courtStore.waitlist.count) players")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if courtStore.waitlist.isEmpty {
                Text("No players in waitlist")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(courtStore.waitlist) { player in
                            PlayerBadge(player: player)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct PlayerBadge: View {
    let player: Player
    
    var body: some View {
        VStack {
            Image(systemName: player.gender == "Male" ? "person.fill" : "person.fill")
                .foregroundColor(player.gender == "Male" ? .blue : .pink)
            Text(player.name)
                .font(.caption)
            Text("Lvl \(player.level)")
                .font(.caption2)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct QuickActionButtons: View {
    @EnvironmentObject var courtStore: CourtStore
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                courtStore.scheduleMatches(players: courtStore.waitlist)
            } label: {
                Label("Fill Courts", systemImage: "plus.circle")
            }
            .buttonStyle(.borderedProminent)
            .disabled(courtStore.availableCourts == 0 || courtStore.waitlist.count < 4)
            
            Button {
                // Refresh logic
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(CourtStore())
            .environmentObject(PlayerStore())
    }
}