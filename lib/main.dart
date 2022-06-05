import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sans_order/config/theme.dart';
import 'package:sans_order/controllers/settings.dart';
import 'package:sans_order/lang/services.dart';
import 'package:sans_order/route.dart';
import 'controllers/oauth.dart';

void main() {
  initialize('main');
}

void shareMain() {
  initialize('shareMain');
}

Future<void> initialize(String entry) async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final oauth = Get.put(OauthControllers(),permanent: true);
  final setting = Get.put(SettingControllers(),permanent: true);

  try {
    await GetStorage.init();
    await oauth.load();
    await setting.init();
    runApp(MyApp(entry: entry));
    FlutterNativeSplash.remove();
  } finally {
    runApp(MyApp(entry: entry));
    FlutterNativeSplash.remove();
  } 
}

class MyApp extends StatelessWidget {
  final String entry;

  const MyApp({Key? key,this.entry = 'main'}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sans Order',
      theme: myTheme,
      themeMode: ThemeMode.light,
      getPages: route,
      initialRoute: '/login',
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      translations: LocalizationService()
    );
  }
}

/*
class SelectedActivity extends StatefulWidget {
  final String entry;
  final Map<String,Widget> home;

  SelectedActivity({Key? key,required this.entry}) : 
    home = {
      'main': const HomePage(),
      'shareMain': const HomePage()
    },
    super(key: key);

  @override
  State<SelectedActivity> createState() => _SelectedState();
}

class _SelectedState extends State<SelectedActivity> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,Oauth?>(
      converter: (store) => store.state.oauth,
      builder: (_,oauth) {
        return MaterialApp(
          title: 'Sans Order',
          theme: myTheme,
          home: oauth != null && oauth.isLogin(false) && widget.home.containsKey(widget.entry) ? widget.home[widget.entry] : LandingScreen(),
        );
      },
      onInit: (store) {
        Oauth? oauth = store.state.oauth;
        if(oauth != null && !oauth.isLogin(false)) {
          secureStorage.delete(key: 'oauth');
          secureStorage.delete(key: 'user');
        }
      },
    );
  }
}
*/