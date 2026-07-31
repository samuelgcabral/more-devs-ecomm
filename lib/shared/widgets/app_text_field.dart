import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        // suffixIcon: Icon(Icons.visibility),
        // fillColor: AppColors.black,
        // filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.grey100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.grey100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.grey100),
        ),
      ),
    );
  }
}
