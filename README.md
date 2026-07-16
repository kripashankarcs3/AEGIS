# AEGIS — Offline Mesh Communication Platform

> *"When the Internet dies, humanity still speaks."*

**Build.IT '26 | Software Track: First Contact**

---

## What is AEGIS?

AEGIS is an offline-first peer-to-peer mesh communication and emergency platform built with Flutter. It enables devices to communicate without internet, without servers, and without accounts — even when devices are not on the same WiFi network.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Zero Infrastructure** | No internet, no server, no accounts required |
| **3-Layer Transport** | WiFi LAN (mDNS) + WiFi Direct (Nearby Connections) + Bluetooth LE |
| **Mesh Relay** | Messages hop through intermediate devices — up to 200m range per hop |
| **Encrypted Chat** | Ed25519 identity + mesh-routed messages |
| **SOS Alerts** | Emergency broadcast to all nearby nodes with GPS |
| **Status Beacon** | Periodic survivor status updates (Safe / Need Help / Have Resources) |
| **Resource Feed** | Share and request resources (water, food, medicine, shelter) |
| **Network Map** | Live visualization of mesh topology |
| **Offline-First** | All data stored locally with Hive — works without connectivity |

---

## How It Works

```
Device A (200m) ←—WiFi Direct—→ Device B ←—WiFi Direct—→ Device C (200m)

A cannot reach C directly → A → B → C (2-hop relay)
Effective range = nodes × 200m
```

AEGIS uses 3 transport layers simultaneously:
- **WiFi LAN (mDNS)** — Same hotspot, fastest, ~100m
- **WiFi Direct (Nearby Connections)** — No shared WiFi needed, ~200m  
- **Bluetooth LE** — Last resort fallback, ~30m

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Android + iOS) |
| State Management | Riverpod |
| Transport Layer 1 | `multicast_dns` — mDNS discovery |
| Transport Layer 2 | `nearby_connections` — WiFi Direct |
| Transport Layer 3 | `flutter_blue_plus` — Bluetooth LE |
| Direct Connect | TCP Socket (via QR code scan) |
| Storage | Hive (local NoSQL) |
| Cryptography | Ed25519 keypair (`cryptography` package) |
| Notifications | `flutter_local_notifications` |
| Location | `geolocator` |

---

## Project Structure

```
aegis_flutter/
├── lib/
│   ├── core/          ← Mesh router, crypto, identity, SOS, beacons
│   ├── transport/     ← Nearby, Bluetooth, mDNS, Direct TCP
│   ├── providers/     ← Riverpod state (mesh, chat, identity, survivors)
│   ├── screens/       ← All UI screens
│   ├── models/        ← SignalPacket, SurvivorNode, ResourceItem
│   ├── services/      ← Storage (Hive), notifications, background
│   └── widgets/       ← Radar painter, SOS banner, resource card
├── android/
│   └── app/src/main/  ← AndroidManifest (permissions), MainActivity (multicast lock)
└── pubspec.yaml
```

---

## Running the App

```bash
cd aegis_flutter
flutter pub get
flutter run
```

Requirements:
- Android device (API 21+)
- Location permission (required for Nearby Connections)
- Nearby Devices permission (Android 12+)
- Bluetooth permissions

### Demo Script (3 minutes)

1. Open AEGIS on 2+ Android devices — identity auto-generated
2. Radar screen — devices appear as nodes within seconds
3. Send a chat message — delivered via mesh relay, hop path shown
4. Trigger SOS — hold button 3 seconds — all devices receive alert instantly
5. Post a resource — appears in all devices' resource feed
6. Network Map — live topology of all connected nodes

---

## Team

AEGIS — Build.IT '26

- Mesh routing + cryptography + transport integration
- UI/UX screens + animations
- Transport layers + Android platform configuration

---

## Architecture

See `architecture.md` for detailed system design including:

- Mesh routing algorithm (dedup, TTL, flood/unicast)
- Transport layer selection logic
- Data models and Hive schema
- Cryptographic identity design
