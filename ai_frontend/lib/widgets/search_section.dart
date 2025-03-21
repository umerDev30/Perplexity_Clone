import 'dart:ui';

import 'package:ai_frontend/services/api_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/views/chat_view.dart';
import 'package:ai_frontend/widgets/search_bar_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/supabase_service.dart';

class SearchSection extends StatefulWidget {
  final bool isOverlay;
  const SearchSection({super.key, this.isOverlay = false});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final TextEditingController queryController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  List<Map<String, dynamic>> _savedQueries = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedQueries();
  }

  @override
  void dispose() {
    queryController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchSavedQueries() async {
    try {
      final queries = await SupabaseService().fetchQueries();
      setState(() {
        _savedQueries = queries;
      });
    } catch (e) {
      print("Error fetching saved queries: $e");
    }
  }

  void _handleSearch() {
    final String query = queryController.text.trim();
    if (query.isNotEmpty) {
      final matchingQuery = _savedQueries.firstWhere(
        (q) => q['query'].toLowerCase().contains(query.toLowerCase()),
        orElse: () => {},
      );

      if (matchingQuery.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatView(question: matchingQuery['query']),
          ),
        );
      } else {
        ApiService().chat(query);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatView(question: query),
          ),
        );
      }
    }
  }

  void _dismissSearch() {
    if (widget.isOverlay) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissSearch,
      child: Stack(
        children: [
          if (widget.isOverlay)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Where Knowledge Begins',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: -0.5,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 700,
                    decoration: BoxDecoration(
                      color: AppColors.searchBar,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.searchBarBorder, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            focusNode: focusNode,
                            controller: queryController,
                            onSubmitted: (_) => _handleSearch(),
                            decoration: const InputDecoration(
                              hintText: 'Search anything...',
                              hintStyle: TextStyle(fontSize: 16, color: AppColors.textGrey),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const SearchBarButton(icon: Icons.auto_awesome_outlined, text: 'Focus'),
                              const SizedBox(width: 20),
                              const SearchBarButton(icon: Icons.add_circle_outline_outlined, text: 'Attach'),
                              const Spacer(),
                              GestureDetector(
                                onTap: _handleSearch,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.submitButton,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.background,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void toShowSearchOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: const SearchSection(isOverlay: true),
    ),
  );
}