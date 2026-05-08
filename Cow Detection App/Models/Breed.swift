import Foundation

struct Breed: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let region: String
    let milkProduction: String
    let climateSuitability: String
    let pros: [String]
    let cons: [String]
    let farmingSuitability: String
    let temperament: String
    let lifespan: String
    let diseaseResistance: String
    let useCases: [String]
    let imageURL: String?
}

struct ScanResult: Identifiable, Codable {
    let id: UUID
    let breedID: String
    let breedName: String
    let confidence: Double
    let date: Date
    let imageData: Data?
}
