import 'package:ai_frontend/services/api_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/widgets/build_sidebar.dart';
import 'package:ai_frontend/widgets/main_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ChatView extends StatefulWidget {
  final String question;

  const ChatView({super.key, required this.question});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String? imageUrl;
  final _queryController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _chatMessages = [];

  @override
  void initState() {
    super.initState();
    _apiService.imageStream.listen((url) {
      setState(() {
        imageUrl = url;
      });
    });

    _fetchInitialQueries();
  }

  Future<void> _fetchInitialQueries() async {
    try {
      final queries = await _supabaseService.fetchQueries();
      setState(() {
        _chatMessages = queries;
      });
    } catch (e) {
      if (kDebugMode) print("Error fetching initial queries: $e");
    }
  }

  void onSubmitQuery(String userQuery) async {
    if (userQuery.isEmpty) {
      if (kDebugMode) print("Query cannot be empty.");
      return;
    }

    setState(() {
      _chatMessages.add({'query': userQuery, 'answer': 'Loading...', 'sources': []});
    });

    try {
      _apiService.chat(userQuery);

      late String answer;
      late List<Map<String, String>> sources;

      await for (var data in _apiService.contentStream) {
        if (data['query'] == userQuery) {
          answer = data['content'] as String;
          // Extract sources directly from the data, assuming they are in the 'sources' key
          sources = (data['sources'] as List<dynamic>?)
              ?.map((source) => {
                    'url': source['url'] as String? ?? 'Unknown URL',
                    'title': source['title'] as String? ?? 'Unknown Title',
                  })
              .cast<Map<String, String>>()
              .toList() ?? [
            {'url': 'https://default-source.com', 'title': 'Default Source'}
          ];
          break;
        }
      }

      setState(() {
        final messageIndex = _chatMessages.indexWhere((msg) => msg['query'] == userQuery);
        if (messageIndex != -1) {
          _chatMessages[messageIndex] = {
            'query': userQuery,
            'answer': answer,
            'sources': sources,
          };
        }
      });
    } catch (e) {
      if (kDebugMode) print("Error submitting query: $e");
      setState(() {
        final messageIndex = _chatMessages.indexWhere((msg) => msg['query'] == userQuery);
        if (messageIndex != -1) {
          _chatMessages[messageIndex] = {
            'query': userQuery,
            'answer': 'Error: Failed to load answer',
            'sources': [],
          };
        }
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          BuildSidebar(),
          kIsWeb ? SizedBox(width: 50) : SizedBox(),
          Expanded(
            child: MainContent(
              question: widget.question,
              chatMessages: _chatMessages,
              onSubmitQuery: onSubmitQuery,
              queryController: _queryController,
            ),
          ),
          kIsWeb
              ? Container(
                  width: 300,
                  height: double.infinity,
                  color: AppColors.background,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/default_placeholder.png');
                          },
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            "No image available",
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}