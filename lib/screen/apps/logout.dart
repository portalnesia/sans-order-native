import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';
import 'package:sans_order/widget/button_menu.dart';
import 'package:sans_order/widget/loading.dart';

class LogoutButton extends StatefulWidget {
  
  const LogoutButton({Key? key}) : super(key: key);
  
  @override
  State<LogoutButton> createState() => _State();
}

class _State extends State<LogoutButton> {
  final oauth = Get.find<OauthControllers>();

  void logoutDialog() {
    var context = Get.context as BuildContext;

    showCupertinoModalPopup(context: context, builder: (_)=>GetBuilder<OauthControllers>(builder: (u)=>CupertinoAlertDialog(
      title: Text("are_you_sure".tr,style: _.theme.textTheme.headline6),
      content: Text('logout_confirmation'.trParams({"what":"@${u.token.user?.username}"}),style: _.theme.textTheme.bodyText1),
      actions: [
        CupertinoDialogAction(onPressed: Get.back,isDefaultAction: true, child: Text("cancel".tr),),
        CupertinoDialogAction(onPressed: logout, isDestructiveAction: true,child: Text("yes".tr)),
      ],
    )));
  }
  
  Future<void> logout() async {
    var context = Get.context as BuildContext;
    Get.back();
    showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);
    await oauth.logout();
    Get.offAllNamed('/login');
  }
  
  @override
  Widget build(BuildContext context) {
    return ButtonMenu(
      icon: Icon(Icons.logout,size: 35,color: context.theme.errorColor,), 
      text: Text('logout'.tr,style: TextStyle(fontSize: 22,color: context.theme.errorColor),),
      onPress: logoutDialog,
    );
  }
}