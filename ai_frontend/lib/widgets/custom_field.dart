import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final bool isObscure;
  final TextEditingController controller;
  final String hintText;
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObscure = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "$hintText is missing!";
            }
            return null;
          },
          obscureText: isObscure,
        ),
      ),
    );
  }
}
