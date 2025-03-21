import 'package:ai_frontend/services/api_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  final String? answer; // Optional parameter for saved/supplied answer
  const AnswerSection({super.key, this.answer});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  bool isLoading = true;
  String fullResponse = '''
Artificial Intelligence (AI) is important because it can improve efficiency and productivity in various industries,
automate non-routine tasks, and solve complex problems12.
AI systems can perform tasks that typically require human intelligence, such as decision-making, speech recognition, visual perception, and language translation1.
It is the basis for computer learning and the future of complex decision making3.

Key benefits and applications of AI:

Efficiency and Productivity AI-powered robots can perform repetitive and time-consuming tasks in manufacturing, freeing up human workers for more complex work1.

Personalized Recommendations AI is used to provide personalized recommendations in various industries like marketing and entertainment1.

Data Analysis and Prediction AI can process and analyze large datasets rapidly to identify patterns and make predictions, which aids in making robust decisions25.

Customer Service AI-powered tools like call bots and chatbots can streamline customer interactions to boost engagement and satisfaction2.

Improved accuracy AI enhances human intelligence to improve the quality6. When programmed correctly, errors can be reduced5.

Smarter Surveillance AI improves security and surveillance by monitoring and analyzing vast amounts of data and detecting unusual activities5.

Increase in Workforce Productivity AI-powered tools can help manage and optimize various aspects of work, allowing employees to focus on more strategic and creative tasks5.''';

  @override
  void initState() {
    super.initState();
    // If an answer is provided (e.g., from Supabase), use it immediately
    if (widget.answer != null) {
      setState(() {
        fullResponse = widget.answer!;
        isLoading = false;
      });
    } else {
      // Listen to ApiService for real-time updates
      ApiService().contentStream.listen((data) {
        if (isLoading) {
          fullResponse = '';
        }
        setState(() {
          fullResponse += data["data"] ?? '';
          isLoading = false;
        });
        print(fullResponse);
      });
    }
  }

  @override
  void didUpdateWidget(AnswerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update fullResponse if the answer changes (e.g., from parent widget)
    if (widget.answer != oldWidget.answer && widget.answer != null) {
      setState(() {
        fullResponse = widget.answer!;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perplexity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Skeletonizer(
          enabled: isLoading,
          effect: ShimmerEffect(
              baseColor: AppColors.footerGrey,
              highlightColor: AppColors.iconGrey,
              duration: Duration(seconds: 2)),
          child: Markdown(
            data: fullResponse.isEmpty ? 'No answer available' : fullResponse,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                    codeblockDecoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(10)),
                    code: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}