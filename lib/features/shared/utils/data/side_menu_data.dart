import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/data/models/menu_model.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Annual'),
    MenuModel(icon: Icons.person, title: 'Quarterly'),
    MenuModel(icon: Icons.run_circle, title: 'Monthly'),
  ];
}
