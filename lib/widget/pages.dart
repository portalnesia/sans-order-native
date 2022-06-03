import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

class Pages extends StatelessWidget {
  final Widget child;
  const Pages({Key? key,required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(snackBar: const SnackBar(content: Text('Press once again to exit')), child: child);
  }
}