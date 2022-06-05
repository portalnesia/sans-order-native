import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sans_order/config/setting/base.dart';
import 'package:sans_order/config/setting/locales.dart';

class SettingControllers extends GetxController {
  final GetStorage storage = GetStorage();
  late Settings locale;

  SettingControllers() {
    locale = LocaleSetting(storage);
  }

  Map<String,String> json = {};
  var lang = LocaleSetting.defaultValue;

  Future<void> init() async {
    if(storage.hasData('setting')) {
      json = jsonDecode(storage.read('setting'));
    }
    await locale.init(json);
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
    save();
    update();
  }
}