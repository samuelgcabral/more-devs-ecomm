import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_colors.dart';

//Classe responsável por armazenar os estilos de texto do app
class AppTextStyle {
  static TextStyle title = TextStyle(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonLabel = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle smallBlack = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );
}
