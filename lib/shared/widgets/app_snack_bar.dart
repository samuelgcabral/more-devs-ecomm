import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  AnimatedSnackBar.material(
    message,
    type: AnimatedSnackBarType.error,
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
  ).show(context);
}

void showSuccessSnackBar(BuildContext context, String message) {
  AnimatedSnackBar.material(
    message,
    type: AnimatedSnackBarType.success,
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
  ).show(context);
}
