import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ClassificationViewModel()
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showResult = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium Background Gradient
                LinearGradient(colors: [Color(UIColor.systemGroupedBackground), Color(UIColor.secondarySystemGroupedBackground)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        headerSection
                        
                        actionCard
                        
                        recentScanSection
                        
                        tipsSection
                    }
                    .padding(20)
                }
            }
            .onAppear {
                viewModel.loadData()
            }
            .navigationBarHidden(true)
            .overlay {
                if viewModel.isClassifying {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        GlassCard {
                            VStack(spacing: 20) {
                                ShimmerEffect()
                                    .frame(width: 200, height: 150)
                                    .cornerRadius(16)
                                Text("Analyzing Breed...")
                                    .font(.headline)
                                ProgressView()
                            }
                        }
                        .frame(width: 260)
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $viewModel.selectedImage, sourceType: .camera)
                    .onDisappear {
                        if viewModel.selectedImage != nil {
                            Task {
                                await viewModel.classifyImage(viewModel.selectedImage!)
                                showResult = true
                            }
                        }
                    }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage, sourceType: .photoLibrary)
                    .onDisappear {
                        if viewModel.selectedImage != nil {
                            Task {
                                await viewModel.classifyImage(viewModel.selectedImage!)
                                showResult = true
                            }
                        }
                    }
            }
            .fullScreenCover(isPresented: $showResult) {
                if let breed = viewModel.classificationResult {
                    ResultView(
                        breed: breed,
                        confidence: viewModel.confidence,
                        image: viewModel.selectedImage,
                        isFavorite: viewModel.favoriteBreedIDs.contains(breed.id),
                        onFavoriteToggle: { viewModel.toggleFavorite(breedID: breed.id) }
                    ) {
                        viewModel.reset()
                        showResult = false
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Indian Cow")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text("Breed Identifier")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.accentColor)
            
            Text("AI-powered recognition for India's finest cattle breeds.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var actionCard: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.accentColor.opacity(0.15), .accentColor.opacity(0.01)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(
                        LinearGradient(colors: [.accentColor, .accentColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            .padding(.top, 10)
            
            VStack(spacing: 8) {
                Text("Identify Breed")
                    .font(.title3.bold())
                Text("Scan a cow to discover its unique traits")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                PrimaryButton(title: "Take Photo", icon: "camera.fill") {
                    showCamera = true
                }
                
                Button(action: { showImagePicker = true }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Choose from Gallery")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(16)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var recentScanSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Scans")
                .font(.title3.bold())
            
            if viewModel.scanHistory.isEmpty {
                Text("No scans yet. Start identifying!")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.scanHistory.prefix(3)) { scan in
                            VStack(alignment: .leading) {
                                if let imageData = scan.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(12)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(12)
                                }
                                
                                Text(scan.breedName)
                                    .font(.caption.bold())
                                Text(scan.date, style: .date)
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 120)
                        }
                    }
                }
            }
        }
    }
    
    private var tipsSection: some View {
        GlassCard {
            HStack(spacing: 16) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Photography Tip")
                        .font(.headline)
                    Text("For best results, capture the side profile of the cow in bright daylight.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
