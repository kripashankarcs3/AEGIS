class PeerAddress {
  final String sigId;
  final String ip;
  final int port;
  final DateTime lastSeen;

  const PeerAddress({
    required this.sigId,
    required this.ip,
    required this.port,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() => {
        'sigId': sigId,
        'ip': ip,
        'port': port,
        'lastSeen': lastSeen.millisecondsSinceEpoch,
      };

  factory PeerAddress.fromMap(Map<String, dynamic> map) => PeerAddress(
        sigId: map['sigId'] as String,
        ip: map['ip'] as String,
        port: map['port'] as int,
        lastSeen:
            DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int),
      );
}
