class ChatHistoryModel {
  final int id;
  final String query;
  final String answer;
  final List<Map<String, String>> sources;
  final DateTime createdAt;
  final String? userId;

  ChatHistoryModel({
    required this.id,
    required this.query,
    required this.answer,
    required this.sources,
    required this.createdAt,
    this.userId,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      id: json['id'],
      query: json['query'],
      answer: json['answer'],
      sources: (json['sources'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
    );
  }
}