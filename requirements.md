# Requirements Document

## Introduction

AEGIS is an offline-first peer-to-peer mesh communication and emergency platform built with Flutter. When the internet dies, humanity still speaks. AEGIS enables devices on the same local WiFi network to form a self-healing mesh network with no internet, no server, and no accounts required. The platform provides encrypted chat, SOS emergency alerts, survivor status tracking, and resource coordination — all functioning entirely offline through multi-hop mesh routing.

## Glossary

- **AEGIS_App**: The Flutter mobile application that implements the mesh communication platform
- **Mesh_Router**: The subsystem responsible for multi-hop packet routing with TTL and deduplication
- **WebRTC_Manager**: The subsystem managing peer-to-peer data channel connections
- **Discovery_Service**: The mDNS-based service that discovers peers on the local network
- **Identity_Manager**: The subsystem managing Ed25519 cryptographic identities
- **SOS_System**: The emergency alert broadcasting and handling subsystem
- **Status_Beacon**: The subsystem broadcasting periodic survivor status updates
- **Resource_Manager**: The subsystem managing resource offers and requests
- **Chat_Service**: The end-to-end encrypted messaging subsystem
- **Storage_Layer**: The Hive-based local persistence subsystem
- **Signaling_Relay**: The Flask-based LAN-only WebRTC signaling server
- **Packet**: A SignalPacket data structure containing routing metadata and payload
- **Peer**: Another device running AEGIS on the same local network
- **Node**: A device participating in the mesh network
- **Hop**: A single routing step between two directly connected peers
- **TTL**: Time-to-live value determining maximum hop count before packet expiry
- **SIG_ID**: A cryptographic identity derived from Ed25519 public key hash (format: SIG-XXXX)
- **Radar_Screen**: The visual interface displaying survivor locations and status
- **Network_Map**: The visual interface displaying mesh topology and connections
- **LAN**: Local Area Network (WiFi network with no internet access)

## Requirements

### Requirement 1: Cryptographic Identity Generation

**User Story:** As a user launching AEGIS for the first time, I want a cryptographic identity automatically generated, so that I can participate in the mesh network securely without creating an account.

#### Acceptance Criteria

1. WHEN the AEGIS_App launches for the first time, THE Identity_Manager SHALL generate an Ed25519 keypair
2. WHEN an Ed25519 keypair is generated, THE Identity_Manager SHALL derive a SIG_ID by computing SHA-256 hash of the public key and taking the first 4 hexadecimal characters
3. THE Identity_Manager SHALL store the keypair permanently in the Storage_Layer identity box
4. WHEN the AEGIS_App launches on subsequent sessions, THE Identity_Manager SHALL load the existing keypair from storage
5. THE Identity_Manager SHALL never regenerate a keypair once created
6. THE AEGIS_App SHALL display the SIG_ID in the Identity Screen in monospace font

### Requirement 2: Local Storage Initialization

**User Story:** As a developer, I want local storage initialized before the app launches, so that all subsystems can persist data reliably.

#### Acceptance Criteria

1. WHEN the AEGIS_App initializes, THE Storage_Layer SHALL call Hive initFlutter before opening any boxes
2. WHEN Hive is initialized, THE Storage_Layer SHALL register all TypeAdapters before opening boxes
3. THE Storage_Layer SHALL open the identity box for keypair storage
4. THE Storage_Layer SHALL open the messages box for chat message storage
5. THE Storage_Layer SHALL open the sos-log box for emergency alert history
6. THE Storage_Layer SHALL open the resource-feed box for resource offer and request storage
7. IF any box fails to open, THEN THE Storage_Layer SHALL log the error and retry once

### Requirement 3: mDNS Device Discovery

**User Story:** As a user, I want my device to automatically discover other AEGIS devices on the same WiFi network, so that I can connect without manual configuration.

#### Acceptance Criteria

1. WHEN the AEGIS_App starts, THE Discovery_Service SHALL advertise itself as an "_aegis._tcp" mDNS service on the LAN
2. WHEN the AEGIS_App starts, THE Discovery_Service SHALL scan for other "_aegis._tcp" services on the LAN
3. WHEN a peer "_aegis._tcp" service is discovered, THE Discovery_Service SHALL extract the peer IP address and port
4. WHEN a peer is discovered, THE Discovery_Service SHALL provide the peer information to the WebRTC_Manager for connection establishment
5. WHERE the platform is Android, THE Discovery_Service SHALL acquire a multicast lock before starting mDNS operations
6. WHEN a peer disappears from mDNS, THE Discovery_Service SHALL notify the WebRTC_Manager within 10 seconds

### Requirement 4: WebRTC Peer Connection Management

**User Story:** As a user, I want direct peer-to-peer connections established automatically, so that I can communicate without internet infrastructure.

#### Acceptance Criteria

1. WHEN the Discovery_Service provides a peer IP address, THE WebRTC_Manager SHALL initiate a WebRTC connection using the Signaling_Relay
2. THE WebRTC_Manager SHALL configure WebRTC with an empty iceServers array for LAN-only operation
3. WHEN a WebRTC offer is created, THE WebRTC_Manager SHALL send the offer to the Signaling_Relay for peer delivery
4. WHEN a WebRTC answer is received from the Signaling_Relay, THE WebRTC_Manager SHALL complete the connection handshake
5. WHEN a data channel opens, THE WebRTC_Manager SHALL register the peer connection in the connection pool
6. WHEN a peer connection closes, THE WebRTC_Manager SHALL attempt to reconnect within 5 seconds
7. THE WebRTC_Manager SHALL track connection state for each peer (connecting, connected, disconnected)
8. WHEN a Packet is sent through a peer connection, THE WebRTC_Manager SHALL transmit the Packet via the data channel

### Requirement 5: Flask Signaling Relay

**User Story:** As a developer, I want a minimal LAN-only signaling server, so that peers can exchange WebRTC offers and answers for initial connection setup.

#### Acceptance Criteria

1. THE Signaling_Relay SHALL bind to IP address 0.0.0.0 and port 5000
2. WHEN a WebRTC offer is posted to the Signaling_Relay, THE Signaling_Relay SHALL store the offer with the sender SIG_ID as the key
3. WHEN a peer requests offers for a specific SIG_ID, THE Signaling_Relay SHALL return the stored offer
4. WHEN a WebRTC answer is posted to the Signaling_Relay, THE Signaling_Relay SHALL deliver the answer to the requesting peer
5. THE Signaling_Relay SHALL operate without any internet connectivity
6. THE Signaling_Relay SHALL log all offer and answer exchanges for debugging

### Requirement 6: Mesh Routing Engine

**User Story:** As a user, I want messages to automatically route through intermediate peers, so that I can reach devices not directly connected to me.

#### Acceptance Criteria

1. WHEN a Packet is received, THE Mesh_Router SHALL check the packet ID against the deduplication cache
2. IF a Packet ID exists in the deduplication cache, THEN THE Mesh_Router SHALL drop the Packet
3. WHEN a new Packet is processed, THE Mesh_Router SHALL add the Packet ID to the deduplication cache
4. WHEN a Packet is received, THE Mesh_Router SHALL decrement the TTL value by 1
5. IF the TTL value reaches 0, THEN THE Mesh_Router SHALL drop the Packet
6. IF the Packet destination matches the local SIG_ID, THEN THE Mesh_Router SHALL deliver the Packet to the appropriate subsystem
7. IF the Packet destination does not match the local SIG_ID, THEN THE Mesh_Router SHALL append the local SIG_ID to the path and forward the Packet to all connected peers except the sender
8. WHEN forwarding a Packet, THE Mesh_Router SHALL increment the hopCount field
9. WHEN a Packet type is "sos" or "status" or "resource", THE Mesh_Router SHALL flood the Packet to all peers (broadcast routing)
10. WHEN a Packet type is "chat" or "ack", THE Mesh_Router SHALL use unicast routing toward the destination

### Requirement 7: Packet Deduplication Cache

**User Story:** As a developer, I want duplicate packets prevented, so that broadcast storms do not overwhelm the mesh network.

#### Acceptance Criteria

1. THE Mesh_Router SHALL maintain an in-memory cache of processed Packet IDs
2. WHEN a Packet is processed, THE Mesh_Router SHALL store the Packet ID in the cache with a timestamp
3. WHEN the cache size exceeds 10000 entries, THE Mesh_Router SHALL evict the oldest 20 percent of entries
4. THE Mesh_Router SHALL evict cache entries older than 5 minutes
5. WHEN checking for duplicates, THE Mesh_Router SHALL perform the cache lookup in less than 1 millisecond

### Requirement 8: Packet Schema Definition

**User Story:** As a developer, I want a universal packet structure, so that all mesh communications follow a consistent format.

#### Acceptance Criteria

1. THE AEGIS_App SHALL define a SignalPacket model with the following fields: id (UUID), from (SIG_ID), to (SIG_ID or null), path (list of SIG_IDs), hopCount (integer), ttl (integer), timestamp (ISO 8601 string), type (string)
2. THE SignalPacket model SHALL include optional type-specific fields: payload (encrypted string), gps (latitude and longitude), alarm (boolean), category (string), status (string), resources (object)
3. THE SignalPacket model SHALL provide a toJson method for serialization
4. THE SignalPacket model SHALL provide a fromJson method for deserialization
5. WHEN a new Packet is created, THE AEGIS_App SHALL generate a unique UUID for the id field
6. WHEN a new Packet is created, THE AEGIS_App SHALL set the from field to the local SIG_ID
7. WHEN a new Packet is created, THE AEGIS_App SHALL initialize the path field with an empty list
8. WHEN a new Packet is created, THE AEGIS_App SHALL set hopCount to 0

### Requirement 9: End-to-End Encrypted Chat

**User Story:** As a user, I want to send encrypted messages to other survivors, so that my communications remain private.

#### Acceptance Criteria

1. WHEN a chat message is composed, THE Chat_Service SHALL generate a shared secret using ECDH with the sender private key and recipient public key
2. WHEN a shared secret is generated, THE Chat_Service SHALL encrypt the message payload using AES-GCM-256 with the shared secret
3. WHEN an encrypted message is ready, THE Chat_Service SHALL create a Packet with type "chat" and the encrypted payload
4. WHEN creating a chat Packet, THE Chat_Service SHALL set TTL to 10 and destination to the recipient SIG_ID
5. WHEN a chat Packet is received, THE Chat_Service SHALL derive the shared secret using ECDH with the local private key and sender public key
6. WHEN the shared secret is derived, THE Chat_Service SHALL decrypt the payload using AES-GCM-256
7. IF decryption fails, THEN THE Chat_Service SHALL log the error and discard the message
8. WHEN a message is decrypted successfully, THE Chat_Service SHALL store the message in the Storage_Layer messages box
9. WHEN a message is delivered, THE Chat_Service SHALL send an acknowledgment Packet with type "ack" to the sender

### Requirement 10: Chat Message Display

**User Story:** As a user, I want to view my conversation history with hop path information, so that I understand how messages traveled through the mesh.

#### Acceptance Criteria

1. THE Chat_Service SHALL display sent messages as right-aligned blue bubbles
2. THE Chat_Service SHALL display received messages as left-aligned dark bubbles
3. WHEN a message is displayed, THE Chat_Service SHALL show a hop path badge below the message bubble
4. THE hop path badge SHALL display the format "Delivered via N hops: SIG-A → SIG-B → SIG-C" where N is the hopCount and the path is constructed from the path field
5. IF a message has hopCount 0, THEN THE Chat_Service SHALL display "Direct delivery"
6. THE Chat_Service SHALL display an E2E encryption badge on all messages
7. WHEN a message is pending delivery, THE Chat_Service SHALL display a pending queue indicator
8. THE Chat_Service SHALL display SIG_IDs in monospace font

### Requirement 11: Offline Message Queue

**User Story:** As a user, I want messages queued when the recipient is unreachable, so that they are delivered when the recipient comes back online.

#### Acceptance Criteria

1. WHEN a chat Packet cannot be routed to the destination, THE Chat_Service SHALL store the Packet in the Storage_Layer messages box with a pending flag
2. WHEN a new peer connection is established, THE Chat_Service SHALL check the pending message queue for messages destined to the new peer or reachable through the new peer
3. WHEN a reachable pending message is found, THE Chat_Service SHALL attempt to send the message through the Mesh_Router
4. WHEN a pending message is successfully acknowledged, THE Chat_Service SHALL clear the pending flag
5. THE Chat_Service SHALL retry sending pending messages every 30 seconds

### Requirement 12: SOS Emergency Alert Broadcasting

**User Story:** As a user in danger, I want to broadcast an SOS alert to all nearby survivors, so that I can receive immediate help.

#### Acceptance Criteria

1. THE SOS_System SHALL provide 4 emergency categories: Medical, Trapped, Water/Food, Fire/Danger
2. WHEN a user activates an SOS alert, THE SOS_System SHALL create a Packet with type "sos", alarm set to true, and TTL set to 15
3. WHEN the user location is available, THE SOS_System SHALL attach GPS coordinates to the SOS Packet
4. WHEN an SOS Packet is created, THE SOS_System SHALL broadcast the Packet to all peers via the Mesh_Router flood routing
5. WHEN an SOS Packet is sent, THE SOS_System SHALL store the alert in the Storage_Layer sos-log box
6. WHEN an SOS alert is activated, THE SOS_System SHALL enforce a 60-second cooldown before allowing another SOS alert
7. WHEN an SOS alert is sent, THE SOS_System SHALL trigger haptic feedback (vibration) on the sender device

### Requirement 13: SOS Alert Reception and Display

**User Story:** As a user, I want to be immediately notified when someone sends an SOS alert, so that I can respond to emergencies quickly.

#### Acceptance Criteria

1. WHEN an SOS Packet is received, THE SOS_System SHALL display a full-screen red overlay banner with the alert details
2. WHEN an SOS alert is displayed, THE SOS_System SHALL show the sender SIG_ID, category, timestamp, and GPS coordinates if available
3. WHEN an SOS Packet with alarm set to true is received, THE SOS_System SHALL play a 3-beep audio alarm pattern
4. WHEN an SOS alert audio alarm plays, THE SOS_System SHALL trigger haptic feedback (vibration) for 2 seconds
5. WHEN an SOS alert is received, THE SOS_System SHALL store the alert in the Storage_Layer sos-log box
6. WHEN an SOS alert is displayed, THE SOS_System SHALL provide a button to navigate to the chat interface with the sender
7. THE SOS_System SHALL display the SOS alert banner over all other screens until dismissed by the user

### Requirement 14: Status Beacon Broadcasting

**User Story:** As a user, I want to broadcast my survivor status periodically, so that others know my situation without constant messaging.

#### Acceptance Criteria

1. THE Status_Beacon SHALL provide 3 status states: Safe, Need Help, Have Resources
2. WHEN the AEGIS_App starts, THE Status_Beacon SHALL default to "Safe" status
3. WHEN a user changes their status, THE Status_Beacon SHALL immediately broadcast a Packet with type "status" and TTL 10
4. WHILE the AEGIS_App is running, THE Status_Beacon SHALL broadcast the current status every 30 seconds
5. WHEN the user location is available, THE Status_Beacon SHALL attach GPS coordinates to status Packets
6. WHEN a status Packet is broadcast, THE Status_Beacon SHALL use the Mesh_Router flood routing
7. WHEN a status Packet is received, THE Status_Beacon SHALL update the peer status in memory for display on the Radar_Screen

### Requirement 15: Background Status Beacon

**User Story:** As a user, I want my status to continue broadcasting when the app is in the background, so that others can track my status even when I'm not actively using AEGIS.

#### Acceptance Criteria

1. WHEN the AEGIS_App moves to the background, THE Status_Beacon SHALL continue broadcasting status every 30 seconds
2. WHERE the platform is Android, THE Status_Beacon SHALL use a foreground service with a persistent notification
3. THE foreground service notification SHALL display "AEGIS mesh active" as the title
4. WHEN the AEGIS_App returns to the foreground, THE Status_Beacon SHALL continue operating without interruption

### Requirement 16: Resource Broadcasting

**User Story:** As a user, I want to broadcast resource offers and requests, so that survivors can coordinate essential supplies.

#### Acceptance Criteria

1. THE Resource_Manager SHALL provide 2 resource types: Offer and Request
2. THE Resource_Manager SHALL provide 6 resource categories: Water, Food, Medicine, Shelter, Tools, People
3. WHEN a user creates a resource, THE Resource_Manager SHALL create a Packet with type "resource" and TTL 10
4. WHEN a resource Packet is created, THE Resource_Manager SHALL include fields for resource type, category, quantity, and timestamp
5. WHEN a resource is broadcast, THE Resource_Manager SHALL use the Mesh_Router flood routing
6. WHEN a resource Packet is received, THE Resource_Manager SHALL store the resource in the Storage_Layer resource-feed box
7. THE Resource_Manager SHALL automatically expire resources 2 hours after the timestamp
8. WHEN displaying resources, THE Resource_Manager SHALL filter out expired resources

### Requirement 17: Resource Feed Display

**User Story:** As a user, I want to view available resources and requests in a feed, so that I can find needed supplies or offer help.

#### Acceptance Criteria

1. THE Resource_Manager SHALL display resources in a tabbed interface with tabs: All, Offers, Requests
2. WHEN the "All" tab is selected, THE Resource_Manager SHALL display both offers and requests sorted by timestamp descending
3. WHEN the "Offers" tab is selected, THE Resource_Manager SHALL display only resources with type "Offer"
4. WHEN the "Requests" tab is selected, THE Resource_Manager SHALL display only resources with type "Request"
5. THE Resource_Manager SHALL display each resource as a card with colored border (green for offers, orange for requests)
6. THE Resource_Manager SHALL display category, quantity, sender SIG_ID, timestamp, and expiry countdown for each resource
7. WHEN a resource is within 30 minutes of expiry, THE Resource_Manager SHALL display a visual expiry warning
8. WHEN a user taps a resource card, THE Resource_Manager SHALL provide a "Reply" button that opens chat with the sender

### Requirement 18: Survivor Radar Visualization

**User Story:** As a user, I want a visual radar display showing nearby survivors and their status, so that I can quickly assess the situation around me.

#### Acceptance Criteria

1. THE Radar_Screen SHALL render a CustomPainter-based radar visualization
2. THE Radar_Screen SHALL draw concentric circles representing distance ranges
3. THE Radar_Screen SHALL display the user as a center dot labeled "YOU"
4. WHEN a peer status update is received, THE Radar_Screen SHALL display the peer as a colored dot on the radar
5. THE Radar_Screen SHALL color peer dots based on status: Safe (green #0F9D58), Need Help (red #D93025), Have Resources (orange #F29900), Unknown (gray #555555)
6. WHEN a peer status is "Need Help", THE Radar_Screen SHALL animate the peer dot with a pulsing glow effect
7. THE Radar_Screen SHALL draw connection lines between directly connected peers
8. THE Radar_Screen SHALL animate a rotating sweep line at 60 frames per second
9. WHEN a message is sent or received, THE Radar_Screen SHALL animate a particle traveling along the connection line
10. WHEN a user taps a peer dot, THE Radar_Screen SHALL display a popup with peer SIG_ID, status, GPS coordinates if available, last seen timestamp, and a "Chat" button
11. THE Radar_Screen SHALL display status picker buttons at the bottom for Safe, Need Help, and Have Resources

### Requirement 19: Network Map Visualization

**User Story:** As a user, I want to see the mesh network topology, so that I understand how devices are connected and which nodes are acting as relays.

#### Acceptance Criteria

1. THE Network_Map SHALL render a force-directed graph visualization using CustomPainter
2. THE Network_Map SHALL represent each peer as a circular node labeled with its SIG_ID
3. THE Network_Map SHALL draw edges between directly connected peers
4. THE Network_Map SHALL label each edge with the hop count
5. THE Network_Map SHALL scale node size proportional to the number of direct connections
6. THE Network_Map SHALL animate the graph layout using spring physics at 60 frames per second
7. THE Network_Map SHALL display mesh statistics: total nodes discovered, active relay nodes, average hop count, and mesh reach percentage
8. WHEN a user drags a node, THE Network_Map SHALL update the node position and recalculate the spring forces

### Requirement 20: Identity Screen Display

**User Story:** As a user, I want to view my cryptographic identity and mesh statistics, so that I can verify my identity and monitor my participation in the network.

#### Acceptance Criteria

1. THE AEGIS_App SHALL display the local SIG_ID in large monospace font on the Identity Screen
2. THE Identity Screen SHALL display the first 32 characters of the public key in monospace font
3. WHEN a user taps the public key, THE AEGIS_App SHALL copy the full public key to the clipboard
4. THE Identity Screen SHALL display a badge stating "Generated locally — never sent to any server"
5. THE Identity Screen SHALL display mesh statistics: session uptime, total messages relayed, nodes discovered, and packets dropped
6. THE Identity Screen SHALL display a QR code containing the local LAN IP address and SIG_ID for mDNS fallback
7. THE Identity Screen SHALL update mesh statistics every 5 seconds

### Requirement 21: Navigation Structure

**User Story:** As a user, I want intuitive navigation between key features, so that I can access critical functions quickly during emergencies.

#### Acceptance Criteria

1. THE AEGIS_App SHALL provide a bottom navigation bar with 5 tabs: Radar, Chat, SOS, Resources, Map
2. WHEN a tab is selected, THE AEGIS_App SHALL navigate to the corresponding screen using go_router
3. THE SOS tab icon and label SHALL always display in red (#D93025) regardless of selection state
4. WHEN the user is on any screen, THE AEGIS_App SHALL allow navigation to any other screen with a single tap
5. THE AEGIS_App SHALL preserve navigation state when the app moves to background and returns

### Requirement 22: Dark Theme Styling

**User Story:** As a user, I want a dark theme optimized for low-light emergency conditions, so that the interface is readable without draining battery or drawing attention.

#### Acceptance Criteria

1. THE AEGIS_App SHALL use background color #0D1117 for primary background surfaces
2. THE AEGIS_App SHALL use background color #161B22 for elevated surfaces (cards, modals)
3. THE AEGIS_App SHALL use white text with 87% opacity for primary text
4. THE AEGIS_App SHALL use white text with 60% opacity for secondary text
5. THE AEGIS_App SHALL use status-specific colors for status indicators: Safe (#0F9D58), Need Help (#D93025), Have Resources (#F29900)
6. THE AEGIS_App SHALL use monospace font for all SIG_ID displays
7. THE AEGIS_App SHALL maintain WCAG AA contrast ratio for all text elements

### Requirement 23: Android Platform Configuration

**User Story:** As a developer deploying on Android, I want proper permissions and services configured, so that AEGIS can access network, location, and background services.

#### Acceptance Criteria

1. THE AEGIS_App SHALL declare the following permissions in AndroidManifest.xml: INTERNET, ACCESS_WIFI_STATE, CHANGE_WIFI_MULTICAST_STATE, ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION, WAKE_LOCK, FOREGROUND_SERVICE, VIBRATE, POST_NOTIFICATIONS
2. THE AEGIS_App SHALL implement multicast lock acquisition in MainActivity.kt before starting mDNS discovery
3. THE AEGIS_App SHALL request runtime location permissions before accessing GPS
4. THE AEGIS_App SHALL register the foreground service in AndroidManifest.xml for background status beacon
5. WHERE the Android version is 12 or higher, THE AEGIS_App SHALL request BLUETOOTH_CONNECT permission for future Bluetooth mesh fallback

### Requirement 24: iOS Platform Configuration

**User Story:** As a developer deploying on iOS, I want proper permissions and entitlements configured, so that AEGIS can access network, location, and background services.

#### Acceptance Criteria

1. THE AEGIS_App SHALL declare NSLocalNetworkUsageDescription in Info.plist with the text "AEGIS uses local network to discover nearby devices for mesh communication"
2. THE AEGIS_App SHALL declare NSBonjourServices in Info.plist with the value "_aegis._tcp"
3. THE AEGIS_App SHALL declare NSLocationWhenInUseUsageDescription in Info.plist with the text "AEGIS uses location to attach GPS coordinates to SOS alerts and status updates"
4. THE AEGIS_App SHALL request location permissions before accessing GPS
5. THE AEGIS_App SHALL configure background modes for location updates to enable background status beacon

### Requirement 25: Delivery Acknowledgment System

**User Story:** As a user, I want delivery confirmation for my messages, so that I know when they have reached the recipient.

#### Acceptance Criteria

1. WHEN a chat Packet is delivered to the destination, THE Chat_Service SHALL send an acknowledgment Packet with type "ack" to the original sender
2. WHEN an acknowledgment Packet is created, THE Chat_Service SHALL include the original message ID in the payload
3. WHEN an acknowledgment Packet is sent, THE Chat_Service SHALL set TTL to 10 and use unicast routing
4. WHEN an acknowledgment Packet is received, THE Chat_Service SHALL mark the corresponding message as delivered in the Storage_Layer
5. WHEN a message is marked as delivered, THE Chat_Service SHALL display a delivery checkmark in the chat interface
6. IF no acknowledgment is received within 60 seconds, THEN THE Chat_Service SHALL display a "pending" indicator

### Requirement 26: GPS Location Services

**User Story:** As a user, I want my location attached to SOS alerts and status updates when available, so that others can find me in emergencies.

#### Acceptance Criteria

1. WHEN the AEGIS_App requests location, THE AEGIS_App SHALL use the geolocator package to access GPS
2. WHEN location permissions are granted and GPS is available, THE AEGIS_App SHALL obtain coordinates with accuracy within 50 meters
3. WHEN creating an SOS Packet, THE SOS_System SHALL attempt to attach GPS coordinates with a timeout of 5 seconds
4. WHEN creating a status Packet, THE Status_Beacon SHALL attempt to attach GPS coordinates with a timeout of 3 seconds
5. IF GPS coordinates are unavailable, THEN THE AEGIS_App SHALL create the Packet without GPS data
6. WHEN displaying GPS coordinates, THE AEGIS_App SHALL format latitude and longitude to 6 decimal places
7. THE AEGIS_App SHALL cache the last known location for up to 5 minutes for faster attachment

### Requirement 27: Local Notification System

**User Story:** As a user, I want notifications for SOS alerts even when the app is in the background, so that I never miss emergency broadcasts.

#### Acceptance Criteria

1. WHEN an SOS Packet is received while the AEGIS_App is in the background, THE SOS_System SHALL create a local notification
2. THE local notification SHALL display the title "EMERGENCY: SOS Alert"
3. THE local notification SHALL display the sender SIG_ID and emergency category in the body
4. THE local notification SHALL use critical alert priority with sound and vibration
5. WHEN a user taps the notification, THE AEGIS_App SHALL navigate to the SOS log screen
6. WHERE the platform is Android, THE SOS_System SHALL create a notification channel with importance HIGH

### Requirement 28: Demo-Critical Auto-Discovery Performance

**User Story:** As a demo presenter, I want devices to discover each other within 10 seconds, so that the mesh network formation is immediately visible.

#### Acceptance Criteria

1. WHEN two AEGIS devices join the same WiFi network, THE Discovery_Service on each device SHALL discover the other device within 10 seconds
2. WHEN a peer is discovered, THE peer SHALL appear on the Radar_Screen with a colored dot within 2 seconds
3. WHEN a peer appears on the Radar_Screen, THE connection line SHALL animate to indicate active connection

### Requirement 29: Demo-Critical Three-Device Mesh Relay

**User Story:** As a demo presenter, I want to demonstrate multi-hop routing with three devices, so that the mesh relay capability is clearly visible.

#### Acceptance Criteria

1. WHEN device A and device C are not directly connected but both connect to device B, THE Mesh_Router on device B SHALL relay messages between A and C
2. WHEN device A sends a chat message to device C through device B, THE message SHALL display "Delivered via 2 hops: SIG-A → SIG-B → SIG-C" on device C
3. WHEN the mesh route changes, THE Network_Map SHALL update the topology visualization within 1 second

### Requirement 30: Demo-Critical SOS Alert Propagation

**User Story:** As a demo presenter, I want SOS alerts to reach all devices within 3 seconds, so that the emergency response capability is immediately apparent.

#### Acceptance Criteria

1. WHEN an SOS alert is activated on any device, THE SOS_System SHALL flood the alert to all connected devices within 3 seconds
2. WHEN an SOS alert reaches a device, THE full-screen red overlay banner SHALL appear within 500 milliseconds
3. WHEN an SOS alert is displayed, THE 3-beep audio alarm SHALL play within 200 milliseconds of banner appearance

### Requirement 31: Parser and Pretty Printer for SignalPacket

**User Story:** As a developer, I want robust parsing and printing of SignalPacket JSON, so that packets are reliably transmitted and received across the mesh.

#### Acceptance Criteria

1. WHEN a SignalPacket is serialized, THE SignalPacket model SHALL produce valid JSON using the toJson method
2. WHEN JSON is received, THE SignalPacket model SHALL parse it into a SignalPacket object using the fromJson method
3. IF JSON parsing fails due to missing required fields, THEN THE SignalPacket model SHALL throw a descriptive error
4. IF JSON parsing fails due to invalid field types, THEN THE SignalPacket model SHALL throw a descriptive error
5. FOR ALL valid SignalPacket objects, serializing with toJson then parsing with fromJson then serializing again SHALL produce equivalent JSON (round-trip property)
6. THE SignalPacket model SHALL handle optional fields gracefully by using null defaults

---

**End of Requirements Document**

This requirements document defines the complete specification for AEGIS using EARS patterns and INCOSE quality rules. All requirements are testable, complete, and free of implementation details per the verify-first workflow standards.
