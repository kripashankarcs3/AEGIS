# AEGIS Project Structure

```
aegis_flutter/
├── lib/
│   ├── main.dart                         # App entry, Riverpod, Hive init
│   ├── app.dart                          # MaterialApp, theme, router
│   │
│   ├── core/                             # Business Logic Layer
│   │   ├── mesh_router.dart              # ⭐ CORE: Mesh routing algorithm
│   │   ├── crypto_service.dart           # Ed25519 + AES-GCM encryption
│   │   ├── peer_manager.dart             # WebRTC connection pool
│   │   ├── mdns_discovery.dart           # mDNS service discovery
│   │   ├── sos_handler.dart              # SOS emergency logic
│   │   ├── status_beacon.dart            # Periodic status broadcast
│   │   ├── resource_manager.dart         # Resource offer/request
│   │   └── message_queue.dart            # Offline message queue
│   │
│   ├── models/                           # Data Models
│   │   ├── signal_packet.dart            # Universal packet schema
│   │   ├── survivor_node.dart            # Radar node model
│   │   └── resource_item.dart            # Resource model
│   │
│   ├── providers/                        # Riverpod State Management
│   │   ├── mesh_provider.dart            # Mesh network state
│   │   ├── identity_provider.dart        # SIG-ID identity state
│   │   ├── survivor_provider.dart        # Survivor map state
│   │   └── chat_provider.dart            # Chat history state
│   │
│   ├── screens/                          # UI Screens
│   │   ├── radar_screen.dart             # Main radar visualization
│   │   ├── chat_screen.dart              # Encrypted chat
│   │   ├── sos_screen.dart               # Emergency SOS
│   │   ├── resource_feed_screen.dart     # Resource offers/requests
│   │   ├── network_map_screen.dart       # Mesh topology map
│   │   └── identity_screen.dart          # Device identity
│   │
│   ├── widgets/                          # Reusable Widgets
│   │   ├── radar_painter.dart            # CustomPainter radar
│   │   ├── network_graph_painter.dart    # CustomPainter graph
│   │   ├── sos_banner.dart               # Full-screen SOS overlay
│   │   ├── node_popup_card.dart          # Node details popup
│   │   ├── resource_card.dart            # Resource card widget
│   │   ├── hop_path_badge.dart           # Message hop path display
│   │   ├── status_picker.dart            # Status selection buttons
│   │   └── mesh_stats_bar.dart           # Mesh statistics bar
│   │
│   └── services/                         # Platform Services
│       ├── background_service.dart       # Background execution
│       ├── notification_service.dart     # Local notifications
│       └── storage_service.dart          # Hive storage helpers
│
├── server/                               # Flask Signaling Relay
│   ├── signal-relay.py                   # WebRTC signaling server
│   └── requirements.txt                  # Python dependencies
│
├── android/                              # Android platform files
│   └── app/src/main/
│       ├── AndroidManifest.xml           # Permissions configuration
│       └── kotlin/.../MainActivity.kt    # Multicast lock setup
│
├── ios/                                  # iOS platform files
│   └── Runner/
│       └── Info.plist                    # iOS permissions
│
├── pubspec.yaml                          # Flutter dependencies
└── README.md                             # Project documentation
```

## Build Order (48-Hour Sprint)

### Phase 1: Foundation (Hours 0-2)
- ✅ Project scaffold created
- ⏳ Add dependencies to pubspec.yaml
- ⏳ Set up navigation (5 tabs)
- ⏳ Apply dark theme

### Phase 2: Identity + Storage (Hours 2-5)
- ⏳ Implement CryptoService
- ⏳ Implement StorageService
- ⏳ Create identity persistence

### Phase 3: P2P Connection (Hours 5-12)
- ⏳ Implement WebRTC Manager
- ⏳ Implement mDNS Discovery
- ⏳ Create Flask signaling relay
- ⏳ Test DataChannel exchange

### Phase 4: Mesh Routing ⭐ CRITICAL (Hours 12-20)
- ⏳ Implement MeshRouter
- ⏳ Test 3-device relay
- ⏳ Verify deduplication

### Phase 5: Emergency Features (Hours 20-35)
- ⏳ Implement SOS System
- ⏳ Implement Status Beacon
- ⏳ Implement Resource Manager
- ⏳ Create Radar visualization

### Phase 6: Chat + Polish (Hours 35-44)
- ⏳ Implement E2E encryption
- ⏳ Implement offline queue
- ⏳ Create Network Map
- ⏳ UI refinements

### Phase 7: Demo Prep (Hours 44-48)
- ⏳ Test 5 demo scenarios
- ⏳ Build APK
- ⏳ Install on devices

---

**Status**: ✅ Project structure created - Ready for implementation
