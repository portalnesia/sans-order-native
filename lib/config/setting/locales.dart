import 'dart:ui';

import 'package:get/get.dart';
import 'package:sans_order/config/setting/base.dart';

class LocaleSetting extends Settings<Locale> {
   @override
  List<String> get optionsKey => [
    'en',
    'id',
    'auto'
  ];
  
  @override
  Map<String, String> get optionsTitle => {
    'en': 'English',
    'id': 'Bahasa Indonesia',
    'auto': 'System Language'
  };

  @override
  String get valueLabel => optionsTitle.containsKey(value) ? optionsTitle[value]! : 'System Languages';

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', '');

  LocaleSetting(super.storage);

  @override
  Future<Locale> changeValue(data) async {
    Locale locale = defaultValue;
    value = 'auto';
    if(optionsKey.contains(data)) {
      value = data;
      if(data == 'auto') {
        locale = Get.deviceLocale ?? defaultValue;
      } else {
        locale = Locale(data);
      }
    }
    Get.updateLocale(locale);
    return locale;
  }

  @override
  Future<Locale> init(json) async {
    Locale locale = defaultValue;
    value='auto';
    if(json.containsKey('lang') && json['lang'] != null) {
      final String lang = json['lang'] as String;
      if(optionsKey.contains(lang)) {
        value = lang;
        if(lang == 'auto') {
          locale = Get.deviceLocale ?? defaultValue;
        } else {
          locale = Locale(lang);
        }
      }
    }
    return locale;
  }
  
  static Locale defaultValue = const Locale('en');
}