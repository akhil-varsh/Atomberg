# Atomberg Smart Fan Controller - Setup Guide

## 🚀 Quick Start (Install APK)

### For Users (No Development Setup Needed)

1. **Download APK**
   - Get the latest APK from `build/app/outputs/flutter-apk/app-release.apk`
   - Or download from releases

2. **Enable Unknown Sources** (First time only)
   - Open Android Settings
   - Go to Security → Install unknown apps
   - Select your file manager/browser
   - Enable "Allow from this source"

3. **Install**
   - Open the downloaded APK file
   - Tap "Install"
   - Tap "Open" when installation completes

4. **Grant Permissions**
   - The app will request Local Network permission
   - Tap "Allow" for faster local device control

5. **Login**
   - Enter your Atomberg API credentials:
     - **API Key**: Your account API key
     - **Refresh Token**: Your account refresh token
   - Tap "Connect"

6. **Control Your Fans**
   - View all registered devices
   - Tap any device to control it
   - Look for "Local" badge for faster response times

---

## 💻 Developer Setup

### Prerequisites
- **Flutter SDK**: 3.29.0 or higher
- **Android Studio** or **VS Code** with Flutter extension
- **Git**

### Installation Steps

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd Atomberg
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Setup**
   ```bash
   flutter doctor
   ```
   Ensure all checkmarks are green (especially Android toolchain and Flutter SDK)

4. **Connect Device or Start Emulator**
   - Physical device: Enable USB debugging
   - Emulator: Start from Android Studio

5. **Run App**
   ```bash
   flutter run
   ```

### Build Release APK

```bash
# Build release APK
flutter build apk --release

# Find APK at:
# build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (For Play Store)

```bash
flutter build appbundle --release

# Find bundle at:
# build/app/outputs/bundle/release/app-release.aab
```

---

## ✨ Key Features

- **Cloud Control**: Control devices from anywhere via cloud API
- **Local UDP Control**: 10x faster response when on same WiFi (~50ms)
- **Offline Indicators**: Clear visual feedback for offline devices
- **Auto-Discovery**: Automatically finds devices on local network
- **Privacy-First**: Local control works without internet

---

## 📱 Permissions Explained

### Android
- **Internet**: Cloud API communication
- **Network State**: Detect WiFi/mobile data
- **WiFi State**: Local device discovery
- **Nearby WiFi Devices** (Android 13+): UDP beacon discovery

### iOS
- **Local Network**: Discover and control devices on same WiFi

All permissions are essential for the app's core functionality.

---

## 🐛 Troubleshooting

### "Local" badge not showing
- Ensure phone and fan are on same WiFi network
- Check WiFi permissions are granted
- Restart the app

### Devices not loading
- Verify API credentials are correct
- Check internet connection
- Try logout and login again

### APK won't install
- Enable "Install unknown apps" for your file manager
- Ensure device has Android 5.0 (API 21) or higher
- Check available storage space

### Slow response times
- If on same WiFi, "Local" badge should appear (50ms response)
- Without "Local" badge, commands go via cloud (500ms response)
- Check WiFi signal strength

---

## 📊 Project Structure

```
lib/
├── main.dart                          # App entry point
└── src/
    ├── config/                        # App configuration
    ├── core/
    │   ├── api_service.dart          # Hybrid API (local + cloud)
    │   └── services/
    │       ├── udp_device_discovery_service.dart
    │       ├── udp_discovery_provider.dart
    │       └── permission_service.dart
    ├── features/
    │   ├── auth/                     # Authentication
    │   ├── dashboard/                # Device list
    │   ├── device_control/           # Device controls
    │   └── splash/                   # Splash screen
    └── shared/                       # Shared widgets
```

---

## 🔧 Tech Stack

- **Framework**: Flutter 3.29.0
- **State Management**: Riverpod 3.0.3
- **HTTP Client**: Dio 5.9.0
- **Storage**: flutter_secure_storage 9.2.2
- **Networking**: Dart io (UDP), permission_handler 11.4.0


