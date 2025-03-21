import 'package:ai_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AuthGradientButton(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.gradient1, AppColors.gradient2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, 55),
            backgroundColor: AppColors.transparentColor,
            shadowColor: AppColors.transparentColor),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
