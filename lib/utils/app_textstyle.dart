import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextstyle {
  static const TextStyle xlBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle mdMeddium = TextStyle(
    fontSize: 16,
  );
  static const TextStyle smMedium = TextStyle(
    fontSize: 14,
  );
  static const TextStyle mdBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: Colors.black,
  );
  static const TextStyle xsMedium = TextStyle(
    fontSize: 12,
    color: Colors.black,
  );
  static const TextStyle mdSemiBold = TextStyle(
    color: Colors.black,
    fontSize: 14,
  );
  static const TextStyle lgBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle smSemiBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle greenStyle = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const redStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static const blackStyle = TextStyle(
    color: Colors.black,
  );
}
