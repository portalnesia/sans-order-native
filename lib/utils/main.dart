import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sans_order/portalnesia/portalnesia.dart';
import 'package:sans_order/portalnesia/portalnesia_exception.dart';
import 'package:sans_order/utils/oauth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart' as uuid_instance;
export 'package:sans_order/portalnesia/model/portalnesia.dart';
export 'package:sans_order/portalnesia/portalnesia_exception.dart';

FlutterAppAuth appAuth = const FlutterAppAuth();
FlutterSecureStorage secureStorage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
Portalnesia portalnesia = Portalnesia(dotenv.env['API_URL'] as String,AUTH_CLIENT_ID,AUTH_REDIRECT_URI,scopes: AUTH_SCOPE);

String uuid({String? namespace}) {
  const uuid_instance.Uuid uuid = uuid_instance.Uuid();

  String result = uuid.v4();

  if(namespace != null) {
    result = uuid.v5(result, namespace);
  }

  return result;
}

String webUrl(String? path) {
  return dotenv.env['WEB_URL']! + (path ?? ""); 
}

Future<void> openUrl(String uri,{bool webview = false}) async {
  final url = Uri.parse(uri);
  
  if(webview) {
    if(await canLaunchUrl(url)) {
      launchUrl(url,mode: LaunchMode.externalApplication);
    }
  } else {
    try {
      await custom_tabs.launch(uri,customTabsOption: custom_tabs.CustomTabsOption(
        toolbarColor: Get.theme.primaryColor
      ));
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
  bool instantInit = true,
}) {
  Map<SnackType,Color?> background = {
    SnackType.success: Get.theme.primaryColor.withAlpha(225),
    SnackType.error: Get.theme.errorColor.withAlpha(225),
    SnackType.info: Get.theme.backgroundColor.withAlpha(225)
  };
  Map<SnackType,Color?> colorText = {
    SnackType.success: Colors.white,
    SnackType.error: Colors.white,
    SnackType.info: Get.textTheme.headline1!.color
  };

  return Get.snackbar(
    title,
    message,
    colorText: colorText[type],
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
    margin: const EdgeInsets.all(0),
    barBlur: 5,
    borderRadius: 0,
    instantInit: instantInit
  );
}

String staticUrl(String? path) {
  String url = path == null ? '' : '/$path';
  return 'https://content.portalnesia.com$url';
}

String photoUrl(String? url) {
  final notFoundUrl = 'img/content?image=${Uri.encodeComponent('notfound.png')}';
  return (url ?? staticUrl(notFoundUrl));
}

Widget errorBuilder(AsyncSnapshot? snaps) {
  String error = 'Something went wrong';
  if(snaps?.error is PortalnesiaException) {
    final e = snaps?.error as PortalnesiaException;
    error = e.message;
  }

  return Text('Error: $error');
}