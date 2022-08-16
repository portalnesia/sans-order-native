import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sans_order/config/setting/base.dart';
import 'package:sans_order/config/setting/locales.dart';
import 'package:sans_order/config/setting/theme.dart';
import 'package:sans_order/utils/main.dart';

class SettingControllers extends GetxController {
  final GetStorage storage = GetStorage();
  late Settings<Locale> locale;
  late Settings<ThemeMode> themeMode;

  SettingControllers() {
    locale = LocaleSetting(storage);
    themeMode = ThemeSetting(storage);
  }

  Map<String,String> json = {};
  var lang = LocaleSetting.defaultValue;
  var theme = ThemeSetting.defaultValue;

  Future<void> init() async {
    if(storage.hasData('setting')) {
      json = Map<String,String>.from(jsonDecode(storage.read('setting')));
    }
    lang = await locale.init(json);
    theme = await themeMode.init(json);

    if(!Platform.isWindows) {
      portalnesia.apiInstance.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          FirebaseAppCheck.instance.getToken().then((value) {
            if(value != null) {
              options.headers.addAll({'X-App-Token': value});
            } else {
              throw 'Cannot get App Token';
            }
          }).catchError((e,stack) {
            handler.reject(e,stack);
          }).whenComplete(() {
            handler.next(options);
          });
        },
      ));
    }
  }

  Future<void> save() async {
    final data = toString();
    await storage.write('setting', data);
  }

  toMap() {
    return json;
  }

  @override
  toString() {
    return jsonEncode(json);
  }
  
  Future<void> changeLang(String data) async {
    lang = await locale.changeValue(data);
    json['lang'] = locale.value;
    save();
    update();
  }

  Future<void> changeTheme(String data) async {
    theme = await themeMode.changeValue(data);
    json['theme'] = themeMode.value;
    save();
    update();
  }
}