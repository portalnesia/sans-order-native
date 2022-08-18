import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';
import 'package:sans_order/widget/button_menu.dart';
import 'package:sans_order/screen/setting.dart';

class SettingButton extends StatefulWidget {
  const SettingButton({Key? key}) : super(key: key);
  
  @override
  State<SettingButton> createState() => _State();
}

class _State extends State<SettingButton> {
  final oauth = Get.find<OauthControllers>();

  void openSetting() {
    Get.to(() => HomeSetting());
  }

  @override
  Widget build(BuildContext context) {
    return ButtonMenu(
      icon: Icon(Icons.settings,size: 35,color: context.theme.textTheme.headline1!.color,), 
      text: Text('setting'.tr,style: TextStyle(fontSize: 22,color: context.theme.textTheme.headline1!.color),),
      onPress: openSetting,
    );
  }
}