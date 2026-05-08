import SwiftUI
import Combine

@MainActor
class ClassificationViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isClassifying = false
    @Published var classificationResult: Breed?
    @Published var confidence: Double = 0
    @Published var error: String?
    
    // Favorites and History storage
    @Published var scanHistory: [ScanResult] = []
    @Published var favoriteBreedIDs: Set<String> = []
    
    private let mlManager = MLManager.shared
    private let dataService = DataService.shared
    
    func classifyImage(_ image: UIImage) async {
        isClassifying = true
        selectedImage = image
        error = nil
        
        // Haptic: Start
        hapticFeedback(.medium)
        
        do {
            let results = try await mlManager.classify(image: image)
            
            if let topResult = results.first {
                self.confidence = Double(topResult.confidence)
                
                if let breedData = dataService.getBreed(by: topResult.identifier) {
                    self.classificationResult = breedData
                    
                    let scan = ScanResult(
                        id: UUID(),
                        breedID: breedData.id,
                        breedName: breedData.name,
                        confidence: self.confidence,
                        date: Date(),
                        imageData: image.jpegData(compressionQuality: 0.5)
                    )
                    self.scanHistory.insert(scan, at: 0)
                    saveHistory()
                    
                    // Haptic: Success
                    hapticFeedback(.success)
                } else {
                    self.error = "Breed recognized but metadata not found."
                    hapticFeedback(.error)
                }
            } else {
                self.error = "Could not identify breed."
                hapticFeedback(.error)
            }
        } catch {
            self.error = "Classification failed: \(error.localizedDescription)"
            hapticFeedback(.error)
        }
        
        isClassifying = false
    }
    
    func toggleFavorite(breedID: String) {
        if favoriteBreedIDs.contains(breedID) {
            favoriteBreedIDs.remove(breedID)
        } else {
            favoriteBreedIDs.insert(breedID)
        }
        saveFavorites()
        hapticFeedback(.light)
    }
    
    func reset() {
        selectedImage = nil
        classificationResult = nil
        confidence = 0
        error = nil
    }
    
    // Persistent storage logic
    func loadData() {
        // Load History
        if let data = UserDefaults.standard.data(forKey: "scanHistory"),
           let decoded = try? JSONDecoder().decode([ScanResult].self, from: data) {
            self.scanHistory = decoded
        }
        
        // Load Favorites
        if let data = UserDefaults.standard.array(forKey: "favoriteBreedIDs") as? [String] {
            self.favoriteBreedIDs = Set(data)
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(scanHistory) {
            UserDefaults.standard.set(encoded, forKey: "scanHistory")
        }
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteBreedIDs), forKey: "favoriteBreedIDs")
    }
    
    // Haptic Helper
    private func hapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    private func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
