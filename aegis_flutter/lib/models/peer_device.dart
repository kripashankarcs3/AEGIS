// PeerDevice Model - Represents a connected device in the mesh
// Tracks transport availability and connection state

class PeerDevice {
  final String id; // AGS-XXXX
  final String? displayName;
  final String? publicKey;
  final int lastSeen; // Unix milliseconds
  final bool isOnline;

  // Transport availability
  final bool wifiConnected;
  final bool nearbyConnected;
  final bool bluetoothConnected;

  // Mesh info
  final int hopDistance; // 0 = direct, 1+ = via relay

  PeerDevice({
    required this.id,
    this.displayName,
    this.publicKey,
    required this.lastSeen,
    this.isOnline = false,
    this.wifiConnected = false,
    this.nearbyConnected = false,
    this.bluetoothConnected = false,
    this.hopDistance = 0,
  });

  PeerDevice copyWith({
    String? id,
    String? displayName,
    String? publicKey,
    int? lastSeen,
    bool? isOnline,
    bool? wifiConnected,
    bool? nearbyConnected,
    bool? bluetoothConnected,
    int? hopDistance,
  }) {
    return PeerDevice(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      publicKey: publicKey ?? this.publicKey,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      wifiConnected: wifiConnected ?? this.wifiConnected,
      nearbyConnected: nearbyConnected ?? this.nearbyConnected,
      bluetoothConnected: bluetoothConnected ?? this.bluetoothConnected,
      hopDistance: hopDistance ?? this.hopDistance,
    );
  }

  @override
  String toString() {
    return 'PeerDevice{id: $id, online: $isOnline, hops: $hopDistance}';
  }
}
