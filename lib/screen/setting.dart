import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sans_order/controllers/settings.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/appbar.dart';
import 'package:sans_order/widget/back.dart';
import 'package:get/get.dart';
import 'package:sans_order/widget/version.dart';

class HomeSetting extends StatelessWidget {
  HomeSetting({Key? key}) : super(key: key);

  final SettingControllers setting = Get.find<SettingControllers>();

  @override
  Widget build(BuildContext context) {
    void langAction(String lang) async {
      await setting.changeLang(lang);
      Get.back();
    }
    void openLangOption() {
      showCupertinoModalPopup(context: context, builder: (_) => CupertinoActionSheet(
        title: Text('language'.tr),
        cancelButton: CupertinoActionSheetAction(onPressed: Get.back,isDestructiveAction: true, child: Text("cancel".tr),),
        actions: [
          ...(setting.locale.optionsKey.map((key) => CupertinoActionSheetAction(
            child: Text(setting.locale.optionsTitle[key]!,style: TextStyle(color: context.textTheme.headline1!.color),),
            onPressed: () => langAction(key),
          )))
        ],
      ));
    }

    void themeAction(String theme) async {
      await setting.changeTheme(theme);
      Get.back();
    }
    void openThemeOption() {
      showCupertinoModalPopup(context: context, builder: (_) => CupertinoActionSheet(
        title: Text('theme'.tr),
        cancelButton: CupertinoActionSheetAction(onPressed: Get.back,isDestructiveAction: true, child: Text("cancel".tr),),
        actions: [
          ...(setting.themeMode.optionsKey.map((key) => CupertinoActionSheetAction(
            child: Text(setting.themeMode.optionsTitle[key]!.capitalize!,style: TextStyle(color: context.theme.textTheme.headline1!.color),),
            onPressed: () => themeAction(key),
          )))
        ],
      ));
    }

    return Scaffold(
      body: MySliver(
        title: 'setting'.tr,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const MyBackButton(),
        ),
        children: [
          SliverList(delegate: SliverChildListDelegate([
            const _Section(title: 'General'),
            _ListView(
              title: 'language'.tr,
              description: GetBuilder<SettingControllers>(builder: (s) => Text(s.locale.valueLabel,style: context.theme.textTheme.caption,)), 
              onPressed: openLangOption
            ),
            const Divider(height: 1,),
            _ListView(
              title: 'theme'.tr,
              description: GetBuilder<SettingControllers>(builder: (s) => Text(s.themeMode.valueLabel,style: context.theme.textTheme.caption,)), 
              onPressed: openThemeOption
            ),

            const _Section(title: 'About'),
            _ListView(
              title: 'terms_of_service'.tr,
              onPressed: ()=>openUrl(webUrl('/pages/terms-of-services'))
            ),
            const Divider(height: 1,),
            _ListView(
              title: 'privacy_policy'.tr,
              onPressed: ()=>openUrl(webUrl('/pages/privacy-policy'))
            ),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Version()
              ],
            ),
          ])),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final horizontal = const EdgeInsets.only(left: 15,right: 15,bottom: 10);

  const _Section({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Padding(padding: horizontal,child:  Text(title,style: context.theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold))),
        //const Divider(),
      ])
    );
  }
}

class _ListView extends StatelessWidget {
  final String title;
  final Widget? description;
  final void Function() onPressed;

  const _ListView({Key? key, required this.title, this.description,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,style: context.theme.textTheme.headline6),
      subtitle: description,
      enabled: true,
      onTap: onPressed,
      tileColor: context.theme.backgroundColor,
      trailing: Icon(Icons.arrow_forward_ios_rounded,color: context.theme.textTheme.headline1!.color),
    );
  }
}