import 'dart:ui';

import 'package:get/get.dart';
import 'package:sans_order/config/setting/base.dart';

class LocaleSetting extends Settings<Locale> {
  static List<String> localeOptions = [
    'en',
    'id',
    'auto'
  ];

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', '');

  LocaleSetting(super.storage);

  @override
  Future<Locale> changeValue(data) async {
    if(localeOptions.contains(data)) {
      if(data == 'auto') {
        return Get.deviceLocale ?? defaultValue;
      } else {
        return Locale(data);
      }
    }
    return Get.deviceLocale ?? defaultValue;
  }

  @override
  Future<Locale> init(json) async {
    if(json.containsKey('lang') && json['lang'] != null) {
      final String lang = json['lang'] as String;
      if(localeOptions.contains(lang)) {
        if(lang == 'auto') {
          return Get.deviceLocale ?? defaultValue;
        } else {
          return Locale(lang);
        }
      }
    }
    return Get.locale ?? defaultValue;
  }
  
  static Locale defaultValue = const Locale('en');
}