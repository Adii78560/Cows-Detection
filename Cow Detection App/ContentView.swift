import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboarding") var isOnboarding = true
    @State private var selectedTab = 0
    
    var body: some View {
        if isOnboarding {
            OnboardingView(isOnboarding: $isOnboarding)
        } else {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Identify", systemImage: "camera.viewfinder")
                    }
                    .tag(0)
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock.fill")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
            .accentColor(.accentColor)
        }
    }
}
