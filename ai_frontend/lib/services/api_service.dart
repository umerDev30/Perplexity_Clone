import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../services/supabase_service.dart';

class ApiService {
  static final _instance = ApiService._internal();
  WebSocket? _socket;

  factory ApiService() => _instance;
  ApiService._internal();

  final _searchResultController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _contentController = StreamController<Map<String, dynamic>>.broadcast();
  final _imageController = StreamController<String?>.broadcast();
  final _connectionStateController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get searchResultStream =>
      _searchResultController.stream;
  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;
  Stream<String?> get imageStream => _imageController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  void connect() {
    if (_socket != null) {
      if (kDebugMode) print("WebSocket is already connected.");
      return;
    }

    try {
      _socket = WebSocket(Uri.parse("ws://localhost:8000/ws/chat"));
      _connectionStateController.add(true);

      _socket!.messages.listen(
        (message) {
          try {
            final data = json.decode(message) as Map<String, dynamic>? ?? {};

            if (data["type"] == "search_result") {
              _searchResultController.add(data);
              _saveToSupabaseIfValid(data, isSearchResult: true);
            } else if (data["type"] == "content") {
              _contentController.add(data);
              if (data.containsKey("image")) {
                _imageController.add(data["image"] as String?);
              }
              _saveToSupabaseIfValid(data, isSearchResult: false);
            }
          } catch (e) {
            if (kDebugMode) print("Error parsing message: $e");
          }
        },
        onError: (error) {
          if (kDebugMode) print("WebSocket error: $error");
          _connectionStateController.add(false);
        },
        onDone: () {
          if (kDebugMode) print("WebSocket connection closed");
          _connectionStateController.add(false);
          _socket = null;
        },
      );
    } catch (e) {
      if (kDebugMode) print("Error connecting to WebSocket: $e");
      _connectionStateController.add(false);
    }
  }

  void disconnect() {
    _socket?.close();
    _connectionStateController.add(false);
    _socket = null;
    if (kDebugMode) print("WebSocket disconnected");
  }

  void chat(String query) {
    if (_socket == null) {
      if (kDebugMode) print("WebSocket is not connected.");
      return;
    }

    try {
      _socket!.send(json.encode({"query": query}));
    } catch (e) {
      if (kDebugMode) print("Error sending message: $e");
    }
  }

  void dispose() {
    _searchResultController.close();
    _contentController.close();
    _imageController.close();
    _connectionStateController.close();
    disconnect();
  }

  // Private helper method to save data to Supabase
  Future<void> _saveToSupabaseIfValid(Map<String, dynamic> data,
      {required bool isSearchResult}) async {
    try {
      // Explicitly cast data values to nullable types to handle potential nulls
      final String? query = data['query'] as String?;
      final String? answer = isSearchResult
          ? data['result'] as String?
          : data['content'] as String?;
      final List<Map<String, String>> sources = _extractSources(data);

      // Check for null or empty values explicitly
      if (query != null && answer != null && sources.isNotEmpty) {
        await SupabaseService().saveQueryResponse(
          query: query,
          answer: answer,
          sources: sources,
        );
        if (kDebugMode) print("Query saved to Supabase successfully: $query");
      } else {
        if (kDebugMode)
          print("Skipping save to Supabase: Missing required fields");
      }
    } catch (e) {
      if (kDebugMode) print("Error saving to Supabase: $e");
    }
  }

  // Helper method to extract sources from the WebSocket response (customize based on your data format)
  List<Map<String, String>> _extractSources(Map<String, dynamic> data) {
    final List<dynamic>? sourceList = data['sources'] as List<dynamic>?;
    if (sourceList != null && sourceList.isNotEmpty) {
      return sourceList
          .map((source) => {
                'url': (source['url'] as String?) ?? 'Unknown URL',
                'title': (source['title'] as String?) ?? 'Unknown Title',
              })
          .cast<Map<String, String>>()
          .toList();
    }
    return [
      {
        'url': 'https://default-source.com',
        'title': 'Default Source'
      }, // Fallback
    ];
  }
}
