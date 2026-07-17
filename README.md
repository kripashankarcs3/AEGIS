# AEGIS — Offline Mesh Communication Platform

> *"When the Internet dies, humanity still speaks."*

**Build.IT '26 | Software Track: First Contact**

---

## 💡 The Idea

Every existing communication app — WhatsApp, Telegram, Signal — dies the moment the internet goes down. In disaster scenarios (earthquakes, floods, network outages), the people who need to communicate the most are left completely silent.

**AEGIS solves this.**

The core insight: smartphones already have 3 radios — WiFi, WiFi Direct, and Bluetooth. AEGIS uses all 3 simultaneously to form a **self-healing mesh network** between devices, with **no internet, no server, and no configuration required.**

When you open AEGIS, your phone automatically:
1. Discovers nearby AEGIS devices (within seconds)
2. Forms a cryptographic identity (`SIG-XXXX`) derived from an Ed25519 keypair
3. Joins the mesh — your device becomes both a communicator and a relay node

A message from Device A can travel **A → B → C → D** through intermediate devices, even if A and D are 600 meters apart and cannot directly see each other.

---

## 🚨 The Problem We're Solving

```
Normal day:     Phone A ──── Internet ──── Server ──── Phone B  ✅
Disaster day:   Phone A ──── ??? ──── Phone B  ❌

With AEGIS:     Phone A ──── (mesh) ──── Phone B  ✅  No internet needed
```

**Real scenarios where AEGIS works:**
- Earthquake — cell towers down, rescue teams need to coordinate
- Festival/stadium — network congested, friends need to find each other
- Remote area — no coverage, hiking group needs emergency communication
- Protest/blackout — internet cut, people need to stay connected

---

## 📡 How Devices Connect — All 4 Methods

AEGIS uses **4 different ways** to find and connect to nearby devices. All run simultaneously — whichever works first is used.

### Method 1: WiFi Direct (Nearby Connections)
```
Requirements : WiFi hardware ON (no router needed)
Range        : ~100–200 meters
Speed        : Fast
How it works : Uses Google's Nearby Connections API with P2P_CLUSTER strategy.
               Devices advertise and discover each other directly over WiFi Direct
               without any router, hotspot, or internet.

When it works: Both devices have WiFi turned on (even in airplane mode with WiFi on)
When it fails: WiFi hardware off, or Location permission denied
```

### Method 2: Bluetooth LE (BLE Fallback)
```
Requirements : Bluetooth ON
Range        : ~10–30 meters
Speed        : Slower
How it works : Device advertises its SIG-ID as BLE service data. Scanner picks it up,
               reads the SIG-ID from advertisement, shows peer on radar.
               Then connects via GATT for full data transfer.

When it works: Bluetooth on — no WiFi, no internet, no router needed at all
When it fails: Bluetooth off, or BLUETOOTH_SCAN/ADVERTISE permission denied
               Note: BLE advertising stops if app is fully killed
```

### Method 3: Same WiFi / Hotspot (mDNS)
```
Requirements : Both devices on SAME WiFi network or hotspot
Range        : Limited to LAN (~100m)
Speed        : Fastest (direct TCP)
How it works : mDNS (multicast DNS) service discovery on local network.
               Devices announce themselves as _aegis._tcp.local
               NOTE: Currently mDNS only discovers peers, direct TCP connection
               requires QR scan after discovery.

When it works: Both on same WiFi router OR one shares hotspot and other joins it
When it fails: Different networks, or Android firewall blocks multicast
```

### Method 4: QR Code Direct TCP
```
Requirements : Both devices on same WiFi/LAN (to know each other's IP)
Range        : Same LAN
Speed        : Fastest
How it works : Open Identity Screen → Show QR code.
               Other device scans QR → gets SIG-ID + IP + port → connects via TCP socket.
               This always works as long as devices can reach each other's IP.

When it works: Same WiFi, or one device is hotspot
When it fails: Different subnets, no shared network
```

---

## 🔄 Discovery Decision Flow

```
App starts → All 4 methods run simultaneously

Method 1 (WiFi Direct)  ──→ Peer found? ──→ Connect, exchange packets
Method 2 (BLE)          ──→ Peer found? ──→ Connect, exchange packets  
Method 3 (mDNS)         ──→ Peer found? ──→ Use QR for TCP
Method 4 (QR TCP)       ──→ Manual scan ──→ Connect directly

First successful connection wins.
All methods keep running — if one drops, others take over.
```

### Which method to use for demo?

| Scenario | Best Method |
|----------|------------|
| No WiFi, no router | BLE (Bluetooth on) |
| WiFi on but no router | WiFi Direct (Nearby) |
| Same hotspot/router | mDNS + QR TCP |
| Guaranteed connection | QR Code scan |

---

## 🏗 How It Works — Core Architecture

### Transport Layer (3 Radios + 1 Manual)

```
┌─────────────────────────────────────────────────────────────────┐
│                      AEGIS Transport                             │
│                                                                  │
│  WiFi Direct ──── No router needed ───── ~200m, Fast           │
│  (Nearby Connections — Google P2P)                               │
│                                                                  │
│  Bluetooth LE ─── No WiFi needed ──────── ~30m, Fallback       │
│  (BLE GATT)                                                      │
│                                                                  │
│  WiFi LAN ─────── Same hotspot/router ─── ~100m, Fast          │
│  (mDNS discovery → TCP)                                          │
│                                                                  │
│  QR Direct TCP ── Manual scan ────────── Same LAN, Reliable    │
│  (TCP Socket from Identity Screen)                               │
└─────────────────────────────────────────────────────────────────┘
```

### Mesh Routing (How Messages Travel)

```
Device A (0m) ──WiFi Direct──▶ Device B (200m) ──WiFi Direct──▶ Device C (400m)
                                      │
                               Also relays to
                                      │
                                Device D (350m)

Message from A to C:
  A creates packet: {id: "msg-001", from: "SIG-A", to: "SIG-C", ttl: 10}
  A sends to B
  B checks: "Is this for me? No. Is it a duplicate? No. TTL > 0? Yes."
  B appends itself to path: [SIG-A, SIG-B]
  B forwards to all its peers (except A)
  C receives, checks: "Is this for me? Yes."
  C delivers to chat service
```

**Loop Prevention:** Every packet has a unique ID. Each device caches seen IDs — duplicates are instantly dropped.

**TTL:** Each hop decrements TTL by 1. When TTL = 0, packet is dropped. Prevents infinite flooding.

### Identity System

```
First launch:
  Generate Ed25519 keypair (public + private key)
  SIG-ID = XOR-hash(public key bytes) → "SIG-7F3A"
  Store permanently in local Hive database

Result: Every device has a permanent cryptographic identity.
No accounts. No servers. No registration.
```

### SOS Emergency Flow

```
User selects category (Medical/Fire/Water/Trapped/Other)
User holds SOS button (3 seconds)
    ↓
App gets GPS coordinates (8s timeout, falls back to last known)
    ↓
Creates SOS packet: {type: sos, category: Medical, lat: X, lng: Y, ttl: 10}
    ↓
Floods to ALL nearby nodes simultaneously
    ↓
Every device within mesh range:
  - Shows full-screen red alert overlay
  - Displays sender SIG-ID, location, category, hop count
  - Audio alarm + vibration triggered
  - Can open chat directly from overlay
```

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Zero Infrastructure** | No internet, no server, no accounts required |
| **4-Layer Transport** | WiFi Direct + BLE + mDNS + QR TCP |
| **Mesh Relay** | Messages hop through intermediate devices — multi-hop range |
| **Encrypted Identity** | Ed25519 keypair — permanent, device-local, cryptographic |
| **SOS Alerts** | Emergency broadcast with category + GPS to all nearby nodes |
| **Status Beacon** | Periodic survivor status (Safe / Need Help / Have Resources) |
| **Resource Feed** | Share and request resources (water, food, medicine, shelter) |
| **Network Map** | Live visualization of mesh topology |
| **Offline-First** | All data stored locally with Hive — zero cloud dependency |
| **QR Connect** | Scan peer QR code to connect directly via TCP |
| **Chat History** | Messages persist across app restarts |
| **Emergency Contacts** | Store offline contacts for crisis situations |

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Android) — v2.0.0 |
| State Management | Riverpod (StateNotifier) `flutter_riverpod ^2.5.1` |
| Navigation | `go_router ^12.0.0` |
| Transport 1 — WiFi Direct | `nearby_connections ^4.0.0` (Google Nearby) |
| Transport 2 — Bluetooth LE | `flutter_blue_plus ^1.31.15` |
| Transport 3 — mDNS | `multicast_dns ^0.3.2+4` |
| Transport 4 — Direct TCP | `dart:io` ServerSocket / Socket |
| Transport 5 — WiFi LAN | `wifi_lan_service.dart` (direct LAN TCP) |
| Storage | Hive `^2.2.3` (offline-first NoSQL) |
| Cryptography | Ed25519 keypair (`cryptography ^2.7.0`) |
| Location | `geolocator ^10.1.0` |
| Audio / Alarm | `audioplayers ^5.2.1` |
| Notifications | `flutter_local_notifications ^18.0.1` |
| QR Generate | `qr_flutter ^4.1.0` |
| QR Scan | `mobile_scanner ^3.5.7` |
| Network Info | `network_info_plus ^6.0.0` |
| Permissions | `permission_handler ^11.3.1` |
| Image Picker | `image_picker ^1.0.7` (profile photos) |
| HTTP | `http ^1.2.1` |
| Utilities | `uuid ^4.4.0`, `path_provider ^2.1.2` |

---

## 📦 Packet Types

| Type | TTL | Mode | Purpose |
|------|-----|------|---------|
| `chat` | 10 | Unicast | Direct message to specific SIG-ID |
| `ack` | 5 | Unicast | Delivery receipt |
| `sos` | 10 | Broadcast | Emergency alert with GPS + category |
| `status` | 5 | Broadcast | Heartbeat — survivor radar updates |
| `resource` | 5 | Broadcast | Offer/request broadcast |

---

## 📁 Project Structure

```
aegis_flutter/
├── lib/
│   ├── main.dart                  ← App entry point
│   ├── app.dart                   ← Root widget, router setup
│   │
│   ├── constants/
│   │   ├── aegis_animations.dart  ← Shared animation constants
│   │   ├── aegis_colors.dart      ← Color palette
│   │   ├── aegis_colors_light.dart← Light theme color tokens
│   │   └── aegis_styles.dart      ← Text styles, spacing constants
│   │
│   ├── theme/
│   │   └── aegis_theme.dart       ← ThemeData (iOS-style light theme)
│   │
│   ├── core/
│   │   ├── mesh_router.dart       ← Multi-hop routing, dedup, TTL
│   │   ├── identity_manager.dart  ← Ed25519 keypair, SIG-ID generation
│   │   ├── sos_handler.dart       ← SOS send/receive/log
│   │   ├── status_beacon.dart     ← Periodic status broadcast
│   │   ├── resource_manager.dart  ← Resource share/receive
│   │   ├── peer_manager.dart      ← Active peer tracking
│   │   ├── message_queue.dart     ← Offline retry queue
│   │   ├── crypto_service.dart    ← Ed25519 sign/verify
│   │   └── mdns_discovery.dart    ← mDNS service lookup
│   │
│   ├── transport/
│   │   ├── transport_manager.dart ← Orchestrates all transports
│   │   ├── nearby_service.dart    ← WiFi Direct (Nearby Connections)
│   │   ├── bluetooth_service.dart ← BLE advertise + scan + GATT
│   │   ├── direct_tcp_service.dart← QR-initiated TCP socket server/client
│   │   └── wifi_lan_service.dart  ← LAN-based TCP transport
│   │
│   ├── providers/
│   │   ├── mesh_provider.dart     ← Central mesh coordinator
│   │   ├── chat_provider.dart     ← Per-peer chat state
│   │   ├── survivor_provider.dart ← All known peers state
│   │   ├── identity_provider.dart ← Local identity state
│   │   ├── mesh_send_provider.dart← Message send logic / status
│   │   ├── network_provider.dart  ← Network connectivity state
│   │   └── theme_provider.dart    ← Theme mode state
│   │
│   ├── models/
│   │   ├── signal_packet.dart     ← Core mesh packet model
│   │   ├── chat_message.dart      ← Chat message model
│   │   ├── survivor_node.dart     ← Peer node (runtime)
│   │   ├── survivor_node_model.dart← Peer node (Hive storage)
│   │   ├── peer_address.dart      ← Peer IP/port address
│   │   ├── resource_item.dart     ← Resource item (runtime)
│   │   └── resource_model.dart    ← Resource model (Hive storage)
│   │
│   ├── services/
│   │   ├── storage_service.dart   ← Hive read/write (plain Maps)
│   │   ├── notification_service.dart ← Local notifications
│   │   ├── background_service.dart← Background task management
│   │   └── signaling_service.dart ← Signaling coordination
│   │
│   ├── screens/
│   │   ├── splash_screen.dart     ← Launch → meshProvider.start()
│   │   ├── onboarding_screen.dart ← First-run onboarding
│   │   ├── login_join_screen.dart ← Identity setup / join mesh
│   │   ├── main_shell.dart        ← Root nav shell (bottom nav)
│   │   ├── radar_screen.dart      ← Live mesh radar / peer map
│   │   ├── chat_screen.dart       ← Peer list / chat inbox
│   │   ├── chat_conversation_screen.dart ← Per-peer conversation
│   │   ├── sos_screen.dart        ← SOS send UI (hold button)
│   │   ├── sos_incoming_overlay.dart ← Full-screen SOS alert
│   │   ├── resource_feed_screen.dart ← Share/request resources
│   │   ├── network_map_screen.dart← Mesh topology visualization
│   │   ├── network_scan_screen.dart← Active scan / discovery UI
│   │   ├── devices_network_screen.dart ← Connected device list
│   │   ├── identity_screen.dart   ← SIG-ID + QR code display
│   │   ├── qr_scanner_screen.dart ← QR scan for TCP connect
│   │   ├── broadcast_screen.dart  ← Broadcast message to all peers
│   │   ├── notifications_screen.dart ← In-app notification feed
│   │   ├── emergency_contacts_screen.dart ← Offline contact storage
│   │   ├── node_details_screen.dart ← Selected peer detail view
│   │   ├── status_history_screen.dart ← Survivor status log
│   │   ├── profile_screen.dart    ← Local user profile
│   │   ├── settings_screen.dart   ← App settings
│   │   ├── auto_sync_screen.dart  ← Auto-sync configuration
│   │   ├── battery_saver_screen.dart ← Battery saver settings
│   │   ├── share_file_screen.dart ← File sharing UI
│   │   ├── voice_message_screen.dart ← Voice message recording
│   │   ├── language_screen.dart   ← Language selection
│   │   ├── help_support_screen.dart ← Help & support
│   │   └── about_screen.dart      ← About AEGIS
│   │
│   └── widgets/
│       ├── radar_painter.dart     ← CustomPainter for radar UI
│       ├── sos_banner.dart        ← SOS notification banner
│       ├── resource_card.dart     ← Resource feed item card
│       ├── mesh_stats_bar.dart    ← Live mesh stats header bar
│       └── node_popup_card.dart   ← Peer node popup on radar tap
│
├── assets/
│   ├── sounds/                    ← SOS alarm audio files
│   └── images/logo.png
│
├── android/
│   ├── app/src/main/
│   │   ├── AndroidManifest.xml    ← All permissions
│   │   └── kotlin/.../MainActivity.kt ← BLE advertising, multicast lock
└── pubspec.yaml
```

---

## 🚀 Running the App

```bash
cd aegis_flutter
flutter pub get
flutter run
```

**Requirements:**
- Android device (API 21+), not emulator
- Grant permissions on first launch: Location, Nearby Devices, Bluetooth

**No server needed. No backend. No internet.**

**App Entry Flow:**
```
SplashScreen → meshProvider.start() → OnboardingScreen (first run) → LoginJoinScreen → MainShell
```

---

## 🎬 Demo Script (3 minutes)

### Setup
- 2 Android phones with AEGIS installed
- No internet required — airplane mode works if WiFi/BT on

### Steps

1. **Open AEGIS on both phones**
   - Each device auto-generates a SIG-ID (e.g., SIG-7F3A)
   - No signup, no account needed

2. **Watch radar screen** — within ~15 seconds, both devices appear as nodes

3. **Send a chat message** from Device A to Device B
   - Message delivered via mesh relay
   - Shows hop count and delivery status

4. **Trigger SOS on Device A**
   - Select category (e.g., Medical), hold button 3 seconds
   - Device B shows red full-screen alert with location and category
   - Device A shows "SOS Sent" confirmation

5. **Post a resource on Device A**
   - Tap Resources → "Offer Resource" → select Water
   - Device B sees it in real-time resource feed

6. **Show QR Connect**
   - Open Identity screen on Device A → show QR
   - Scan with Device B → instant TCP connection

---

## ⚙️ Android Permissions Explained

| Permission | Why Needed |
|------------|------------|
| `ACCESS_FINE_LOCATION` | Required by Android for WiFi Direct + BLE scan |
| `NEARBY_WIFI_DEVICES` | Required for Nearby Connections (Android 13+) |
| `BLUETOOTH_SCAN` | BLE scanning |
| `BLUETOOTH_ADVERTISE` | BLE advertising (so others find us) |
| `BLUETOOTH_CONNECT` | GATT connection after discovery |
| `CHANGE_WIFI_MULTICAST_STATE` | Required for mDNS multicast |
| `CAMERA` | QR code scanning |
| `POST_NOTIFICATIONS` | SOS + chat notifications |

---

## 🧪 Troubleshooting

### Devices not finding each other
1. **Check permissions** — Location must be ON (not just allowed, but GPS enabled on Android)
2. **WiFi Direct**: Make sure WiFi is on (router not needed, just hardware)
3. **BLE**: Make sure Bluetooth is on, and app is in foreground
4. **QR fallback**: Use QR scan if auto-discovery fails — guaranteed connection

### BLE not detecting
- Both devices must have Bluetooth on
- Keep app in foreground during discovery
- Give it ~15 seconds for first scan cycle to complete

### Nearby Connections failing
- Location permission must be ALWAYS or WHILE USING
- On Android 12+, "Nearby devices" permission must be granted

### Messages not delivering
- Check both devices show each other in radar
- Try QR scan to establish direct connection first

---

## Team

**AEGIS — Build.IT '26**
- Mesh routing + cryptography + transport integration
- UI/UX screens + animations
- Transport layers + Android platform configuration

---

*Minimum Viable Demo: 2 Android devices → open AEGIS → both detect each other → chat without internet.*
