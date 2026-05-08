import Foundation
import CoreML
import Vision
import UIKit

class MLManager {
    static let shared = MLManager()
    
    struct Classification {
        let identifier: String
        let confidence: Float
    }
    
    private init() {}
    
    /// Performs classification on the provided image
    /// - Parameter image: The UIImage to classify
    /// - Returns: A list of classifications (breed name + confidence)
    func classify(image: UIImage) async throws -> [Classification] {
        guard let ciImage = CIImage(image: image) else {
            throw MLError.imageProcessingFailed
        }
        
        // Load the Core ML model
        guard let model = try? VNCoreMLModel(for: Breeds(configuration: .init()).model) else {
            throw MLError.modelLoadingFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation] else {
                    continuation.resume(returning: [])
                    return
                }
                
                // Map top 3 results to our Classification struct
                let classifications = results.prefix(3).map { 
                    Classification(identifier: $0.identifier, confidence: $0.confidence) 
                }
                continuation.resume(returning: classifications)
            }
            
            // Perform the request
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    enum MLError: Error {
        case modelLoadingFailed
        case imageProcessingFailed
        case classificationFailed
    }
}
