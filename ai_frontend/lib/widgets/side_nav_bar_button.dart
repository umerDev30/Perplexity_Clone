import 'package:ai_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class SideNavBarButton extends StatelessWidget {
  final bool isCollapsed;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHighlighted;

  const SideNavBarButton({
    super.key,
    required this.isCollapsed,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? Color(0x1AFFFFFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 8), // Reduced padding for better fit
          child: SizedBox(
            width: isCollapsed ? 50 : 140, // Prevent overflow by limiting width

            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.iconGrey,
                  size: 22,
                ),
                if (!isCollapsed) const SizedBox(width: 10),
                if (!isCollapsed)
                  Flexible(
                    // Prevent text overflow
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16, // Slightly reduced font size
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGrey,
                      ),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
