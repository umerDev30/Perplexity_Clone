import 'package:ai_frontend/services/api_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceSection extends StatefulWidget {
  final List<Map<String, String>>? sources; // Optional parameter for saved/supplied sources
  const SourceSection({super.key, this.sources});

  @override
  State<SourceSection> createState() => _SourceSectionState();
}

class _SourceSectionState extends State<SourceSection> {
  bool isLoading = true;
  List<Map<String, dynamic>> searchResults = [{
      'title': 'Ind vs Aus Live Score 4th Test',
      'url':
          'https://www.moneycontrol.com/sports/cricket/ind-vs-aus-live-score-4th-test'
    },
    {
      'title': 'Ind vs Aus Live Boxing Day Test',
      'url':
          'https://timesofindia.indiatimes.com/sports/cricket/india-vs-australia-live-boxing-day-test'
    },
    {
      'title': 'Ind vs Aus - 4 Australian Batters Score Half Centuries',
      'url':
          'https://economictimes.indiatimes.com/news/sports/ind-vs-aus-four-australian-batters-score-half-centuries'
    },];

  @override
  void initState() {
    super.initState();
    // If sources are provided (e.g., from Supabase), use them immediately
    if (widget.sources != null) {
      setState(() {
        searchResults = widget.sources!.map((source) => {
          'title': source['title'] ?? 'Unknown Title',
          'url': source['url'] ?? 'Unknown URL',
        }).toList().cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      // Listen to ApiService for real-time updates
      ApiService().searchResultStream.listen((data) {
        setState(() {
          searchResults = List<Map<String, dynamic>>.from(data["data"] ?? []);
          isLoading = false;
        });
      });
    }
  }

  @override
  void didUpdateWidget(SourceSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update searchResults if the sources change (e.g., from parent widget)
    if (widget.sources != oldWidget.sources && widget.sources != null) {
      setState(() {
        searchResults = widget.sources!.map((source) => {
          'title': source['title'] ?? 'Unknown Title',
          'url': source['url'] ?? 'Unknown URL',
        }).toList().cast<Map<String, dynamic>>();
        isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.source_outlined, color: Colors.white60),
            SizedBox(width: 8),
            Text('Sources',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
        SizedBox(height: 16),
        Skeletonizer(
          enabled: isLoading,
          effect: ShimmerEffect(
              baseColor: AppColors.footerGrey,
              highlightColor: AppColors.iconGrey,
              duration: Duration(seconds: 2)),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 16,
            runSpacing: 16,
            children: searchResults.map((e) {
              return Container(
                padding: EdgeInsets.all(12),
                width: 150,
                decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text(
                      e['title'] ?? 'Unknown Title',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _launchURL(e['url'] ?? ''),
                      child: Text(
                        e['url'] ?? 'Unknown URL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}