import 'package:ai_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class SearchBarButton extends StatefulWidget {
  final IconData icon;
  final String text;
  const SearchBarButton({super.key, required this.icon, required this.text});

  @override
  State<SearchBarButton> createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHovered ? AppColors.proButton : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: AppColors.iconGrey,
              size: 20,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: AppColors.textGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
