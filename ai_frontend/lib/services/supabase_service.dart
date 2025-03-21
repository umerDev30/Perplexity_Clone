import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveQueryResponse({
    required String query,
    required String answer,
    required List<Map<String, String>> sources,
  }) async {
    try {
      final response = await supabase.from('query_responses').insert({
        'query': query,
        'answer': answer,
        'sources': sources, // Automatically serialized to JSONB
        'user_id': supabase.auth.currentUser?.id, // Optional: include if using auth
      });
      if(kDebugMode) print('Query saved successfully: $response');
    } catch (e) {
       if(kDebugMode) print('Error saving query: $e');
      throw Exception('Failed to save query: $e');
    }
  }
    Future<List<Map<String, dynamic>>> fetchQueries() async {
    try {
      final response = await supabase
          .from('query_responses')
          .select()
          .order('created_at', ascending: false); // Newest first
      return (response as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      if(kDebugMode) print('Error fetching queries: $e');
      throw Exception('Failed to fetch queries: $e');
    }
  }
}

