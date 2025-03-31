import SwiftUI

struct PlayerManagementView: View {
    @EnvironmentObject var playerStore: PlayerStore
    @State private var showingAddPlayer = false
    @State private var selectedLevel: Int?
    @State private var selectedGender: String?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Filters") {
                    HStack {
                        Picker("Level", selection: $selectedLevel) {
                            Text("All").tag(nil as Int?)
                            ForEach(1...5, id: \.self) { level in
                                Text("Level \(level)").tag(level as Int?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Gender", selection: $selectedGender) {
                            Text("All").tag(nil as String?)
                            Text("Male").tag("Male" as String?)
                            Text("Female").tag("Female" as String?)
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section("Players") {
                    ForEach(filteredPlayers) { player in
                        PlayerRow(player: player)
                    }
                    .onDelete(perform: deletePlayer)
                }
            }
            .navigationTitle("Player Management")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddPlayer = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPlayer) {
                AddPlayerView()
            }
            .onChange(of: selectedLevel) { _ in applyFilters() }
            .onChange(of: selectedGender) { _ in applyFilters() }
        }
    }
    
    private var filteredPlayers: [Player] {
        playerStore.filteredPlayers
    }
    
    private func applyFilters() {
        playerStore.filterPlayers(by: selectedLevel, gender: selectedGender)
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        playerStore.removePlayer(at: offsets.first!)
    }
}

struct PlayerRow: View {
    let player: Player
    
    var body: some View {
        HStack {
            Image(systemName: player.gender == "Male" ? "person.fill" : "person.fill")
                .foregroundColor(player.gender == "Male" ? .blue : .pink)
            
            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.headline)
                Text("Level \(player.level)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if player.isAvailable {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

struct AddPlayerView: View {
    @EnvironmentObject var playerStore: PlayerStore
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var level = 3
    @State private var gender = "Male"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Player Details") {
                    TextField("Name", text: $name)
                    
                    Picker("Level", selection: $level) {
                        ForEach(1...5, id: \.self) { level in
                            Text("Level \(level)").tag(level)
                        }
                    }
                    
                    Picker("Gender", selection: $gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button("Add Player") {
                        let newPlayer = Player(
                            name: name,
                            level: level,
                            gender: gender
                        )
                        playerStore.addPlayer(newPlayer)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add New Player")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlayerManagementView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerManagementView()
            .environmentObject(PlayerStore())
    }
}