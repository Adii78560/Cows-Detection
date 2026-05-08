import SwiftUI

struct SettingsView: View {
    @AppStorage("isOnboarding") var isOnboarding = true
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App Preferences")) {
                    Toggle("Show Onboarding", isOn: $isOnboarding)
                }
                
                Section(header: Text("About CowID")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy Content")
                    }
                    
                    NavigationLink("Terms of Service") {
                        Text("Terms of Service Content")
                    }
                }
                
                Section(header: Text("Support")) {
                    Button("Rate the App") { }
                    Button("Contact Support") { }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
