import 'dart:convert';

import 'package:http/http.dart' as http;

class SignalingService {
  SignalingService();

  /// Android Emulator
  static const String baseUrl = "http://10.0.2.2:5000";

  /// Physical Device Example
  // static const String baseUrl = "http://192.168.29.127:5000";

  /// -----------------------------
  /// OFFER
  /// -----------------------------

  Future<bool> sendOffer(
    String peerId,
    Map<String, dynamic> offer,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/offer"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "peerId": peerId,
        "offer": offer,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getOffer(
    String peerId,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/offer/$peerId"),
    );

    if (response.statusCode != 200) {
      return null;
    }

    if (response.body == "null") {
      return null;
    }

    return Map<String, dynamic>.from(
      jsonDecode(response.body),
    );
  }

  /// -----------------------------
  /// ANSWER
  /// -----------------------------

  Future<bool> sendAnswer(
    String peerId,
    Map<String, dynamic> answer,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/answer"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "peerId": peerId,
        "answer": answer,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getAnswer(
    String peerId,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/answer/$peerId"),
    );

    if (response.statusCode != 200) {
      return null;
    }

    if (response.body == "null") {
      return null;
    }

    return Map<String, dynamic>.from(
      jsonDecode(response.body),
    );
  }

  /// -----------------------------
  /// ICE CANDIDATES
  /// -----------------------------

  Future<bool> sendIceCandidate(
    String peerId,
    Map<String, dynamic> candidate,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/ice"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "peerId": peerId,
        "candidate": candidate,
      }),
    );

    return response.statusCode == 200;
  }

  Future<List<dynamic>> getIceCandidates(
    String peerId,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/ice/$peerId"),
    );

    if (response.statusCode != 200) {
      return [];
    }

    return jsonDecode(response.body);
  }

  /// -----------------------------
  /// SERVER STATUS
  /// -----------------------------

  Future<bool> isServerRunning() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
