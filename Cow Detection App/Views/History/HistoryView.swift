import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel = ClassificationViewModel()
    @State private var filter: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
    }
    
    var filteredHistory: [ScanResult] {
        switch filter {
        case .all:
            return viewModel.scanHistory
        case .favorites:
            return viewModel.scanHistory.filter { viewModel.favoriteBreedIDs.contains($0.breedID) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $filter) {
                    ForEach(FilterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    if filteredHistory.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: filter == .all ? "clock.arrow.circlepath" : "heart.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text(filter == .all ? "No history found" : "No favorites yet")
                                .font(.headline)
                            Text(filter == .all ? "Your identified breeds will appear here." : "Mark breeds as favorite to see them here.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                        .listRowBackground(Color.clear)
                    } else {
                        ForEach(filteredHistory) { scan in
                            HStack(spacing: 16) {
                                if let imageData = scan.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(12)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(scan.breedName)
                                        .font(.headline)
                                    Text("\(Int(scan.confidence * 100))% Match • \(scan.date, style: .date)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if viewModel.favoriteBreedIDs.contains(scan.breedID) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteScan)
                    }
                }
            }
            .navigationTitle(filter == .all ? "History" : "Favorites")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    func deleteScan(at offsets: IndexSet) {
        viewModel.scanHistory.remove(atOffsets: offsets)
        // Note: In a real app, you'd save after deleting
    }
}
