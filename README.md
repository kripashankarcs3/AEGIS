# AEGIS — Offline Mesh Communication Platform

> *"When the Internet dies, humanity still speaks."*

**Build.IT '26 | Software Track: First Contact**

---

## 💡 The Idea

Every existing communication app — WhatsApp, Telegram, Signal — dies the moment the internet goes down. In disaster scenarios (earthquakes, floods, network outages), the people who need to communicate the most are left completely silent.

**AEGIS solves this.**

The core insight: smartphones already have 3 radios — WiFi, WiFi Direct, and Bluetooth. AEGIS uses all 3 simultaneously to form a **self-healing mesh network** between devices, with no internet, no server, and no configuration required.

When you open AEGIS, your phone automatically:
1. Discovers nearby AEGIS devices (within seconds)
2. Forms a cryptographic identity (SIG-XXXX) derived from an Ed25519 keypair
3. Joins the mesh — your device becomes both a communicator and a relay node

A message from Device A can travel **A → B → C → D** through intermediate devices, even if A and D are 600 meters apart and cannot directly see each other. The more devices, the larger the network.

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

## How It Works

### Transport Layer (3 Radios Simultaneously)

```
┌─────────────────────────────────────────────────────────┐
│                    AEGIS Transport                       │
│                                                          │
│  WiFi LAN ──────── Same hotspot ──────── ~100m, Fast    │
│  (mDNS)                                                  │
│                                                          │
│  WiFi Direct ───── No shared WiFi ────── ~200m, Fast    │
│  (Nearby Connections)                                    │
│                                                          │
│  Bluetooth LE ──── No WiFi needed ────── ~30m, Slow     │
│  (BLE fallback)                                          │
└─────────────────────────────────────────────────────────┘
```

App automatically picks the best available transport. All 3 run simultaneously — first delivery wins, duplicates discarded.

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
  C sends ACK back to A via same mesh
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
User holds SOS button (3 seconds)
    ↓
App gets GPS coordinates (5s timeout)
    ↓
Creates SOS packet: {type: sos, category: Medical, gps: {lat, lng}, ttl: 15}
    ↓
Floods to ALL nearby nodes simultaneously
    ↓
Every device within mesh range receives it
    ↓
Full-screen red alert overlay shown
Audio alarm + vibration triggered
```

### QR Code Direct Connect

When WiFi Direct and mDNS both fail, devices can connect by scanning each other's QR code from the Identity screen. The QR encodes `SIG-ID + IP + port` for direct TCP connection.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Zero Infrastructure** | No internet, no server, no accounts required |
| **3-Layer Transport** | WiFi LAN (mDNS) + WiFi Direct (Nearby Connections) + Bluetooth LE |
| **Mesh Relay** | Messages hop through intermediate devices — up to 200m range per hop |
| **Encrypted Identity** | Ed25519 keypair — permanent, device-local, cryptographic |
| **SOS Alerts** | Emergency broadcast to all nearby nodes with GPS coordinates |
| **Status Beacon** | Periodic survivor status (Safe / Need Help / Have Resources) |
| **Resource Feed** | Share and request resources (water, food, medicine, shelter) |
| **Network Map** | Live visualization of mesh topology with real peer data |
| **Offline-First** | All data stored locally with Hive — zero cloud dependency |
| **QR Connect** | Scan peer QR code to connect directly via TCP |

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Android + iOS) |
| State Management | Riverpod |
| Transport Layer 1 | `multicast_dns` — mDNS/Bonjour discovery |
| Transport Layer 2 | `nearby_connections` — WiFi Direct (Google Nearby) |
| Transport Layer 3 | `flutter_blue_plus` — Bluetooth LE |
| Direct Connect | TCP Socket (via QR code scan) |
| Storage | Hive (local NoSQL, offline-first) |
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

**Requirements:**
- Android device (API 21+)
- Grant: Location, Nearby Devices, Bluetooth permissions on first launch

---

## Demo Script (3 minutes)

1. **Open AEGIS on 2+ Android devices** — SIG-ID auto-generated, no signup
2. **Radar screen** — devices discover each other within seconds, appear as nodes
3. **Send a chat message** — delivered via mesh relay, hop count shown
4. **Trigger SOS** — hold button 3 seconds — all devices receive red alert instantly
5. **Post a resource** — appears in all devices' resource feed in real-time
6. **Network Map** — live topology showing all connected nodes and relay paths

---

## Team

**AEGIS — Build.IT '26**
- Mesh routing + cryptography + transport integration
- UI/UX screens + animations  
- Transport layers + Android platform configuration

---

*Minimum Viable Demo: 2 Android devices on same hotspot → open AEGIS → chat without internet.*
