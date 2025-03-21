import 'package:ai_frontend/widgets/answer_section.dart';
import 'package:ai_frontend/widgets/source_section.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/supabase_service.dart';
import 'dart:async';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final _queryController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  final ApiService _apiService = ApiService();
  StreamSubscription? _contentSubscription;

  String? _answer;
  List<Map<String, String>> _sources = [];
  List<Map<String, dynamic>> _savedQueries = [];

  @override
  void initState() {
    super.initState();
    _apiService.connect();
    _fetchSavedQueries();
    _contentSubscription = _apiService.contentStream.listen((data) {
      setState(() {
        _answer = data["answer"] ?? "No answer available";
        _sources = List<Map<String, String>>.from(
          (data["sources"] ?? [])
              .map((source) => {"url": source["url"], "title": source["title"]}),
        );
      });

      _saveQueryResponse(_queryController.text, _answer ?? "", _sources);
    });
  }

  Future<void> _fetchSavedQueries() async {
    try {
      final queries = await _supabaseService.fetchQueries();
      setState(() {
        _savedQueries = queries;
      });
    } catch (e) {
       print("Error fetching saved queries: $e");
    }
  }

  void _saveQueryResponse(String query, String answer, List<Map<String, String>> sources) async {
    try {
      await _supabaseService.saveQueryResponse(query: query, answer: answer, sources: sources);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Query saved successfully')),
      );
      _fetchSavedQueries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving query: $e')),
      );
    }
  }

  void onSubmitQuery(String userQuery) {
    if (userQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a query')),
      );
      return;
    }
    _apiService.chat(userQuery);
  }

  @override
  void dispose() {
    _queryController.dispose();
    _contentSubscription?.cancel();
    _apiService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perplexity Clone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Ask a question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onSubmitQuery(_queryController.text),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildSavedQueriesList(),
            ),
            if (_answer != null) ...[
              const SizedBox(height: 20),
              Text(
                "Current Answer:",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              AnswerSection(answer: _answer),
              const SizedBox(height: 16),
              Text(
                "Sources:",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SourceSection(sources: _sources),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSavedQueriesList() {
    if (_savedQueries.isEmpty) {
      return const Center(child: Text('No saved queries yet.'));
    }

    return ListView.builder(
      itemCount: _savedQueries.length,
      itemBuilder: (context, index) {
        final query = _savedQueries[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Query: ${query['query']}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            AnswerSection(answer: query['answer']),
            if (query['sources'] != null && query['sources'].isNotEmpty)
              SourceSection(sources: query['sources']),
            const Divider(),
          ],
        );
      },
    );
  }
}