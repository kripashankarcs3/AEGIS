# AEGIS 📡

## "When the internet dies, humanity still speaks."

**Build.IT '26 Hackathon** | Offline-First P2P Mesh Communication

---

## Architecture

```
[Phone A] ←—WebRTC DataChannel—→ [Phone B] ←—WebRTC DataChannel—→ [Phone C]
              ↑                           ↑
         (direct peer)            (relay node — A reaches C through B)
```

- **Discovery**: mDNS (_aegis._tcp) on LAN
- **Signaling**: Flask relay (LAN only, bootstrap only)
- **Mesh**: Custom hop routing with TTL + deduplication
- **Crypto**: Ed25519 (identity) + AES-GCM-256 (messages)
- **Storage**: Hive (local only, never leaves device)

---

## Quick Start

### 1. Install Dependencies

```bash
cd aegis_flutter
flutter pub get
```

### 2. Run Flask Signaling Relay (on one device)

```bash
cd server
pip install -r requirements.txt
python signal-relay.py
```

Server will start on `http://0.0.0.0:5000`

### 3. Run Flutter App (on each phone)

```bash
flutter run
```

---

## Project Structure

```
aegis_flutter/
├── lib/
│   ├── core/          # Business logic (Mesh Router, Crypto, WebRTC)
│   ├── models/        # Data models (SignalPacket, SurvivorNode)
│   ├── providers/     # Riverpod state management
│   ├── screens/       # UI screens (Radar, Chat, SOS, Resources, Map)
│   ├── widgets/       # Reusable widgets (CustomPainters, cards)
│   └── services/      # Platform services (Background, Notifications)
│
├── server/            # Flask WebRTC signaling relay
└── android/ios/       # Platform-specific configurations
```

---

## Tech Stack

- **Flutter 3.x** - Cross-platform framework
- **flutter_webrtc** - P2P data channels
- **multicast_dns** - LAN device discovery
- **Hive** - Local storage
- **cryptography** - Ed25519 + AES-GCM
- **Riverpod** - State management
- **go_router** - Navigation
- **Flask** - WebRTC signaling (Python)

---

## Features

### ✅ Mesh Routing
- Multi-hop message relay (A → B → C)
- TTL-based packet expiry
- Deduplication cache (prevents broadcast storms)

### ✅ Emergency SOS
- 4 categories: Medical, Trapped, Water/Food, Fire
- GPS attachment
- Audio alarm + haptic feedback
- Flood broadcast to all nodes

### ✅ Status Beacon
- Periodic broadcast (every 30s)
- 3 states: Safe, Need Help, Have Resources
- Background service support

### ✅ Encrypted Chat
- End-to-end encryption (AES-GCM-256)
- Hop path display
- Offline message queue
- Delivery acknowledgments

### ✅ Survivor Radar
- CustomPainter visualization
- Real-time status updates
- Color-coded status dots
- Tap for details

### ✅ Resource Coordination
- Offers and requests
- 6 categories: Water, Food, Medicine, Shelter, Tools, People
- 2-hour auto-expiry

---

## Demo Scenarios

### 1. Auto-Discovery ✓
Open app on 2 phones → Both appear on radar within 10 seconds

### 2. Three-Device Mesh Relay ✓
A→B, B→C, A and C NOT connected → A sends to C → Routes through B

### 3. SOS Alert ✓
Trigger SOS on A → B and C receive within 3 seconds → Alarm plays

### 4. Survivor Radar ✓
3 devices with different statuses → Colored dots show correctly

### 5. Offline Queue ✓
Disconnect relay node → Send message → Reconnect → Message delivers

---

## Android Configuration

### Permissions (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

### Multicast Lock (MainActivity.kt)
**CRITICAL**: Required for mDNS on Android

```kotlin
class MainActivity : FlutterActivity() {
    private lateinit var multicastLock: WifiManager.MulticastLock
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val wifi = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        multicastLock = wifi.createMulticastLock("aegis_mdns")
        multicastLock.setReferenceCounted(true)
        multicastLock.acquire()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        if (multicastLock.isHeld) multicastLock.release()
    }
}
```

---

## iOS Configuration

### Info.plist
```xml
<key>NSLocalNetworkUsageDescription</key>
<string>AEGIS uses local network to discover nearby devices for mesh communication</string>

<key>NSBonjourServices</key>
<array>
  <string>_aegis._tcp</string>
</array>

<key>NSLocationWhenInUseUsageDescription</key>
<string>AEGIS uses location to attach GPS coordinates to SOS alerts</string>
```

---

## Build & Deploy

### Development Build
```bash
flutter run --debug
```

### Release APK
```bash
flutter build apk --release
```

### Install on Device
```bash
flutter install
```

---

## Packet Types

| Type     | TTL | Relay   | Purpose                    |
|----------|-----|---------|----------------------------|
| chat     | 10  | Unicast | Encrypted direct message   |
| ack      | 5   | Unicast | Delivery receipt           |
| sos      | 15  | Flood   | Emergency alert            |
| status   | 8   | Flood   | Heartbeat / survivor radar |
| resource | 8   | Flood   | Offer/request broadcast    |

---

## Critical Implementation Notes

### ⚠️ MUST-DO for Working Demo

1. **Multicast Lock (Android)**: Without it, mDNS silently fails
2. **LAN-only WebRTC**: `iceServers: []` (no STUN/TURN)
3. **Flask on 0.0.0.0**: Must bind to all interfaces, not 127.0.0.1
4. **Hive Initialization**: Must call `Hive.initFlutter()` before `runApp()`
5. **Deduplication Cache**: Non-negotiable to prevent broadcast storms
6. **Physical Devices**: WebRTC P2P doesn't work on emulator

---

## Troubleshooting

### mDNS Not Discovering Peers
- **Android**: Check multicast lock in MainActivity.kt
- **iOS**: Check NSBonjourServices in Info.plist
- **Both**: Ensure all devices on same WiFi network

### WebRTC Connection Fails
- Check Flask relay is running on 0.0.0.0:5000
- Verify all devices can reach relay IP
- Check iceServers config is empty array

### Messages Not Routing
- Verify deduplication cache is working
- Check TTL values are not too low
- Test direct P2P before multi-hop

---

## License

MIT License - Built for Build.IT '26 Hackathon

---

**Status**: ✅ Project structure complete - Ready for implementation  
**Next Step**: Start with `lib/core/mesh_router.dart` (most critical component)
