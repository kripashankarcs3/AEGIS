# AEGIS - Flutter Complete Plan vs Current Implementation

**Source**: Build.IT '26 Hackathon Plan (48 Hours)
**Date**: Extracted from PDF

---

## 🎯 CORE CONCEPT DIFFERENCE

### **ORIGINAL PLAN (requirements.md/architecture.md):**
- Same WiFi REQUIRED
- WebRTC for P2P connections
- Flask signaling server needed
- mDNS only (50-100m range)

### **NEW FLUTTER PLAN (PDF):**
- **NO same WiFi needed!** ✨
- **3 Transport Layers working simultaneously:**
  1. WiFi LAN (mDNS) - 50-100m, same WiFi
  2. **WiFi Direct (Nearby Connections)** - 100-200m, NO shared WiFi
  3. Bluetooth LE - 10-30m, fallback
- NO WebRTC, NO Flask server
- Auto-selects best transport

---

## 📊 KEY TECHNICAL DIFFERENCES

| Feature | OLD Plan | NEW Plan (PDF) |
|---------|----------|----------------|
| **Identity Format** | SIG-XXXX | **AGS-XXXX** |
| **Primary Transport** | WebRTC | **WiFi Direct (Nearby Connections)** |
| **Signaling** | Flask Server | **None (P2P direct)** |
| **Same WiFi?** | YES (required) | **NO (WiFi Direct works independently)** |
| **Max Range** | 50-100m | **200m (WiFi Direct)** |
| **Packages** | flutter_webrtc, flask | **nearby_connections, multicast_dns** |
| **Mesh Range** | 10 nodes = 1km | **10 nodes = 2km** |

---

## 🔧 PACKAGE DIFFERENCES

### **OLD Plan Packages:**
```yaml
flutter_webrtc: ^0.9.47       # ❌ NOT in new plan
dio: ^5.3.0                    # For Flask signaling
multicast_dns: ^0.3.2          # mDNS only
```

### **NEW Plan Packages (from PDF):**
```yaml
nearby_connections: ^4.0.0     # ✨ NEW - WiFi Direct
multicast_dns: ^0.3.2          # mDNS (same)
flutter_blue_plus: ^1.31.15    # ✨ NEW - Bluetooth LE
cryptography: ^2.7.0           # (same)
hive: ^2.2.3                   # (same)
```

**MAJOR CHANGE**: NO WebRTC! Uses Google's Nearby Connections API instead.

---

## 🏗️ FILE STRUCTURE DIFFERENCES

### **OLD Plan:**
```
lib/core/
  ├── mesh_router.dart
  ├── crypto_service.dart
  ├── mdns_discovery.dart
  ├── peer_manager.dart (WebRTC)
  └── NO transport folder
```

### **NEW Plan (PDF):**
```
lib/core/
  ├── mesh_router.dart (same concept)
  ├── crypto_service.dart (same)
  ├── identity_manager.dart (AGS-XXXX generator)
  └── message_queue.dart

lib/transport/  ← ✨ NEW FOLDER
  ├── transport_manager.dart (coordinates all 3)
  ├── wifi_lan_service.dart (mDNS)
  ├── nearby_service.dart (WiFi Direct) ← KEY
  └── bluetooth_service.dart (BLE)
```

---

## 💡 MESH ROUTING LOGIC

### Both plans have similar routing but different transport:

**Message Packet Structure - DIFFERENT NAMES:**

| Field | OLD Plan | NEW Plan |
|-------|----------|----------|
| Identity prefix | `SIG-` | `AGS-` |
| From field | `from: "SIG-7F3A"` | `from: "AGS-7F3A"` |
| Model name | `SignalPacket` | `AegisMessage` |

**Routing Logic**: ✅ SAME (TTL, dedup, hop count, path tracking)

---

## 📱 SCREENS COMPARISON

### **OLD Plan (6 core):**
1. Radar Screen
2. Chat Screen  
3. SOS Screen
4. Resource Feed Screen
5. Network Map Screen
6. Identity Screen

### **NEW Plan (6 core - SAME LIST):**
1. Radar Screen
2. Chat Screen
3. Broadcast Screen (similar to SOS)
4. (Resource feed not mentioned)
5. Network Map Screen
6. Identity Screen

**MATCH**: 90% same UI concept

---

## ⚡ TRANSPORT SELECTION LOGIC (NEW PLAN)

```dart
void selectBestTransport() {
  if (wifiLanAvailable && targetOnSameNetwork) {
    use(TransportType.wifiLAN);     // Fastest — same WiFi
  } else if (wifiDirectAvailable) {
    use(TransportType.wifiDirect);  // Medium — NO shared WiFi needed
  } else {
    use(TransportType.bluetooth);   // Slowest but always works
  }
}
```

**KEY INNOVATION**: All 3 run simultaneously, first delivery wins!

---

## 🎯 WHAT YOUR CURRENT CODE HAS

Let me check what's actually in your code vs both plans...
