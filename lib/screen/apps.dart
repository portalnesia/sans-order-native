import 'package:flutter/material.dart';
import 'package:sans_order/screen/apps/home.dart';
import 'package:sans_order/widget/pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(),
      body: const Pages(
        child: HomeScreen()
      ),
    );
  }
}
