import 'package:ai_frontend/widgets/answer_section.dart';
import 'package:ai_frontend/widgets/source_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart'; // For clipboard functionality

class MainContent extends StatelessWidget {
  final String question;
  final List<Map<String, dynamic>> chatMessages;
  final void Function(String) onSubmitQuery;
  final TextEditingController queryController;

  const MainContent({
    super.key,
    required this.question,
    required this.chatMessages,
    required this.onSubmitQuery,
    required this.queryController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content (question, chat history, sources, answer)
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _questionText(question),
                const SizedBox(height: 25),
                if (chatMessages.isNotEmpty) _buildChatHistory(),
                const SizedBox(height: 25),
                SourceSection(
                    sources: chatMessages.isNotEmpty
                        ? chatMessages.last['sources']
                        : null),
                const SizedBox(height: 25),
                AnswerSection(
                    answer: chatMessages.isNotEmpty
                        ? chatMessages.last['answer']
                        : null),
              ],
            ),
          ),
        ),
        // Floating text field at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color:
                  Color.fromRGBO(0, 0, 0, 0.4), // Semi-transparent background
              borderRadius: BorderRadius.circular(16), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                      hintText: 'Ask a follow-up...',
                      hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    onSubmitted: (value) =>
                        onSubmitQuery(value), // Submit on Enter/Return
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue, size: 20),
                  onPressed: () => onSubmitQuery(
                      queryController.text), // Submit on Send icon tap
                  tooltip: 'Send',
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline,
                      color: Colors.green, size: 20),
                  onPressed: () {
                    // Handle follow-up logic (e.g., prompt for a follow-up question)
                    _showFollowUpDialog(context);
                  },
                  tooltip: 'chat',
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.grey, size: 20),
                  onPressed: () {
                    // Share the last answer (if available)
                    _shareAnswer(
                        chatMessages.isNotEmpty
                            ? chatMessages.last['answer']
                            : null,
                        context);
                  },
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.grey, size: 20),
                  onPressed: () {
                    // Copy the last answer to clipboard (if available)
                    _copyAnswerToClipboard(
                        chatMessages.isNotEmpty
                            ? chatMessages.last['answer']
                            : null,
                        context);
                  },
                  tooltip: 'Copy',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionText(String question) {
    return Text(
      question,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildChatHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chatMessages.map((message) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You: ${message['query']}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "AI: ${message['answer']}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            if (message['sources'] != null && message['sources'].isNotEmpty)
              Text(
                "Sources: ${message['sources'].map((s) => s['title']).join(', ')}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 15),
          ],
        );
      }).toList(),
    );
  }

  // Show a dialog for follow-up questions
  void _showFollowUpDialog(BuildContext context) {
    final followUpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Ask a Follow-Up Question',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: followUpController,
          decoration: InputDecoration(
            hintText: 'Type your follow-up question...',
            hintStyle: TextStyle(color: Colors.white60),
            border: OutlineInputBorder(),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              if (followUpController.text.isNotEmpty) {
                onSubmitQuery(
                    followUpController.text); // Submit the follow-up query
              }
              Navigator.pop(context);
            },
            child: Text('Send', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // Share the last answer
  void _shareAnswer(String? answer, BuildContext context) async {
    if (answer != null && answer.isNotEmpty) {
      await Share.share('Answer: $answer');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No answer available to share')),
      );
    }
  }

  // Copy the last answer to clipboard
  void _copyAnswerToClipboard(String? answer, BuildContext context) async {
    if (answer != null && answer.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: answer));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Answer copied to clipboard')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No answer available to copy')),
      );
    }
  }
}
