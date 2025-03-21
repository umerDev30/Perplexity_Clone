import 'package:ai_frontend/widgets/side_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildSidebar extends StatelessWidget {
  const BuildSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
    return SideNavBar();
  }
  return SizedBox();
}
  
}