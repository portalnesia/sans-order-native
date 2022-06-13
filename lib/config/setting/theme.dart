import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/config/setting/base.dart';

class ThemeSetting extends Settings<ThemeMode> {
  ThemeSetting(super.storage);

  @override
  Future<ThemeMode> changeValue(data) async {
    ThemeMode theme = ThemeMode.system;
    value = 'auto';
    if(optionsKey.contains(data)) {
        value = data;
        theme = data == 'light' ? ThemeMode.light : data == 'dark' ? ThemeMode.dark : ThemeMode.system;
      }
    Get.changeThemeMode(theme);
    return theme;
  }

  @override
  Future<ThemeMode> init(Map<String, String> json) async {
    ThemeMode theme = ThemeMode.system;
    value='auto';
    if(json.containsKey('theme') && json['theme'] != null) {
      final String strLang = json['theme'] as String;
      if(optionsKey.contains(strLang)) {
        value = strLang;
        theme = strLang == 'light' ? ThemeMode.light : strLang == 'dark' ? ThemeMode.dark : ThemeMode.system;
      }
    }
    return theme;
  }

  @override
  List<String> get optionsKey => [
    'auto',
    'light',
    'dark',
  ];

  @override
  Map<String, String> get optionsTitle => {
    'auto': 'theme_what'.trParams({'what':'system'.tr}).capitalize!,
    'light': 'theme_what'.trParams({'what':'light'.tr}).capitalize!,
    'dark': 'theme_what'.trParams({'what':'dark'.tr}).capitalize!
  };

  @override
  String get valueLabel => optionsTitle.containsKey(value) ? optionsTitle[value]! : 'theme_what'.trParams({'what':'system'.tr}).capitalizeFirst!;

  static ThemeMode defaultValue = ThemeMode.system;
}