# Lucent: Campus Wellness App

**Lucent** is a campus wellness companion app built for all realms of campus life (students, faculty, staff, and alumni).  
It combines emotional support, wellness tracking, and resource discovery into one platform.

---

## 🌟 Features

- 🌱 Personalized **Wellness Reflection** surveys to build your unique wellness chart
- 🧠 AI-powered **Chatbot therapist** for emotional check-ins
- 📈 Visual **mood and wellness tracking** through radar charts
- 🌳 **Bonsai Tree streak system** to encourage healthy habits
- 🏫 Smart **campus resource suggestions** matched to your needs
- 🙂 Simple daily **mood journaling** with emoji-based ratings

---

## 📂 Project Structure

This Flutter project includes:
- `/lib/screens/` — Main screens like chatbot, profile, wellness reflection, etc.
- `/lib/widgets/` — Reusable UI components (navbar, wellness cards, bonsai tree, etc.)
- `/assets/` — Images and static files
- `/themes.dart` — App-wide color constants and text styles
- `/android/` and `/ios/` — Native platform configurations

---

## 🚀 Getting Started

### Prerequisites

✅ [Flutter SDK](https://flutter.dev/docs/get-started/install) (Recommended version: `3.19.6` or newer)  
✅ [Git](https://git-scm.com/) installed  
✅ [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with Flutter plugin  
✅ [Docker](https://www.docker.com/) installed (for backend server setup, optional)  
✅ Emulators:
- Android: API Level 31 or higher (Pixel device recommended)
- iOS (Mac only): Simulator via Xcode

---

### ⚡ Setup Instructions

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-team/lucent-app.git
   cd lucent-app
2. **Install Flutter packages**
   ```bash
   flutter pub get

3. **Run the app**
   ```bash
   flutter run

## 🖥️ Platform-Specific Setup Tips

### Mac Users
- Install [Xcode](https://developer.apple.com/xcode/) for iOS simulators and iPhone testing.
- Open the iOS project at least once with:
  ```bash
  open ios/Runner.xcworkspace
  ```
- Set your Apple Developer team in Xcode under **Signing & Capabilities** to run on a real device.
- Microphone permission needed for speech-to-text:
  - Edit `ios/Runner/Info.plist`:
    ```xml
    <key>NSMicrophoneUsageDescription</key>
    <string>This app requires microphone access to use speech features.</string>
    ```

### Windows Users
- Install [Android Studio](https://developer.android.com/studio) for device emulators.
- iOS development is **not available on Windows** (Flutter limitation).
- Ensure Android device API level is 31 or higher.
- No special microphone setup needed — already handled in `AndroidManifest.xml`.

---

## ⚙️ Known Setup Notes

- After Flutter upgrades, always run:
  ```bash
  flutter doctor
  ```
  to check for missing components.
- If encountering build errors, try:
  ```bash
  flutter clean
  flutter pub get
  ```
- Make sure your system PATH points correctly to the latest installed Flutter SDK.

---

## 🌱 Important Development Notes

- **Speech-to-text** uses [`speech_to_text`](https://pub.dev/packages/speech_to_text) package.
- **Radar charts** are rendered using [`fl_chart`](https://pub.dev/packages/fl_chart).
- Design is responsive for both Android and iOS.
- Backend server (`lucent-server`) is containerized with Docker (used for things like user authentication, data storage).
- Always test chatbot features carefully after pulling changes — the conversation state is sensitive.

---

## 👥 Contributors

- Students and Developers from MSU Denver and CU Denver
- Guided by the MSU Denver / CU Denver / DU 2025 Hackathon

---

# 💬 Let's build a healthier, more connected campus together with Lucent!




   
