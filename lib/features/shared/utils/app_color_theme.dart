
import 'package:flutter/material.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  final Color primaryColor;

  final Color secondaryColor;

  AppColorTheme({
    this.primaryColor = const Color.fromARGB(255, 19, 125, 103),
    this.secondaryColor = const Color.fromARGB(255, 160, 19, 31),
  });

  @override
  ThemeExtension<AppColorTheme> copyWith({
    Color? appPrimaryColor,
    Color? appSecondaryColor,
  }) {
    return AppColorTheme(
      primaryColor: appPrimaryColor ?? primaryColor,
      secondaryColor: appSecondaryColor ?? secondaryColor,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp(
      covariant ThemeExtension<AppColorTheme>? other,
      double t,
      ) {
    if (other == null) {
      return this;
    }
    return AppColorTheme();
  }
}