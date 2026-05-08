import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarding: Bool
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.accentColor)
                    
                    Text("Welcome to CowID")
                        .font(.largeTitle.bold())
                    
                    Text("Identify Indian cow breeds instantly with the power of Artificial Intelligence.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    OnboardingFeatureRow(icon: "camera.fill", title: "Smart Recognition", description: "Point your camera at a cow to identify its breed.")
                    OnboardingFeatureRow(icon: "doc.text.fill", title: "Detailed Insights", description: "Learn about milk production, region, and traits.")
                    OnboardingFeatureRow(icon: "clock.fill", title: "Scan History", description: "Keep track of all your previous identifications.")
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                PrimaryButton(title: "Get Started", icon: "arrow.right") {
                    withAnimation {
                        isOnboarding = false
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
