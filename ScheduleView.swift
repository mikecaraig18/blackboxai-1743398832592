import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var courtStore: CourtStore
    @State private var selectedFilter: ScheduleFilter = .upcoming
    
    enum ScheduleFilter: String, CaseIterable {
        case upcoming = "Upcoming"
        case ongoing = "Ongoing"
        case completed = "Completed"
        case all = "All"
    }
    
    var filteredMatches: [Match] {
        switch selectedFilter {
        case .upcoming:
            return courtStore.matches.filter { $0.status == "Scheduled" }
        case .ongoing:
            return courtStore.matches.filter { $0.status == "Ongoing" }
        case .completed:
            return courtStore.matches.filter { $0.status == "Completed" }
        case .all:
            return courtStore.matches
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter Picker
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(ScheduleFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Match List
                List {
                    ForEach(filteredMatches) { match in
                        MatchRow(match: match)
                            .swipeActions {
                                if match.status == "Scheduled" {
                                    Button {
                                        startMatch(match)
                                    } label: {
                                        Label("Start", systemImage: "play.fill")
                                    }
                                    .tint(.green)
                                }
                                
                                if match.status == "Ongoing" {
                                    Button {
                                        completeMatch(match)
                                    } label: {
                                        Label("Complete", systemImage: "checkmark")
                                    }
                                    .tint(.blue)
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Match Schedule")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        generateNewMatches()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func startMatch(_ match: Match) {
        if let index = courtStore.matches.firstIndex(where: { $0.id == match.id }) {
            courtStore.matches[index].status = "Ongoing"
        }
    }
    
    private func completeMatch(_ match: Match) {
        courtStore.completeMatch(match.id)
    }
    
    private func generateNewMatches() {
        let availablePlayers = courtStore.waitlist.isEmpty 
            ? courtStore.playerStore.availablePlayers() 
            : courtStore.waitlist
        courtStore.scheduleMatches(players: availablePlayers)
    }
}

struct MatchRow: View {
    let match: Match
    
    var statusColor: Color {
        switch match.status {
        case "Scheduled": return .orange
        case "Ongoing": return .green
        case "Completed": return .gray
        default: return .primary
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Court \(match.courtNumber)")
                    .font(.headline)
                Spacer()
                Text(match.status)
                    .foregroundColor(statusColor)
                    .font(.caption)
                    .padding(4)
                    .background(statusColor.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Text(match.description)
                .font(.subheadline)
            
            HStack {
                Text("Start: \(match.startTime.formatted(date: .omitted, time: .shortened))")
                Spacer()
                if match.status == "Ongoing" {
                    Text("Duration: \(match.startTime, style: .timer)")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .environmentObject(CourtStore())
            .environmentObject(PlayerStore())
    }
}