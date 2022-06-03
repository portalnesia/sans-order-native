
import 'package:get/get.dart';
import 'package:sans_order/screen/apps.dart';
import 'package:sans_order/screen/landing.dart';
import 'package:sans_order/utils/middleware.dart';

List<GetPage<dynamic>> route = [
  GetPage(name: '/apps', page: ()=>const HomePage(),middlewares: [GlobalMiddleware()]),
  GetPage(name: '/login', page: ()=>LandingScreen(),middlewares: [LoginMiddleware()]),
];