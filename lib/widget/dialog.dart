import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/widget/appbar.dart';
import 'package:sans_order/widget/back.dart';
import 'package:sans_order/widget/screen.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final List<Widget>? actions;
  final bool withScroll;
  final bool canBack;

  const MyDialog({Key? key,required this.title,required this.children,this.actions,this.withScroll = true,this.canBack=true}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      return canBack ? Future.value(true) : 
        await showCupertinoModalPopup(context: context, builder: (context)=>CupertinoAlertDialog(
          title: Text("are_you_sure".tr,style: context.theme.textTheme.headline6),
          content: Text("back_confirmation".tr,style: context.theme.textTheme.bodyText1),
          actions: [
            CupertinoDialogAction(onPressed: () => Get.back(result: false,canPop: false,closeOverlays: true),isDefaultAction: true, child: Text("cancel".tr),),
            CupertinoDialogAction(onPressed: () => Get.back(result: true,closeOverlays: true), isDestructiveAction: true,child: Text("yes".tr)),
          ],
        ));
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: withScroll ? null : AppBar(
          backgroundColor: Colors.transparent,
          leading: MyCloseButton(canBack: canBack),
          actions: actions,
          title: Text(title,style: context.theme.textTheme.headline4!.copyWith(color: Colors.white,fontWeight: FontWeight.bold)),
        ),
        body:  Screen(
          child: withScroll ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(pinned: true,delegate: SliversDelegate(
                title: title,
                height: 84,
                borderAnimation: false,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: MyCloseButton(canBack: canBack),
                  actions: actions,
                ),
              )),
              SliverList(
                delegate: 
                  //SliverChildBuilderDelegate((_,i) => const HomeScreen())
                  SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right:10,bottom:10,top:20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...children
                        ],
                      ),
                    )
                  ]),
              )
            ]
          ) : Padding(
            padding: const EdgeInsets.only(left: 10,right:10,bottom:10,top:20),
            child: Column(
              children: [
                ...children
              ],
            ),
          )
        )
      ),
    );
  }
}