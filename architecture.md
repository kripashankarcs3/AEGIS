# AEGIS Architecture Document

## Overview

**AEGIS** is an offline-first peer-to-peer mesh communication and emergency platform built with Flutter. The system enables local area network (LAN) communication without internet connectivity by forming a self-healing mesh network where devices auto-discover peers, route messages through intermediate nodes, and provide emergency coordination features.

**Core Principle**: "When the internet dies, humanity still speaks."

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │  Radar   │ │   Chat   │ │   SOS    │ │ Resources│       │
│  │  Screen  │ │  Screen  │ │  Screen  │ │  Screen  │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
│       ▲            ▲            ▲            ▲               │
└───────┼────────────┼────────────┼────────────┼───────────────┘
        │            │            │            │
┌───────┼────────────┼────────────┼────────────┼───────────────┐
│       ▼            ▼            ▼            ▼               │
│                 STATE MANAGEMENT (Riverpod)                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Providers: mesh, identity, survivors, chat, stats   │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
        │
┌───────┼──────────────────────────────────────────────────────┐
│       ▼          BUSINESS LOGIC LAYER                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Identity   │  │     Mesh     │  │     Chat     │       │
│  │   Manager    │  │    Router    │  │   Service    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │     SOS      │  │    Status    │  │   Resource   │       │
│  │    System    │  │    Beacon    │  │   Manager    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└──────────────────────────────────────────────────────────────┘
        │
┌───────┼──────────────────────────────────────────────────────┐
│       ▼              NETWORK LAYER                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   WebRTC     │  │   Discovery  │  │  Signaling   │       │
│  │   Manager    │  │   Service    │  │    Relay     │       │
│  │  (P2P Conn)  │  │   (mDNS)     │  │   (Flask)    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└──────────────────────────────────────────────────────────────┘
        │
┌───────┼──────────────────────────────────────────────────────┐
│       ▼              DATA LAYER                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           Storage Layer (Hive)                        │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────────┐    │   │
│  │  │Identity│ │Messages│ │SOS Log │ │  Resources │    │   │
│  │  │  Box   │ │  Box   │ │  Box   │ │    Box     │    │   │
│  │  └────────┘ └────────┘ └────────┘ └────────────┘    │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. Identity Manager

**Purpose**: Manages cryptographic identity for mesh network participation

**Architecture**:
- **Ed25519 Keypair Generation**: Uses `cryptography` package to generate asymmetric keypair on first launch
- **SIG-ID Derivation Algorithm**:
  ```
  1. Generate Ed25519 keypair (public key, private key)
  2. Compute SHA-256 hash of public key bytes
  3. Take first 4 hexadecimal characters of hash
  4. Format as "SIG-XXXX" (e.g., "SIG-7F3A")
  ```
- **Storage**: Persists keypair in Hive `identity` box
- **Permanence**: Never regenerates after initial creation

**Data Flow**:
```
App Launch → Check Hive identity box
  ├─ Exists → Load keypair → Return SIG-ID
  └─ Not Exists → Generate Ed25519 → Derive SIG-ID → Store → Return SIG-ID
```

---

### 2. Mesh Router (CORE COMPONENT)

**Purpose**: The heart of AEGIS - handles multi-hop packet routing with TTL and deduplication

**Architecture Components**:
1. **Deduplication Cache**: In-memory `Set<String>` storing packet IDs
   - Max size: 10,000 entries
   - Eviction: LRU (oldest 20% when full)
   - TTL per entry: 5 minutes
   
2. **Routing Table**: Map of known peers and reachable paths
   ```
   {
     "SIG-7F3A": {
       "directPeers": ["SIG-B2C1"],
       "reachableVia": {"SIG-C4E1": ["SIG-B2C1"]}
     }
   }
   ```

3. **Routing Algorithm**:
```
onReceivePacket(packet, fromPeer):
  // Step 1: Deduplication
  if packet.id in dedupCache:
    DROP packet
    return
  
  dedupCache.add(packet.id)
  
  // Step 2: TTL Check
  packet.ttl -= 1
  if packet.ttl <= 0:
    DROP packet
    stats.packetsDropped++
    return
  
  // Step 3: Type-based routing
  if packet.type in ["sos", "status", "resource"]:
    // Flood broadcast
    deliverLocally(packet)
    forwardToAllPeers(packet, except: fromPeer)
    return
  
  // Step 4: Unicast routing
  if packet.to == myIdentity:
    deliverLocally(packet)
    sendACK(packet)
    return
  
  if packet.to == "broadcast":
    deliverLocally(packet)
    forwardToAllPeers(packet, except: fromPeer)
    return
  
  // Step 5: Relay forwarding
  if myIdentity in packet.path:
    DROP packet  // Loop detected
    return
  
  packet.path.append(myIdentity)
  packet.hopCount += 1
  forwardToAllPeers(packet, except: fromPeer)
  stats.messagesRelayed++
```

**Performance**:
- Dedup cache lookup: < 1ms
- Routing decision: < 5ms
- Memory overhead: ~100KB for 10K cache entries

---

### 3. WebRTC Manager

**Purpose**: Manages peer-to-peer data channel connections

**Architecture**:
```
┌─────────────────────────────────────────────┐
│           WebRTC Manager                     │
│  ┌───────────────────────────────────────┐  │
│  │     Connection Pool                   │  │
│  │  Map<SIG_ID, RTCPeerConnection>      │  │
│  └───────────────────────────────────────┘  │
│  ┌───────────────────────────────────────┐  │
│  │     Data Channels                     │  │
│  │  Map<SIG_ID, RTCDataChannel>         │  │
│  └───────────────────────────────────────┘  │
│  ┌───────────────────────────────────────┐  │
│  │     Connection States                 │  │
│  │  connecting | connected | disconnected│  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**WebRTC Configuration** (LAN-only):
```javascript
{
  iceServers: [],  // NO STUN/TURN servers
  iceTransportPolicy: 'all'
}
```

**Connection Lifecycle**:
1. **Discovery**: mDNS provides peer IP + SIG-ID
2. **Signaling**: Exchange offer/answer via Flask relay
3. **ICE**: Local candidates only (LAN)
4. **Data Channel**: Open reliable ordered channel
5. **Monitoring**: Heartbeat every 10s
6. **Reconnection**: Auto-retry after 5s on disconnect


**Signaling Flow**:
```
Device A                  Flask Relay              Device B
   │                           │                       │
   │─ POST /offer ────────────>│                       │
   │  {id: "SIG-A", sdp: ...}  │                       │
   │                           │<─ GET /offer/SIG-A ───│
   │                           │─ return offer ───────>│
   │                           │                       │
   │                           │<─ POST /answer ───────│
   │                           │  {id: "SIG-A", ...}   │
   │<─ GET /answer/SIG-B ──────│                       │
   │                           │                       │
   │<══════ WebRTC DataChannel established ═══════════>│
```

---

### 4. Discovery Service (mDNS)

**Purpose**: Auto-discover AEGIS devices on LAN without manual configuration

**mDNS Service Specification**:
- **Service Type**: `_aegis._tcp`
- **Domain**: `local`
- **Port**: 5000 (WebRTC signaling)
- **TXT Records**: 
  - `sig_id=SIG-XXXX`
  - `version=2.0.0`

**Discovery Algorithm**:
```
onAppStart():
  // Step 1: Advertise self
  advertise(
    service: "_aegis._tcp",
    port: 5000,
    txt: {sig_id: myIdentity, version: "2.0.0"}
  )
  
  // Step 2: Scan for peers
  scanInterval = every 5 seconds:
    discoveredServices = mdns.scan("_aegis._tcp")
    
    for service in discoveredServices:
      if service.sig_id != myIdentity:
        if service.sig_id not in knownPeers:
          emit(PeerDiscovered{
            sigId: service.sig_id,
            ip: service.ipAddress,
            port: service.port
          })
```

**Platform-Specific**:
- **Android**: Requires `WifiManager.MulticastLock` acquisition in MainActivity
- **iOS**: Requires `NSBonjourServices` in Info.plist

---

### 5. Chat Service

**Purpose**: End-to-end encrypted messaging with offline queue

**Encryption Architecture**:
```
┌─────────────────────────────────────────────────┐
│            E2E Encryption Flow                   │
│                                                  │
│  Sender                            Recipient     │
│    │                                    │        │
│    ├─ Compose message                  │        │
│    ├─ ECDH(myPrivKey, theirPubKey)     │        │
│    │  → sharedSecret                   │        │
│    ├─ AES-GCM-256.encrypt(             │        │
│    │    message, sharedSecret)          │        │
│    │  → ciphertext                      │        │
│    ├─ Ed25519.sign(ciphertext)         │        │
│    │  → signature                       │        │
│    │                                    │        │
│    └─ SignalPacket{                    │        │
│         payload: ciphertext,            │        │
│         signature: signature            │        │
│       }                                 │        │
│         │                               │        │
│         └──────── Mesh Router ─────────>│        │
│                                         │        │
│                              ├─ Verify signature │
│                              ├─ ECDH(myPrivKey,  │
│                              │   theirPubKey)    │
│                              │  → sharedSecret   │
│                              ├─ AES-GCM-256.     │
│                              │   decrypt()       │
│                              └─ Display message  │
└─────────────────────────────────────────────────┘
```

**Message Queue Architecture**:
```
┌─────────────────────────────────────────┐
│        Offline Message Queue             │
│  ┌───────────────────────────────────┐  │
│  │   Hive Box: "messages"            │  │
│  │  {                                │  │
│  │    msgId: uuid,                   │  │
│  │    to: SIG-ID,                    │  │
│  │    packet: SignalPacket,          │  │
│  │    status: "pending" | "sent",    │  │
│  │    attempts: number,              │  │
│  │    timestamp: epoch               │  │
│  │  }                                │  │
│  └───────────────────────────────────┘  │
│                                          │
│  Retry Logic: Every 30 seconds          │
│  Max Attempts: Infinite (until ack)     │
└─────────────────────────────────────────┘
```

---

### 6. SOS System

**Purpose**: Emergency alert broadcasting with audio/haptic feedback

**Alert Propagation Strategy**:
```
User Activates SOS
  │
  ├─ Get GPS coordinates (timeout: 5s)
  ├─ Create SignalPacket:
  │    type: "sos"
  │    ttl: 15  (higher for emergency)
  │    alarm: true
  │    category: Medical | Trapped | Water/Food | Fire
  │    gps: {lat, lng, accuracy}
  │
  ├─ Trigger local feedback:
  │    ├─ HapticFeedback.heavyImpact()
  │    └─ Vibration(pattern: [200ms, 100ms, 200ms])
  │
  ├─ Store in SOS log (Hive)
  ├─ Flood broadcast via Mesh Router
  └─ Enforce 60-second cooldown
```

**Reception Flow**:
```
SOS Packet Received
  │
  ├─ Display full-screen red overlay
  │    ├─ Sender: SIG-XXXX
  │    ├─ Category: Medical Emergency
  │    ├─ GPS: 37.7749° N, 122.4194° W
  │    ├─ Time: 2 seconds ago
  │    └─ [Open Chat] button
  │
  ├─ Play audio alarm (3-beep pattern):
  │    Beep(800Hz, 300ms) → Silence(200ms) → 
  │    Beep(800Hz, 300ms) → Silence(200ms) → 
  │    Beep(800Hz, 300ms)
  │
  ├─ Haptic vibration (2 seconds)
  ├─ Local notification (if backgrounded)
  └─ Store in SOS log
```

---

### 7. Status Beacon

**Purpose**: Periodic survivor status broadcasting

**Beacon Architecture**:
```
┌────────────────────────────────────────┐
│        Status Beacon Service            │
│  ┌──────────────────────────────────┐  │
│  │   Timer: Every 30 seconds        │  │
│  │   Background: Foreground Service │  │
│  └──────────────────────────────────┘  │
│                 │                       │
│                 ▼                       │
│  ┌──────────────────────────────────┐  │
│  │  Broadcast Status Packet:        │  │
│  │    - status: Safe | NeedHelp |   │  │
│  │              HaveResources       │  │
│  │    - gps: current location       │  │
│  │    - resources: [list]           │  │
│  │    - ttl: 10                     │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```


**Background Service Design**:
- **Android**: Uses `flutter_background_service` with foreground notification
  - Notification: "AEGIS mesh active - 3 survivors nearby"
  - Channel: Importance LOW (non-intrusive)
- **iOS**: Background location updates mode
  - Limitation: Pauses when app fully terminated (acceptable for hackathon)

---

### 8. Resource Manager

**Purpose**: Coordinate resource offers and requests

**Resource Lifecycle**:
```
Create Resource
  │
  ├─ User Input:
  │    ├─ Type: Offer | Request
  │    ├─ Category: Water | Food | Medicine | Shelter | Tools | People
  │    ├─ Quantity: text field
  │    └─ Message: description
  │
  ├─ Create SignalPacket:
  │    type: "resource"
  │    subtype: offer | request
  │    category: selected
  │    quantity: value
  │    expires: now + 2 hours (epoch ms)
  │    ttl: 10
  │
  └─ Flood broadcast
       │
       └─ All Peers Receive
            │
            ├─ Store in Hive resource-feed box
            ├─ Display in Resource Feed UI
            │
            └─ Auto-expire after 2 hours:
                 if now > expires:
                   remove from feed
                   show "Expired" badge
```

---

## Data Models

### SignalPacket Schema

```typescript
interface SignalPacket {
  // Core routing fields
  id: string;              // UUID v4
  from: string;            // SIG-XXXX
  to: string | null;       // SIG-XXXX or "broadcast" or null
  path: string[];          // Array of SIG-IDs (relay path)
  hopCount: number;        // Incremented at each hop
  ttl: number;             // Decremented at each hop
  timestamp: string;       // ISO 8601
  type: PacketType;        // "chat" | "ack" | "sos" | "status" | "resource"
  
  // Optional fields (type-specific)
  payload?: string;        // Encrypted for "chat", plaintext for others
  signature?: string;      // Ed25519 signature (base64)
  
  // SOS + Status fields
  gps?: {
    lat: number;
    lng: number;
    accuracy: number;
  };
  alarm?: boolean;         // Trigger audio alarm
  
  // SOS-specific
  category?: "medical" | "trapped" | "water" | "fire" | "all_clear";
  message?: string;
  
  // Status-specific
  status?: "safe" | "need_help" | "have_resources";
  resources?: string[];
  
  // Resource-specific
  subtype?: "offer" | "request";
  resCategory?: "water" | "food" | "medicine" | "shelter" | "tools" | "people";
  quantity?: string;
  expires?: number;        // Epoch ms
}
```


### SurvivorNode Model

```typescript
interface SurvivorNode {
  sigId: string;              // SIG-XXXX
  status: NodeStatus;         // safe | need_help | have_resources | unknown
  gps?: {
    lat: number;
    lng: number;
    accuracy: number;
  };
  resources: string[];
  lastSeen: number;           // Epoch ms
  isDirectConnection: boolean;
  hopDistance: number;        // 0 = direct, 1+ = via relay
}
```

### Hive Box Schemas

#### Identity Box
```dart
Box: "identity"
Key: "current"
Value: {
  publicKey: Uint8List,
  privateKey: Uint8List,
  sigId: String,
  createdAt: int (epoch ms)
}
```

#### Messages Box
```dart
Box: "messages"
Key: UUID (message ID)
Value: {
  to: String (SIG-ID),
  from: String (SIG-ID),
  payload: String (encrypted),
  timestamp: int,
  status: "pending" | "sent" | "delivered",
  packet: Map<String, dynamic> (serialized SignalPacket)
}
```

#### SOS Log Box
```dart
Box: "sos_log"
Key: timestamp_sigId
Value: {
  from: String,
  category: String,
  message: String,
  gps: Map?,
  timestamp: int,
  receivedAt: int
}
```

#### Resource Feed Box
```dart
Box: "resource_feed"
Key: UUID (resource ID)
Value: {
  from: String,
  subtype: "offer" | "request",
  category: String,
  quantity: String,
  message: String,
  expires: int,
  timestamp: int
}
```

---

## UI Architecture

### Screen Hierarchy

```
MaterialApp (go_router)
│
├─ ShellRoute (Bottom Navigation)
│   │
│   ├─ /radar (RadarScreen) ← Default
│   │   └─ CustomPainter: RadarPainter
│   │       ├─ Concentric circles
│   │       ├─ Rotating sweep animation (60fps)
│   │       ├─ Node dots with glow
│   │       ├─ Connection lines
│   │       └─ Message travel animation
│   │
│   ├─ /chat (ChatScreen)
│   │   ├─ Contact list
│   │   └─ /chat/:nodeId (ChatDetailScreen)
│   │       ├─ Message bubbles
│   │       ├─ Hop path badges
│   │       └─ E2E encryption indicator
│   │
│   ├─ /sos (SosScreen)
│   │   ├─ Category picker (2x2 grid)
│   │   ├─ GPS status
│   │   ├─ Message input
│   │   ├─ Big red send button
│   │   └─ SOS log list
│   │
│   ├─ /resources (ResourceFeedScreen)
│   │   ├─ TabBar: All | Offers | Requests
│   │   ├─ Resource cards
│   │   └─ FAB: Create resource
│   │
│   └─ /map (NetworkMapScreen)
│       └─ CustomPainter: NetworkGraphPainter
│           ├─ Force-directed layout
│           ├─ Node circles with labels
│           ├─ Edge lines with hop counts
│           └─ Spring physics (60fps)
│
└─ Overlays
    ├─ SOSBanner (full-screen red)
    └─ NodePopupCard (bottom sheet)
```


### State Management (Riverpod)

```dart
// Core Providers
Provider<MeshRouter> meshRouterProvider
Provider<WebRTCManager> webrtcManagerProvider
Provider<CryptoService> cryptoServiceProvider

// State Providers
StateNotifierProvider<PeersNotifier, Map<String, RTCDataChannel>> connectedPeersProvider
StateNotifierProvider<SurvivorMapNotifier, Map<String, SurvivorNode>> survivorMapProvider
StateNotifierProvider<ChatHistoryNotifier, Map<String, List<Message>>> chatHistoryProvider
StateNotifierProvider<ResourceFeedNotifier, List<Resource>> resourceFeedProvider
StateNotifierProvider<MeshStatsNotifier, MeshStats> meshStatsProvider

// Async Providers
FutureProvider<SignalIdentity> myIdentityProvider
StreamProvider<PeerDiscovery> peerDiscoveryProvider
```

**Data Flow Pattern**:
```
UI Event
  │
  ├─> Read Provider (UI renders from state)
  │
  ├─> Modify Provider (user action)
  │     │
  │     ├─> StateNotifier.updateState()
  │     │
  │     └─> Business Logic Layer
  │           │
  │           └─> Network/Storage Layer
  │                 │
  │                 └─> Callback updates StateNotifier
  │                       │
  │                       └─> UI auto-rebuilds
```

---

## CustomPainter Rendering

### RadarPainter Architecture

```dart
class RadarPainter extends CustomPainter {
  // Animation Controller: 60fps sweep rotation
  
  paint(Canvas canvas, Size size) {
    // Layer 1: Background gradient
    drawRadialGradient(
      center: #0D2010,
      edge: #0D1117
    )
    
    // Layer 2: Concentric circles
    for radius in [100, 200, 300, 400]:
      drawCircle(
        center: size.center,
        radius: radius,
        color: rgba(15, 157, 88, 0.08)
      )
    
    // Layer 3: Sweep line (animated)
    drawLine(
      start: size.center,
      end: polarToCartesian(angle, maxRadius),
      gradient: green → transparent
    )
    
    // Layer 4: Connection lines
    for connection in directConnections:
      drawLine(peer1.pos, peer2.pos, opacity: 0.3)
    
    // Layer 5: Node dots with glow
    for node in survivorNodes:
      // Glow effect using MaskFilter.blur
      drawCircle(
        position: node.screenPosition,
        radius: 8,
        color: statusColor(node.status),
        blur: MaskFilter.blur(BlurStyle.normal, 10)
      )
      
      // Pulsing animation for "need_help"
      if node.status == needHelp:
        drawCircle(
          radius: 8 * pulseScale(time),
          opacity: fade(time)
        )
    
    // Layer 6: Labels
    for node in survivorNodes:
      drawText(node.sigId, position: below node)
  }
}
```


### NetworkGraphPainter Architecture

**Force-Directed Layout Algorithm**:
```
// Spring physics simulation
function updatePositions(deltaTime):
  for each node:
    // Repulsion: All nodes push each other apart
    for otherNode in allNodes:
      if node != otherNode:
        distance = distanceBetween(node, otherNode)
        repulsionForce = REPULSION_CONSTANT / (distance^2)
        node.velocity += directionTo(otherNode) * -repulsionForce
    
    // Attraction: Connected nodes pull together
    for connectedNode in node.connections:
      distance = distanceBetween(node, connectedNode)
      attractionForce = distance * SPRING_CONSTANT
      node.velocity += directionTo(connectedNode) * attractionForce
    
    // Damping
    node.velocity *= DAMPING_FACTOR
    
    // Update position
    node.position += node.velocity * deltaTime
    
    // Boundary constraint
    node.position = clamp(node.position, canvasBounds)
```

---

## Storage Layer Architecture

### Hive Initialization Sequence

```
main() async {
  // CRITICAL: Order matters
  
  // 1. Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Hive
  await Hive.initFlutter();
  
  // 3. Register TypeAdapters (if any custom types)
  // Hive.registerAdapter(SignalPacketAdapter());
  
  // 4. Open boxes
  await Hive.openBox('identity');
  await Hive.openBox('messages');
  await Hive.openBox('sos_log');
  await Hive.openBox('resource_feed');
  
  // 5. Run app
  runApp(
    ProviderScope(
      child: AegisApp(),
    ),
  );
}
```

**Box Access Pattern**:
```dart
// Write
final box = Hive.box('identity');
await box.put('current', identityData);

// Read
final identity = box.get('current');

// Delete
await box.delete(key);

// Clear all
await box.clear();
```

---

## Platform-Specific Architecture

### Android Configuration

**AndroidManifest.xml Permissions**:
```xml
<!-- Network -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- Location -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- Background -->
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<!-- Alerts -->
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- QR Scanner -->
<uses-permission android:name="android.permission.CAMERA"/>
```

**MainActivity.kt Multicast Lock**:
```kotlin
class MainActivity : FlutterActivity() {
    private lateinit var multicastLock: WifiManager.MulticastLock
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val wifi = applicationContext
            .getSystemService(Context.WIFI_SERVICE) as WifiManager
        
        multicastLock = wifi.createMulticastLock("aegis_mdns")
        multicastLock.setReferenceCounted(true)
        multicastLock.acquire()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        if (multicastLock.isHeld) {
            multicastLock.release()
        }
    }
}
```


### iOS Configuration

**Info.plist**:
```xml
<key>NSLocalNetworkUsageDescription</key>
<string>AEGIS uses local network to discover nearby devices for mesh communication - no internet required</string>

<key>NSBonjourServices</key>
<array>
  <string>_aegis._tcp</string>
</array>

<key>NSLocationWhenInUseUsageDescription</key>
<string>AEGIS uses location to attach GPS coordinates to SOS alerts and status updates</string>

<key>NSCameraUsageDescription</key>
<string>AEGIS uses camera to scan QR codes for peer discovery</string>

<key>UIBackgroundModes</key>
<array>
  <string>location</string>
</array>
```

---

## Flask Signaling Relay Architecture

**Purpose**: Minimal LAN-only WebRTC signaling server

**Server Architecture**:
```python
# In-memory storage (no persistence needed)
offers = {}      # {peer_id: sdp_offer}
answers = {}     # {peer_id: sdp_answer}
ice = {}         # {peer_id: [ice_candidates]}

# Endpoints
POST /offer       → Store offer
GET  /offer/:id   → Retrieve offer
POST /answer      → Store answer
GET  /answer/:id  → Retrieve answer
POST /ice         → Store ICE candidate
GET  /ice/:id     → Retrieve ICE candidates
GET  /peers       → List all peers with offers
```

**Network Binding**:
- Must bind to `0.0.0.0:5000` (NOT `127.0.0.1`)
- Accessible to all devices on LAN
- No authentication (LAN-only trusted environment)

**Lifecycle**:
1. One device on the network runs the Flask server
2. All devices connect to that IP for signaling
3. After WebRTC connection established, relay no longer needed
4. Relay only handles initial handshake

---

## Security Architecture

### Threat Model

**In Scope**:
- Message confidentiality (E2E encryption)
- Identity verification (signature verification)
- Message integrity (tampering detection)

**Out of Scope** (LAN trusted environment):
- Denial of service attacks
- Sybil attacks (multiple fake identities)
- Network-level attacks (packet injection)

### Cryptographic Design

**Key Hierarchy**:
```
Ed25519 Keypair (Identity)
  ├─ Private Key → Stored in Hive (never transmitted)
  ├─ Public Key → Shared in SignalPackets
  └─ SIG-ID → Derived from SHA-256(Public Key)

ECDH Shared Secret (Chat)
  ├─ Sender: ECDH(myPrivateKey, recipientPublicKey)
  └─ Recipient: ECDH(myPrivateKey, senderPublicKey)
       └─ Same shared secret (Diffie-Hellman)

AES-GCM-256 Session Key
  ├─ Derived from ECDH shared secret
  ├─ Used for message encryption
  └─ Authenticated encryption (integrity + confidentiality)
```

**Signature Scheme**:
```
Sign:
  1. Serialize SignalPacket to JSON (exclude signature field)
  2. Compute Ed25519 signature using private key
  3. Base64 encode signature
  4. Add to SignalPacket.signature field

Verify:
  1. Extract signature from SignalPacket
  2. Remove signature field from packet
  3. Serialize to JSON
  4. Verify Ed25519 signature using sender's public key
  5. Reject packet if verification fails
```

---

## Performance Architecture

### Key Performance Targets

| Metric | Target | Component |
|--------|--------|-----------|
| Peer discovery time | < 10 seconds | mDNS Discovery |
| SOS alert propagation | < 3 seconds | Mesh Router |
| Dedup cache lookup | < 1 ms | Mesh Router |
| Routing decision | < 5 ms | Mesh Router |
| Radar frame rate | 60 fps | RadarPainter |
| Network map frame rate | 60 fps | NetworkGraphPainter |
| Message encryption | < 50 ms | Chat Service |
| Hive read | < 50 ms | Storage Layer |
| Hive write | < 100 ms | Storage Layer |

### Memory Budget

| Component | Budget | Notes |
|-----------|--------|-------|
| Dedup cache | 100 KB | 10K entries @ 10 bytes each |
| Routing table | 50 KB | ~500 nodes |
| WebRTC connections | 5 MB | ~50 peers @ 100KB each |
| UI rendering | 20 MB | Canvas, animations |
| Hive boxes | 10 MB | Local storage |
| **Total** | **< 200 MB** | During normal operation |

### Optimization Strategies

1. **Dedup Cache**:
   - LRU eviction (oldest 20%)
   - Time-based expiry (5 minutes)
   - Periodic cleanup

2. **Routing Table**:
   - Lazy population (only discovered nodes)
   - Stale entry removal (no update in 2 minutes)

3. **UI Rendering**:
   - RepaintBoundary for expensive widgets
   - CustomPainter shouldRepaint optimization
   - Throttle radar sweep to 60fps max

4. **Network**:
   - Batch status updates (30s intervals)
   - Compress large payloads (future)
   - Connection pooling (reuse WebRTC)

---

## Testing Architecture

### Property-Based Testing Approach

**SignalPacket Round-Trip Property**:
```
Property: Serialization Invertibility
  forAll packet in validSignalPackets:
    toJson(packet) |> fromJson |> toJson
      MUST equal toJson(packet)
```

**Mesh Routing Properties**:
```
Property: Deduplication
  forAll packet in packets:
    meshRouter.receive(packet)
    meshRouter.receive(packet)  // Second time
      MUST drop second packet

Property: TTL Enforcement
  forAll packet in packets:
    packet.ttl = 0
    meshRouter.receive(packet)
      MUST drop packet

Property: Loop Detection
  forAll packet in packets:
    packet.path = ["SIG-A", "SIG-B"]
    myIdentity = "SIG-B"
    meshRouter.receive(packet)
      MUST drop packet (loop)
```

### Demo Test Scenarios

**Scenario 1: Auto-Discovery**
```
Given: 2 AEGIS devices on same WiFi
When: Both apps start
Then: Devices discover each other within 10 seconds
And: Radar shows peer dot
```

**Scenario 2: Three-Device Mesh Relay**
```
Given: Devices A, B, C
And: A connects to B, B connects to C
And: A and C NOT directly connected
When: A sends chat to C
Then: Message routes A → B → C
And: C displays "Delivered via 2 hops: SIG-A → SIG-B → SIG-C"
```

**Scenario 3: SOS Propagation**
```
Given: 3 devices in mesh
When: Device A triggers SOS alert
Then: Devices B and C receive alert within 3 seconds
And: Both play alarm sound
And: Both show red overlay banner
```

**Scenario 4: Offline Queue**
```
Given: Devices A, B, C where B relays A↔C
When: B disconnects
And: A sends message to C
Then: Message queued with "pending" indicator
When: B reconnects
Then: Message delivers within 15 seconds
```

---

## Build & Deployment Architecture

### Project Structure

```
aegis_flutter/
├── lib/
│   ├── main.dart                    # App entry, Riverpod, Hive init
│   ├── app.dart                     # MaterialApp, theme, router
│   │
│   ├── core/                        # Business logic layer
│   │   ├── mesh_router.dart         # ⭐ CORE: Routing algorithm
│   │   ├── crypto_service.dart      # Identity, encryption
│   │   ├── peer_manager.dart        # WebRTC pool
│   │   ├── mdns_discovery.dart      # mDNS service
│   │   ├── sos_handler.dart         # SOS logic
│   │   ├── status_beacon.dart       # Periodic broadcast
│   │   ├── resource_manager.dart    # Resource logic
│   │   └── message_queue.dart       # Offline queue
│   │
│   ├── models/                      # Data models
│   │   ├── signal_packet.dart       # Universal packet
│   │   ├── survivor_node.dart       # Radar node
│   │   └── resource_item.dart       # Resource model
│   │
│   ├── providers/                   # Riverpod state
│   │   ├── mesh_provider.dart
│   │   ├── identity_provider.dart
│   │   ├── survivor_provider.dart
│   │   └── chat_provider.dart
│   │
│   ├── screens/                     # UI screens
│   │   ├── radar_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── sos_screen.dart
│   │   ├── resource_feed_screen.dart
│   │   ├── network_map_screen.dart
│   │   └── identity_screen.dart
│   │
│   ├── widgets/                     # Reusable widgets
│   │   ├── radar_painter.dart       # CustomPainter
│   │   ├── network_graph_painter.dart
│   │   ├── sos_banner.dart
│   │   ├── node_popup_card.dart
│   │   ├── resource_card.dart
│   │   ├── hop_path_badge.dart
│   │   ├── status_picker.dart
│   │   └── mesh_stats_bar.dart
│   │
│   └── services/                    # Platform services
│       ├── background_service.dart
│       ├── notification_service.dart
│       └── storage_service.dart
│
├── server/                          # Flask signaling relay
│   ├── signal-relay.py
│   └── requirements.txt
│
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml      # Permissions
│       └── kotlin/.../MainActivity.kt # Multicast lock
│
├── ios/
│   └── Runner/
│       └── Info.plist               # iOS permissions
│
├── pubspec.yaml                     # Dependencies
└── README.md
```

### Build Phases

**Phase 1: Foundation** (Hours 0-2)
- Flutter project scaffold
- Dependencies in pubspec.yaml
- Navigation (5 tabs)
- Dark theme applied

**Phase 2: Identity + Storage** (Hours 2-5)
- CryptoService (Ed25519 + SIG-ID)
- Hive initialization
- Identity persistence

**Phase 3: P2P Connection** (Hours 5-12)
- WebRTC Manager
- mDNS Discovery
- Flask relay
- DataChannel exchange

**Phase 4: Mesh Routing** (Hours 12-20) ⭐ CRITICAL
- MeshRouter implementation
- Deduplication cache
- 3-device relay testing

**Phase 5: Emergency Features** (Hours 20-35)
- SOS System
- Status Beacon
- Resource Manager
- Radar visualization

**Phase 6: Chat + Polish** (Hours 35-44)
- E2E encryption
- Offline queue
- Network map
- UI refinements

**Phase 7: Demo Prep** (Hours 44-48)
- Test 5 demo scenarios
- Build APK
- Device installation

---

## Technology Stack

### Flutter Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # P2P / WebRTC
  flutter_webrtc: ^0.9.47
  
  # LAN Discovery
  multicast_dns: ^0.3.2+4
  
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  
  # Navigation
  go_router: ^12.0.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Encryption
  cryptography: ^2.7.0
  
  # HTTP (signaling)
  dio: ^5.3.0
  
  # Location
  geolocator: ^10.1.0
  
  # Audio / Alarm
  audioplayers: ^5.2.1
  
  # Notifications
  flutter_local_notifications: ^16.1.0
  
  # Background Service
  flutter_background_service: ^5.0.5
  
  # QR Code
  qr_flutter: ^4.1.0
  mobile_scanner: ^3.5.5
  
  # Utilities
  uuid: ^4.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  hive_generator: ^2.0.1
```

### Backend Stack

- **Language**: Python 3.11+
- **Framework**: Flask 3.0
- **CORS**: flask-cors
- **Deployment**: Local LAN only
- **Port**: 5000

---

## Critical Design Decisions

### 1. Why Ed25519?

- **Fast**: Signature generation/verification < 1ms
- **Small**: 32-byte public keys, 64-byte signatures
- **Secure**: 128-bit security level
- **Mobile-friendly**: Low CPU usage

### 2. Why AES-GCM?

- **Authenticated**: Detects tampering
- **Fast**: Hardware acceleration on mobile
- **Nonce-based**: No IV management
- **AEAD**: Confidentiality + integrity in one

### 3. Why Hive over SQLite?

- **Pure Dart**: No native bindings
- **Fast**: Key-value optimized
- **Simple**: No schema migrations
- **Lightweight**: Perfect for mobile

### 4. Why mDNS over Bluetooth?

- **Range**: WiFi covers entire building
- **Speed**: Higher bandwidth than BLE
- **Simplicity**: No pairing required
- **Compatibility**: Works on Android/iOS

### 5. Why WebRTC DataChannel?

- **Direct**: No relay server needed (LAN)
- **Reliable**: Built-in retransmission
- **Ordered**: Preserves message order
- **Battle-tested**: Used by Google Meet, Discord

### 6. Why Flood Routing for SOS?

- **Reliability**: Guaranteed delivery to all nodes
- **Speed**: Fastest propagation
- **Simplicity**: No routing table required
- **Emergency**: Acceptable overhead for critical alerts

---

## Limitations & Tradeoffs

### Network Limitations

1. **WiFi Range**: Limited to ~30-50 meters indoors
   - **Mitigation**: Multi-hop extends range

2. **Max Nodes**: Performance degrades > 50 nodes
   - **Mitigation**: Dedup cache prevents storms

3. **Network Split**: Mesh partitions if relay nodes fail
   - **Mitigation**: Auto-reconnect, offline queue

### Platform Limitations

1. **iOS Background**: Beacon pauses when app terminated
   - **Acceptable**: Hackathon constraint

2. **WebRTC Emulator**: Doesn't work, requires physical devices
   - **Acceptable**: Testing on real hardware

3. **mDNS Windows**: Unreliable on some WiFi adapters
   - **Mitigation**: QR code fallback

### Security Tradeoffs

1. **No Authentication**: Any device can join mesh
   - **Acceptable**: LAN trusted environment

2. **No DoS Protection**: Malicious peer can flood packets
   - **Acceptable**: Emergency scenario, trust assumed

3. **Replay Attacks**: Old packets could be replayed
   - **Mitigation**: Timestamp checking (future)

---

## Future Enhancements

### Phase 2 Features (Post-Hackathon)

1. **Bluetooth Mesh Fallback**: When WiFi unavailable
2. **Voice Messages**: Audio recording in chat
3. **Photo Sharing**: Compressed image transmission
4. **Group Chat**: Multi-recipient broadcasts
5. **Mesh Analytics**: Network health dashboard
6. **Battery Optimization**: Adaptive beacon intervals
7. **Offline Maps**: Cached map tiles for GPS visualization
8. **Multi-language**: i18n support

---

## Conclusion

AEGIS architecture prioritizes:

1. **Reliability**: Mesh routing ensures message delivery
2. **Performance**: < 3s SOS propagation, 60fps UI
3. **Security**: E2E encryption, signature verification
4. **Usability**: Auto-discovery, zero configuration
5. **Resilience**: Offline queue, auto-reconnect

The system is designed for **hackathon constraints** (48 hours) while maintaining **production-quality** core architecture (mesh routing, cryptography, state management).

**Critical Path**: Mesh Router → WebRTC → mDNS → SOS → Radar → Demo

---

**Document Version**: 1.0  
**Last Updated**: 2026-07-15  
**Status**: Architecture Complete - Ready for Implementation
