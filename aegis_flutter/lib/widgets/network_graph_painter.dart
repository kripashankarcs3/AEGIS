// NetworkGraphPainter — CustomPainter that renders a simple mesh node graph.
// Draws nodes as circles connected by lines with hop-count labels.

import 'dart:math';
import 'package:flutter/material.dart';

/// A node in the graph.
class GraphNode {
  final String id;
  final Offset position; // normalised 0..1
  final bool isSelf;

  const GraphNode({
    required this.id,
    required this.position,
    this.isSelf = false,
  });
}

/// An edge between two node IDs.
class GraphEdge {
  final String fromId;
  final String toId;
  final int hops;

  const GraphEdge({required this.fromId, required this.toId, this.hops = 1});
}

class NetworkGraphPainter extends CustomPainter {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;

  static const _nodeRadius = 14.0;
  static const _selfRadius = 18.0;

  static const _edgeColor = Color(0xFFD1D5DB);
  static const _nodeColor = Color(0xFF2F9BFF);
  static const _selfColor = Color(0xFF111827);
  static const _labelColor = Color(0xFF6B7280);

  const NetworkGraphPainter({
    required this.nodes,
    required this.edges,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodeMap = {for (final n in nodes) n.id: n};

    // Draw edges first (behind nodes)
    final edgePaint = Paint()
      ..color = _edgeColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      final from = nodeMap[edge.fromId];
      final to = nodeMap[edge.toId];
      if (from == null || to == null) continue;
      final p1 = _toCanvas(from.position, size);
      final p2 = _toCanvas(to.position, size);
      canvas.drawLine(p1, p2, edgePaint);

      // Hop count label at midpoint
      if (edge.hops > 1) {
        final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        _drawLabel(canvas, '${edge.hops}h', mid, 10, _labelColor);
      }
    }

    // Draw nodes
    for (final node in nodes) {
      final center = _toCanvas(node.position, size);
      final radius = node.isSelf ? _selfRadius : _nodeRadius;
      final color = node.isSelf ? _selfColor : _nodeColor;

      // Shadow
      canvas.drawCircle(
        center.translate(0, 2),
        radius,
        Paint()..color = color.withOpacity(0.15),
      );

      // Fill
      canvas.drawCircle(center, radius, Paint()..color = color);

      // Border
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Label below node
      _drawLabel(
        canvas,
        node.isSelf ? 'Me' : _shortId(node.id),
        center.translate(0, radius + 10),
        10,
        node.isSelf ? _selfColor : _nodeColor,
      );
    }
  }

  Offset _toCanvas(Offset normalised, Size size) =>
      Offset(normalised.dx * size.width, normalised.dy * size.height);

  String _shortId(String id) {
    if (id.length <= 8) return id;
    return id.substring(id.length - 6);
  }

  void _drawLabel(
      Canvas canvas, String text, Offset center, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: color, fontSize: fontSize, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center.translate(-tp.width / 2, -tp.height / 2));
  }

  @override
  bool shouldRepaint(NetworkGraphPainter old) =>
      old.nodes != nodes || old.edges != edges;
}

/// A ready-to-use widget that wraps [NetworkGraphPainter] with sample data.
class NetworkGraphWidget extends StatelessWidget {
  /// Override to pass real nodes/edges from mesh state.
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final double height;

  NetworkGraphWidget({
    super.key,
    List<GraphNode>? nodes,
    List<GraphEdge>? edges,
    this.height = 220,
  })  : nodes = nodes ?? _defaultNodes(),
        edges = edges ?? _defaultEdges();

  static List<GraphNode> _defaultNodes() {
    final rng = Random(42);
    return [
      const GraphNode(id: 'self', position: Offset(0.5, 0.5), isSelf: true),
      GraphNode(
          id: 'SIG-A1B2', position: Offset(0.2 + rng.nextDouble() * 0.1, 0.2)),
      GraphNode(
          id: 'SIG-C3D4',
          position: Offset(0.75 + rng.nextDouble() * 0.1, 0.25)),
      GraphNode(
          id: 'SIG-E5F6', position: Offset(0.15 + rng.nextDouble() * 0.1, 0.7)),
      GraphNode(
          id: 'SIG-G7H8',
          position: Offset(0.8 + rng.nextDouble() * 0.05, 0.72)),
    ];
  }

  static List<GraphEdge> _defaultEdges() => [
        const GraphEdge(fromId: 'self', toId: 'SIG-A1B2', hops: 1),
        const GraphEdge(fromId: 'self', toId: 'SIG-C3D4', hops: 1),
        const GraphEdge(fromId: 'SIG-A1B2', toId: 'SIG-E5F6', hops: 2),
        const GraphEdge(fromId: 'SIG-C3D4', toId: 'SIG-G7H8', hops: 2),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: NetworkGraphPainter(nodes: nodes, edges: edges),
        ),
      ),
    );
  }
}
