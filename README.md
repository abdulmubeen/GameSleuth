# GameSleuth

**GameSleuth** is an iOS app that helps gamers discover the latest game deals, search for specific titles, and save their favorites—all in one place. The app fetches real-time data from the [CheapShark API](https://www.cheapshark.com/api/documentation) and uses Firebase for secure authentication and cross-device favorites synchronization. Additionally, it leverages Core Data to cache favorites locally and serve as a fallback when there is no internet connection.

## Features

- **Firebase Authentication:** Secure user sign-up, login, and logout using Firebase.
- **Deals Tab:** Browse current game deals with detailed deal information.
- **Search Tab:** Search for games using a debounced and cached search bar that hits the game lookup endpoint.
- **Favorites Tab:** Save your favorite deals. The app first fetches favorites from Firebase Firestore and falls back to Core Data when offline.
- **Profile Tab:** View your account details and sign out.
- **Modern UI/UX:** Experience a polished design with gradients, subtle animations, and a minimal yet colorful style.

## Requirements

- **iOS:** 15.0+  
- **Xcode:** 13.0+  
- **Swift:** 5+  
- **Dependencies:**
  - [Firebase](https://firebase.google.com/) (Authentication, Firestore) – via Swift Package Manager or CocoaPods
  - SwiftUI and Combine

## Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/abdulmubeen/GameSleuth.git
   cd GameSleuth
   
2. **Open in Xcode:**
  - Open `GameSleuth.xcodeproj` or `GameSleuth.xcworkspace` (if using CocoaPods).

3. **Install Dependencies:**

  - **Firebase SDK**:
    - Use Swift Package Manager in Xcode:
    - Go to File > Swift Packages > Add Package Dependency...
    - Enter the Firebase iOS SDK repository URL:
    - ```bash
      https://github.com/firebase/firebase-ios-sdk
    - Select the needed packages (Authentication, Firestore).

4. **Firebase Setup:**

  - Go to the Firebase Console and create a new project.
  - Enable Email/Password authentication in the Authentication section.
  - Download the `GoogleService-Info.plist` file.
  - Add the `GoogleService-Info.plist` file to your Xcode project (ensure it is added to your target).

5. **Core Data:**

  - The project includes a Core Data model with an entity named `SavedDeal` and a `PersistenceController` to manage local storage. This is used to cache and show favorites offline.

6. **Build and Run:**

  - Select a simulator or device and hit Run.

## Usage

- **Deals Tab:** Browse current game deals. Tapping a deal brings you to the detail screen where you can review details and save the deal to favorites.

- **Search Tab:** Use the search bar to lookup games. The search supports debouncing and caching for smoother user experience. Tap a game to view detailed information.

- **Favorites Tab:** Favorites are fetched from Firebase Firestore when online. If there’s a connectivity issue, favorites stored locally in Core Data will be displayed.

- **Profile Tab:** View your logged-in user details and log out from your account.


