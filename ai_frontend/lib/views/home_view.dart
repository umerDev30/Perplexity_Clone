import 'package:ai_frontend/services/api_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/widgets/build_sidebar.dart';
import 'package:ai_frontend/widgets/search_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    ApiService().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        //navbar
        BuildSidebar(),
        Expanded(
          child: Padding(
            padding: !kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
            child: Column(
              children: [
                //search Section
                Expanded(
                  child: SearchSection(),
                ),

                //footer
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Pro',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.footerGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Enterprise',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.footerGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Store',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.footerGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Blog',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.footerGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Careers',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.footerGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'English (English)',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.footerGrey),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
