import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void backAction() {
  final route = Get.previousRoute;
  if(route.isEmpty) {
    Get.offAllNamed('/apps');
  } else {
    Get.back();
  }
}

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoButton(onPressed: backAction, child: Icon(CupertinoIcons.back,color: Colors.white,));
  }

}