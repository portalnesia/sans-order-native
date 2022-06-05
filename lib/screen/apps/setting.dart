import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/loading.dart';

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
    showSnackbar('Sorry', 'This feature is under maintenance',type: SnackType.error);
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
                Icon(Icons.settings,size: 35,color: Get.textTheme.headline1!.color,),
                const SizedBox(height: 15),
                Text('Setting',style: TextStyle(fontSize: 22,color: Get.textTheme.headline1!.color),),
              ],
            ),
          ),
        )
      )
    );
  }
}