# 🌀 Atomberg Smart Fan Controller

[![Flutter](https://img.shields.io/badge/Flutter-3.29.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.0-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Control your Atomberg smart fans with blazing-fast local UDP control (50ms) or cloud API (anywhere, anytime)**

A production-ready Flutter mobile application for controlling Atomberg IoT smart fans with advanced features including **local UDP device discovery**, **hybrid cloud-local routing**, and comprehensive device controls.

---

## ✨ Key Features

🌐 **Dual Control Modes**
- ⚡ **Local UDP Control**: 10x faster (50ms response) when on same WiFi
- ☁️ **Cloud API Control**: Control from anywhere with internet
- 🔄 **Automatic Failover**: Seamless switching between local and cloud

📱 **Complete Device Management**
- 🔌 Power on/off control
- 🎚️ 5-level speed adjustment
- ⏰ Auto-off timer with countdown
- 😴 Sleep mode (gradual speed reduction)
- 💡 LED control with brightness & color
- 📊 Real-time device status monitoring
- 🔴 Offline device indicators

🎨 **Modern UI/UX**
- 🌓 Light & Dark theme support
- ✨ Smooth animations & transitions
- 📱 Material Design 3 (Material You)
- 🎭 Lottie loading animations
- 🎯 Intuitive controls

🔒 **Security & Privacy**
- 🔐 Encrypted credential storage
- 🏠 Local network privacy
- 🛡️ Bearer token authentication
- 🚫 No data tracking

---

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     📱 FLUTTER APP (UI LAYER)                   │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │   🔐 Auth    │  │  📋 Dashboard │  │  🎛️ Controls │        │
│  │    Screen    │  │    Screen     │  │    Screen    │        │
│  └──────┬───────┘  └──────┬────────┘  └──────┬───────┘        │
│         │                 │                    │                │
│         └─────────────────┼────────────────────┘                │
│                           │                                     │
└───────────────────────────┼─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              🎯 STATE MANAGEMENT (Riverpod 3.0)                 │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ authProvider │  │deviceProvider│  │controlProvider│        │
│  └──────┬───────┘  └──────┬────────┘  └──────┬───────┘        │
│         │                 │                    │                │
│         └─────────────────┼────────────────────┘                │
└───────────────────────────┼─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                  🔀 HYBRID API SERVICE                          │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              🤖 IApiService Interface                      │  │
│  └───────────────────────┬──────────────────────────────────┘  │
│                          │                                      │
│           ┌──────────────┼──────────────┐                      │
│           │              │              │                      │
│           ▼              ▼              ▼                      │
│  ┌────────────┐  ┌──────────────┐  ┌──────────┐              │
│  │ 📡 Local   │  │  ☁️ Cloud    │  │ 🔄 Smart │              │
│  │ UDP        │  │  API         │  │ Routing  │              │
│  │ Service    │  │  Service     │  │ Logic    │              │
│  └─────┬──────┘  └──────┬───────┘  └─────┬────┘              │
└────────┼─────────────────┼────────────────┼────────────────────┘
         │                 │                │
         │                 │                │
         ▼                 ▼                ▼
    ╔═══════╗         ╔═══════╗       ╔════════╗
    ║  📶   ║         ║  🌐   ║       ║   🎯   ║
    ║  UDP  ║         ║ HTTPS ║       ║ Hybrid ║
    ║ :5625 ║         ║ :443  ║       ║ Choose ║
    ║ :5600 ║         ║  API  ║       ║ Fastest║
    ╚═══╤═══╝         ╚═══╤═══╝       ╚════╤═══╝
        │                 │                 │
        ▼                 ▼                 ▼
   ╔═════════════════════════════════════════════╗
   ║           🌀 ATOMBERG SMART FAN             ║
   ║                                             ║
   ║  • MAC: AA:BB:CC:DD:EE:FF                  ║
   ║  • Series: Gorilla/Renesa/Studio           ║
   ║  • Beacon: Every 1 second (UDP)            ║
   ║  • Commands: UDP + Cloud fallback          ║
   ╚═════════════════════════════════════════════╝
```

### 🔄 Data Flow

```
User Action → UI Component → Provider → Hybrid API Service
                                              │
                      ┌───────────────────────┴───────────────────────┐
                      │                                               │
                      ▼                                               ▼
            📶 Check Local Availability                    ☁️ Always Available
                      │                                               │
                  Available?                                          │
                   /     \                                            │
                YES       NO                                          │
                 │         │                                          │
                 ▼         └──────────────────────────────────────────┤
         🚀 UDP Command                                               │
         Port 5600                                                    │
            ~50ms                                                     ▼
                 │                                              📡 HTTPS API
                 │                                         api.developer.atomberg
             Success?                                             ~500ms
                /   \                                                │
              YES    NO                                              │
               │      │                                              │
               │      └──────────────────────────────────────────────┤
               │                                                     │
               └─────────────────────────────────────────────────────┤
                                                                     ▼
                                                          ✅ Command Executed
                                                                     │
                                                                     ▼
                                                          🔄 Update UI State
```

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.29.0+
- Dart 3.7.0+
- Android Studio / VS Code
- Android device/emulator (API 21+) or iOS device (iOS 12.0+)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/atomberg.git
cd atomberg

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Release APK

```bash
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Tech Stack

### 🎨 Frontend & UI
- **Flutter** 3.29.0 - Cross-platform framework
- **Material Design 3** - Modern design system
- **flutter_animate** 4.5.2 - Smooth animations
- **lottie** 3.3.1 - JSON-based animations
- **google_fonts** 6.3.2 - Typography

### 🧠 State Management
- **flutter_riverpod** 3.0.3 - Reactive state management
- **riverpod_annotation** 3.0.3 - Code generation

### 🌐 Networking
- **dio** 5.9.0 - HTTP client for REST APIs
- **dart:io** - UDP socket communication (RawDatagramSocket)

### 💾 Storage & Security
- **flutter_secure_storage** 9.2.2 - Encrypted credential storage
- **shared_preferences** 2.5.3 - Local preferences

### 🔐 Permissions
- **permission_handler** 11.4.0 - Runtime permission management

---

## 🎯 Features in Detail

### 1️⃣ Local UDP Discovery

The app listens for UDP beacons on **port 5625**:

```dart
// Beacon Packet Format
[12-byte MAC Address][Series String]
Example: "AABBCCDDEEFF" + "Gorilla"
```

- **Beacon Frequency**: 1 packet/second
- **Timeout**: 3 seconds without beacon = device offline
- **Auto-cleanup**: Removes inactive devices from registry

### 2️⃣ Hybrid API Routing

Smart routing algorithm:

```dart
Future<void> sendCommand(String deviceId, Map command) async {
  // 1. Try local UDP first
  final deviceIp = udpService.getDeviceIp(deviceId);
  if (deviceIp != null) {
    final success = await udpService.sendCommand(deviceIp, command);
    if (success) return; // Done! (~50ms)
  }
  
  // 2. Fallback to cloud API
  await cloudApi.sendCommand(deviceId, command); // (~500ms)
}
```

### 3️⃣ Real-time Status Indicators

- 🟢 **Green "Local" Badge**: Device available via UDP
- ⚪ **No Badge**: Using cloud API only
- 🔴 **Offline Badge**: Device unreachable
- ⏳ **Last Seen**: Timestamp of last communication

### 4️⃣ Device Controls

| Control | Icon | Description |
|---------|------|-------------|
| Power | 🔌 | On/Off toggle |
| Speed | 🎚️ | 5 levels (1-5) |
| Timer | ⏰ | Auto-off (0-8 hours) |
| Sleep | 😴 | Gradual speed reduction |
| LED | 💡 | Light on/off |
| Brightness | ☀️ | LED intensity (0-100%) |
| Color | 🎨 | RGB color picker |

---

## 📡 API Documentation

### Authentication

```dart
// Login
POST https://api.developer.atomberg-iot.com/auth/login
Headers: {
  'api-key': 'your_api_key',
  'refresh-token': 'your_refresh_token'
}
Response: { "access_token": "...", "expires_in": 3600 }
```

### Get Devices

```dart
GET https://api.developer.atomberg-iot.com/devices
Headers: {
  'Authorization': 'Bearer {access_token}'
}
Response: [
  {
    "device_id": "ABC123",
    "name": "Living Room Fan",
    "series": "Gorilla",
    "mac": "AABBCCDDEEFF",
    ...
  }
]
```

### Send Command

```dart
POST https://api.developer.atomberg-iot.com/devices/{device_id}/command
Headers: {
  'Authorization': 'Bearer {access_token}'
}
Body: {
  "power": true,
  "speed": 3
}
```

---

## 🎮 Usage

### 1. Login

```
Launch App → Enter API Key → Enter Refresh Token → Tap Connect
```

### 2. View Devices

```
Dashboard → Pull to Refresh → Tap Device Card
```

### 3. Control Device

```
Device Screen → Toggle Power / Adjust Speed / Set Timer / etc.
```

### 4. Enable Local Control

```
Connect phone to same WiFi as fan → Green "Local" badge appears automatically
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/auth_provider_test.dart
```

**Test Coverage:**
- ✅ Unit Tests: Authentication, Device Management
- ✅ Widget Tests: Login Screen, Dashboard
- ✅ Integration Tests: E2E flows
- ✅ Manual Testing: Real device validation

---

## 📂 Project Structure

```
lib/
├── main.dart                              # App entry point
└── src/
    ├── config/
    │   ├── constants.dart                 # App constants
    │   ├── theme.dart                     # Theme configuration
    │   └── theme_provider.dart            # Theme state
    ├── core/
    │   ├── api_service.dart               # Hybrid API implementation
    │   └── services/
    │       ├── udp_device_discovery_service.dart  # UDP beacon listener
    │       ├── udp_discovery_provider.dart        # Riverpod providers
    │       └── permission_service.dart            # Permission handler
    ├── features/
    │   ├── auth/
    │   │   ├── data/
    │   │   │   └── auth_provider.dart     # Authentication state
    │   │   └── presentation/
    │   │       └── login_screen.dart      # Login UI
    │   ├── dashboard/
    │   │   ├── data/
    │   │   │   └── device_provider.dart   # Device list state
    │   │   ├── domain/
    │   │   │   └── device_model.dart      # Device entity
    │   │   └── presentation/
    │   │       └── dashboard_screen.dart  # Device list UI
    │   └── device_control/
    │       ├── data/
    │       │   └── device_control_provider.dart  # Control state
    │       └── presentation/
    │           └── device_control_screen.dart    # Control UI
    └── shared/
        └── widgets/                       # Reusable widgets
```

---

## 🔐 Permissions

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" />
```

### iOS (Info.plist)

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>Atomberg needs access to your local network to discover and control your smart fans directly.</string>
<key>NSBonjourServices</key>
<array>
  <string>_atomberg._udp</string>
</array>
```

---

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| 🔴 Local badge not showing | Ensure phone & fan on same WiFi |
| 🔴 Devices not loading | Check API credentials |
| 🔴 APK won't install | Enable "Install unknown apps" |
| 🔴 Slow response | Check WiFi connection |
| 🔴 Permission denied | Grant Local Network permission |

---

## 📊 Performance

| Metric | Local UDP | Cloud API |
|--------|-----------|-----------|
| Response Time | ~50ms | ~500ms |
| Speed Improvement | **10x faster** | Baseline |
| Offline Support | ✅ (if cached) | ❌ Requires internet |
| Battery Impact | Minimal | Minimal |
| Network Usage | ~500 bytes/cmd | ~1KB/cmd |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- [Atomberg Technologies](https://atomberg.com) for the IoT platform
- Flutter community for amazing packages
- Riverpod for excellent state management

---

## 📚 Documentation

- [Setup Instructions](SETUP_INSTRUCTIONS.txt) - End user guide
- [Assignment Report](ASSIGNMENT_REPORT.txt) - Detailed technical report
- [Local UDP Control](LOCAL_UDP_CONTROL.md) - UDP implementation details
- [API Schema](ATOMBERG_API_SCHEMA.md) - Complete API reference

---

<div align="center">

### ⭐ Star this repo if you find it helpful!

Made with ❤️ and Flutter

🌀 **Control your fans with the speed of light!** ⚡

</div>
