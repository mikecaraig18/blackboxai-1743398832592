import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            
            PlayerManagementView()
                .tabItem {
                    Label("Players", systemImage: "person.2")
                }
            
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
        }
        .accentColor(.badmintonGreen)
    }
}

// Custom colors
extension Color {
    static let badmintonGreen = Color(red: 0.2, green: 0.6, blue: 0.3)
    static let courtLineBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayerStore())
            .environmentObject(CourtStore())
    }
}