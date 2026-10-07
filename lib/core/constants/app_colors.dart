import 'package:flutter/material.dart';

class AppColors {
  // আপনার অ্যাপের মেইন কালারগুলো এখানে থাকবে
  static const Color primary = Colors.blue;
  static const Color backgroundColor = Colors.black;
}

// ----------------------------------------------------
// !নিচে CustomThemeExtension 
// ----------------------------------------------------

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? successColor;
  final Color? warningColor;

  const CustomThemeExtension({
    required this.successColor,
    required this.warningColor,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? successColor,
    Color? warningColor,
  }) {
    return CustomThemeExtension(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t),
      warningColor: Color.lerp(warningColor, other.warningColor, t),
    );
  }
}
