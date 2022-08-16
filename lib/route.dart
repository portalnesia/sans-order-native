
import 'package:get/get.dart';
import 'package:sans_order/screen/apps/apps.dart';
import 'package:sans_order/screen/landing.dart';
import 'package:sans_order/screen/toko/toko.dart';
import 'package:sans_order/utils/middleware.dart';

List<GetPage<dynamic>> route = [
  GetPage(name: '/apps', page: ()=>const HomePage(),middlewares: [GlobalMiddleware()]),
  GetPage(name: '/login', page: ()=>LandingScreen(),middlewares: [LoginMiddleware()]),
  GetPage(name: '/apps/:toko_id', page: ()=>const TokoHome(),middlewares: [GlobalMiddleware()]),
  //GetPage(name: '/base_setting', page: ()=>HomeSetting()),
  //GetPage(name: '/apps/lists', page: () => const AppsPagination(),middlewares: [GlobalMiddleware()])
];