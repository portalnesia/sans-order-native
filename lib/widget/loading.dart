import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget createLoadingDialog(BuildContext context) => Dialog(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CupertinoActivityIndicator(),
        const SizedBox(height: 15),
        Text("${'wait'.tr}...",style: const TextStyle(fontSize: 18))
      ],
    ),
  ),
);

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CupertinoActivityIndicator(),
        const SizedBox(height: 15),
        Text("${'wait'.tr}...")
      ],
    );
  }
}