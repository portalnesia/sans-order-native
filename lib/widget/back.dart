import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/screen/setting.dart';

void backAction() {
  final route = Get.previousRoute;
  if(route.isEmpty) {
    Get.offAllNamed('/apps');
  } else {
    Get.back(closeOverlays: true);
  }
}

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoButton(onPressed: backAction, child: Icon(CupertinoIcons.back,color: Colors.white,));
  }
}

class MyCloseButton extends StatelessWidget {
  final bool canBack;
  const MyCloseButton({Key? key,this.canBack = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void doubleBack() {
      Get.back(closeOverlays: true);
      Get.back(closeOverlays: true);
    }
    void closeAction() {
      if(canBack) {
        Get.back(closeOverlays: true);
      } else {
        showCupertinoModalPopup(context: context, builder: (context)=>CupertinoAlertDialog(
          title: Text("are_you_sure".tr,style: context.theme.textTheme.headline6),
          content: Text("back_confirmation".tr,style: context.theme.textTheme.bodyText1),
          actions: [
            CupertinoDialogAction(onPressed: () => Get.back(closeOverlays: true),isDefaultAction: true, child: Text("cancel".tr),),
            CupertinoDialogAction(onPressed: doubleBack, isDestructiveAction: true,child: Text("yes".tr)),
          ],
        ));
      }
    }
    
    return CupertinoButton(onPressed: closeAction, child: const Icon(CupertinoIcons.clear,color: Colors.white,));
  }
}

class SettingActionButton extends StatelessWidget {
  const SettingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'setting'.tr,
      icon: const Icon(Icons.settings,color: Colors.white),
      onPressed: () => Get.to(() => HomeSetting()),
    );
  }

}