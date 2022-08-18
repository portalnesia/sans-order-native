
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';

class GlobalMiddleware extends GetMiddleware {
  final oauth = Get.find<OauthControllers>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if(oauth.token.isLogin()) {
      return null;
    }
    return const RouteSettings(name: '/login');
  }
}

class LoginMiddleware extends GetMiddleware {
  final oauth = Get.find<OauthControllers>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if(!oauth.token.isLogin()) {
      return null;
    }
    return const RouteSettings(name: '/apps');
  }
}