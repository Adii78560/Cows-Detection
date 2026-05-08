import Foundation

class DataService {
    static let shared = DataService()
    
    var breeds: [Breed] = []
    
    private init() {
        loadBreeds()
    }
    
    private func loadBreeds() {
        self.breeds = BreedConstants.allBreeds
    }
    
    func getBreed(by name: String) -> Breed? {
        // Simple fuzzy match or exact match
        return breeds.first { breed in
            name.lowercased().contains(breed.id.lowercased()) || 
            breed.name.lowercased().contains(name.lowercased())
        }
    }
}
