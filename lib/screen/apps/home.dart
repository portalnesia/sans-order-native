import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/screen/apps/logout.dart';
import 'package:sans_order/screen/apps/setting.dart';
import 'package:sans_order/screen/apps/transitionappbar.dart';
import 'package:sans_order/widget/version.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: TransitionAppBarDelegate(
            extent:170
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const HomeScreen()
          ]),
        )
      ],
    );
  }

}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

BorderRadius borderRadius = const BorderRadius.all(Radius.circular(15));
ShapeBorder shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)));

class _HomeState extends State<HomeScreen> {
  
  final List<Widget> Test = [
    SettingButton(borderRadius: borderRadius, shapeBorder: shapeBorder),
    LogoutButton(borderRadius: borderRadius, shapeBorder: shapeBorder),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              SettingButton(borderRadius: borderRadius, shapeBorder: shapeBorder),
              LogoutButton(borderRadius: borderRadius, shapeBorder: shapeBorder)
            ]
          ),
          const SizedBox(height: 25,),

          Align(alignment: Alignment.centerLeft,child: Text('managed_merchant'.tr,style: Get.textTheme.headline3,),),
          const Divider(),
          const SizedBox(height: 5,),
          /*SizedBox(
            height: 150,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (_,i)=>Test.elementAt(i)
            ),
          ),*/

          const SizedBox(height: 25,),
          Align(alignment: Alignment.centerLeft,child: Text('managed_merchant'.tr,style: Get.textTheme.headline3,),),
          const Divider(),

          const SizedBox(height: 15,),
          Version(textColor: Get.textTheme.bodyText2!.color)
        ],
      )
    );
  }
}