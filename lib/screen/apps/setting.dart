import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';

class SettingButton extends StatefulWidget {
  final BorderRadius borderRadius;
  final ShapeBorder shapeBorder;
  
  const SettingButton({Key? key,required this.borderRadius,required this.shapeBorder}) : super(key: key);
  
  @override
  State<SettingButton> createState() => _State();
}

class _State extends State<SettingButton> {
  final oauth = Get.find<OauthControllers>();

  void openSetting() {
    Get.toNamed('/base_setting');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: widget.shapeBorder,
        child: InkWell(
          onTap: openSetting,
          borderRadius: widget.borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings,size: 35,color: context.theme.textTheme.headline1!.color,),
                const SizedBox(height: 15),
                Text('setting'.tr,style: TextStyle(fontSize: 22,color: context.theme.textTheme.headline1!.color),),
              ],
            ),
          ),
        )
      )
    );
  }
}