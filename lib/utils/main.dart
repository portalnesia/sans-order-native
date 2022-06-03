import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart' as uuid_instance;

FlutterAppAuth appAuth = const FlutterAppAuth();
FlutterSecureStorage secureStorage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

String uuid({String? namespace}) {
  const uuid_instance.Uuid uuid = uuid_instance.Uuid();

  String result = uuid.v4();

  if(namespace != null) {
    result = uuid.v5(result, namespace);
  }

  return result;
}

Future<void> openUrl(String uri,{bool webview = false}) async {
  final url = Uri.parse(uri);
  
  if(webview) {
    if(await canLaunchUrl(url)) {
      launchUrl(url,mode: LaunchMode.externalApplication);
    }
  } else {
    try {
      await custom_tabs.launch(uri);
    } catch (_){

    }
  }
}

enum SnackType {
  error,
  success,
  info
}

SnackbarController showSnackbar(String title,String message,{
  SnackPosition? snackPosition = SnackPosition.BOTTOM,
  Widget? icon,
  Color? leftBarIndicatorColor,
  Gradient? backgroundGradient,
  TextButton? mainButton,
  void Function(GetSnackBar)? onTap,
  bool? isDismissible,
  bool? showProgressIndicator,
  DismissDirection? dismissDirection = DismissDirection.down,
  AnimationController? progressIndicatorController,
  Color? progressIndicatorBackgroundColor,
  Animation<Color>? progressIndicatorValueColor,
  SnackStyle? snackStyle,
  SnackType type = SnackType.success,
}) {
  Map<SnackType,Color?> background = {
    SnackType.success: Get.theme.primaryColor,
    SnackType.error: Get.theme.errorColor,
    SnackType.info: null
  };

  return Get.snackbar(
    title,
    message,
    colorText: Colors.white,
    backgroundColor: background[type],
    snackPosition: snackPosition,
    snackStyle: snackStyle,
    showProgressIndicator: showProgressIndicator,
    mainButton: mainButton,
    backgroundGradient: backgroundGradient,
    icon: icon,
    progressIndicatorValueColor: progressIndicatorValueColor,
    dismissDirection: dismissDirection,
    isDismissible: isDismissible,
    onTap:onTap,
    leftBarIndicatorColor: leftBarIndicatorColor,
    progressIndicatorController: progressIndicatorController,
    progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
    margin: const EdgeInsets.only(bottom: 15,left:5,right: 5)
  );
}
