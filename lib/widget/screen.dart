//import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Screen extends StatefulWidget {
  final Widget child;
  const Screen({Key? key,required this.child}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final SnackBar snackbar = SnackBar(content: Text('Press once again to exit application',style: Get.textTheme.headline6?.copyWith(color: Colors.white)));
  bool isSnackbarOpen = false;

  @override
  Widget build(BuildContext context) {
    Future<bool> willPop() async {
      final route = Get.rawRoute;
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: invalid_use_of_protected_member
      if(route?.hasActiveRouteBelow == false) {
        if(isSnackbarOpen == false) {
          setState(() {
            isSnackbarOpen = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(snackbar).closed.then((value) {
            setState(() {
              isSnackbarOpen = false;
            });
          });
          //showSnackbar('Press once again to exit application', 'SansOrder Team');
          return false;
        }
      }
      return true;
    }
    return WillPopScope(onWillPop: willPop, child: widget.child);
  }
}