import 'package:flutter/material.dart';

import 'package:cms_web/features/shared/utils/app_gradient_theme.dart';
import 'package:cms_web/features/shared/utils/app_shadow_theme.dart';

extension ThemeDataExtension on ThemeData {
  AppShadowTheme get appShadowTheme =>
      extension<AppShadowTheme>() ?? AppShadowTheme();

  AppGradientTheme get appGradientTheme =>
      extension<AppGradientTheme>() ??
      AppGradientTheme.generate(colorScheme: colorScheme);
}
