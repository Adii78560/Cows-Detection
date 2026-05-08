import SwiftUI

struct ResultView: View {
    let breed: Breed
    let confidence: Double
    let image: UIImage?
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var animateCards = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Banner
                    ZStack(alignment: .bottomLeading) {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 380)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(LinearGradient(colors: [Color.accentColor, Color.accentColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 380)
                        }
                        
                        LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                            .frame(height: 380)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(Int(confidence * 100))% Confidence")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(20)
                                
                                Text(breed.region)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Text(breed.name)
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(24)
                    }
                    
                    VStack(spacing: 24) {
                        // Overview Card with better styling
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Overview", systemImage: "text.alignleft")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            
                            Text(breed.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(6)
                        }
                        .padding(20)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(24)
                        .offset(y: animateCards ? 0 : 40)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Characteristics Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatBox(label: "Milk Yield", value: breed.milkProduction, icon: "drop.fill", color: .blue)
                            StatBox(label: "Climate", value: breed.climateSuitability, icon: "thermometer.sun.fill", color: .orange)
                            StatBox(label: "Lifespan", value: breed.lifespan, icon: "heart.fill", color: .red)
                            StatBox(label: "Temperament", value: breed.temperament, icon: "face.smiling.fill", color: .green)
                        }
                        .offset(y: animateCards ? 0 : 40)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Pros & Cons with improved layout
                        VStack(spacing: 16) {
                            HStack(alignment: .top, spacing: 16) {
                                BulletSection(title: "Strengths", icon: "plus.circle.fill", color: .green, items: breed.pros)
                                BulletSection(title: "Challenges", icon: "minus.circle.fill", color: .red, items: breed.cons)
                            }
                        }
                        .offset(y: animateCards ? 0 : 40)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Additional Details in a cleaner list
                        VStack(spacing: 16) {
                            DetailRow(title: "Disease Resistance", icon: "shield.checkerboard", color: .purple, text: breed.diseaseResistance)
                            DetailRow(title: "Farming Suitability", icon: "leaf.fill", color: .green, text: breed.farmingSuitability)
                        }
                        .offset(y: animateCards ? 0 : 40)
                        .opacity(animateCards ? 1 : 0)
                        
                        PrimaryButton(title: "Scan Another", icon: "camera.viewfinder") {
                            onDismiss()
                        }
                        .padding(.top, 8)
                        
                        Button(action: { /* Share action */ }) {
                            Label("Share Breed Profile", systemImage: "square.and.arrow.up")
                                .font(.subheadline.bold())
                                .foregroundColor(.accentColor)
                        }
                        .padding(.bottom, 60)
                    }
                    .padding(20)
                    .background(Color(UIColor.systemGroupedBackground))
                    .cornerRadius(32, corners: [.topLeft, .topRight])
                    .offset(y: -30)
                }
            }
            .ignoresSafeArea()
            
            // Floating Header
            HStack {
                Button(action: { onDismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(isFavorite ? .red : .primary)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateCards = true
            }
        }
    }
}

struct BulletSection: View {
    let title: String
    let icon: String
    let color: Color
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .foregroundColor(color)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 6) {
                    Text("•")
                    Text(item)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.08))
        .cornerRadius(20)
    }
}

struct DetailRow: View {
    let title: String
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(text)
                    .font(.subheadline.bold())
            }
            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}

struct StatBox: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
