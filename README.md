# CowID: Indian Cow Breed Identifier

CowID is a premium, AI-powered iOS application designed to identify 41 different Indian cow and buffalo breeds. Built with **SwiftUI** and **Core ML**, the app provides farmers, researchers, and cattle enthusiasts with detailed insights into India's rich bovine heritage.

## Features

- **AI Recognition**: Instantly identify breeds using your camera or gallery.
- **Detailed Breed Profiles**: Get comprehensive data on milk production, climate suitability, native regions, and temperament.
- **Premium Apple-Style UI**: A polished interface featuring glassmorphism, smooth animations, and a modern "Vision Pro" inspired design.
- **Scan History**: Keep track of all your previous identifications with local persistence.
- **Favorites**: Mark specific breeds as favorites for quick access.
- **Offline Support**: The app works entirely offline, including the AI model and the breed database.

## Screenshots

| Onboarding | Home Screen | Identification |
| :---: | :---: | :---: |
| ![Onboarding](https://via.placeholder.com/200x400.png?text=Onboarding) | ![Home](https://via.placeholder.com/200x400.png?text=Home) | ![Result](https://via.placeholder.com/200x400.png?text=Result) |

## Tech Stack

- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Machine Learning**: Core ML + Vision Framework
- **Data Source**: Centralized `BreedConstants` with detailed metadata.
- **Feedback**: Haptic Engine integration for a tactile user experience.

## Model Performance

- **Accuracy**: The current `Breeds.mlmodel` is trained on 41 classes and has an accuracy of approximately **65%**.
- **Recommendation**: For best results, ensure the cow is well-lit and capture a side-profile view.

## Installation & Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Adii78560/Cows-Detection.git
   ```
2. **Open in Xcode**:
   - Open `Cow Detection App.xcodeproj`.
3. **Configure Permissions**:
   - Ensure `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` are set in the `Info.plist` (Target Settings > Info tab).
4. **Build and Run**:
   - Select a physical iOS device and press `Cmd + R`.

## Supported Breeds (41)

Alambadi, Amritmahal, Ayrshire, Banni, Bargur, Bhadawari, Brown Swiss, Dangi, Deoni, Gir, Guernsey, Hallikar, Hariana, Holstein Friesian, Jaffrabadi, Jersey, Kangayam, Kankrej, Kasargod, Kenkatha, Kherigarh, Khillari, Krishna Valley, Malnad Gidda, Mehsana, Murrah, Nagori, Nagpuri, Nili Ravi, Nimari, Ongole, Pulikulam, Rathi, Red Dane, Red Sindhi, Sahiwal, Surti, Tharparkar, Toda, Umblachery, and Vechur.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Made with ❤️ for Indian Agriculture.
