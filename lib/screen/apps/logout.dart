import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';
import 'package:sans_order/widget/loading.dart';

class LogoutButton extends StatefulWidget {
  final BorderRadius borderRadius;
  final ShapeBorder shapeBorder;
  
  const LogoutButton({Key? key,required this.borderRadius,required this.shapeBorder}) : super(key: key);
  
  @override
  State<LogoutButton> createState() => _State();
}

class _State extends State<LogoutButton> {
  final oauth = Get.find<OauthControllers>();

  void logoutDialog() {
    var context = Get.context as BuildContext;

    showDialog(context: context, builder: (_)=>GetBuilder<OauthControllers>(builder: (u)=>CupertinoAlertDialog(
      title: Text("Anda Yakin?",style: _.theme.textTheme.headline6),
      content: Text('Keluar dari akun @${u.token.user?.username}',style: _.theme.textTheme.bodyText1),
      actions: [
        CupertinoDialogAction(onPressed: Get.back,isDefaultAction: true, child: const Text("Batal"),),
        CupertinoDialogAction(onPressed: logout, isDestructiveAction: true,child: const Text("Ya")),
      ],
    )));
  }
  
  Future<void> logout() async {
    var context = Get.context as BuildContext;
    Get.back();
    showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);
    await oauth.logout();
    Get.offAllNamed('/login');
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        shape: widget.shapeBorder,
        child: InkWell(
          onTap: logoutDialog,
          borderRadius: widget.borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout,size: 35,color: context.theme.errorColor,),
                const SizedBox(height: 15),
                Text('logout'.tr,style: TextStyle(fontSize: 22,color: context.theme.errorColor),),
              ],
            ),
          ),
        )
      )
    );
  }
}