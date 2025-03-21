import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/widgets/search_section.dart';
import 'package:ai_frontend/widgets/side_nav_bar_button.dart';
import 'package:flutter/material.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  bool isCollapsed = true;
   String? hoveredItem;

  final List<Map<String, dynamic>> _navItems = [
    {'text': 'Home', 'icon': Icons.home},
    {'text': 'Space', 'icon': Icons.language},
    {'text': 'Discover', 'icon': Icons.auto_awesome},
    {'text': 'Library', 'icon': Icons.cloud_outlined},
  ];

 void _handleNavTap(String text) {
  if (text == 'Home') {
    toShowSearchOverlay(context);
  } else if (text == 'Library') {
    Navigator.pushNamed(context, '/library');
  }
}


  @override
  Widget build(BuildContext context) {
    final double width = isCollapsed ? 60 : 150;

    return MouseRegion(
      onEnter: (_) => setState(() => isCollapsed = false),
      onExit: (_) => setState(() => isCollapsed = true),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          color: AppColors.sideNav,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Icon(
                Icons.auto_awesome_mosaic,
                color: AppColors.whiteColor,
                size: isCollapsed ? 30 : 60,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _navItems
                      .map((item) => MouseRegion(
                         onEnter: (_) => setState(() => hoveredItem = item['text']),
                            onExit: (_) => setState(() => hoveredItem = null),
                        child: SideNavBarButton(
                              isCollapsed: isCollapsed,
                              text: item['text'],
                              icon: item['icon'],
                              onTap: () => _handleNavTap(item['text']),
                              isHighlighted: hoveredItem == item['text'],
                            ),
                      ))
                      .toList(),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => isCollapsed = !isCollapsed),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.all(10),
                  child: Icon(
                    isCollapsed
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left,
                    color: AppColors.iconGrey,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
