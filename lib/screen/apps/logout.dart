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

    showDialog(context: context, builder: (_)=>GetBuilder<OauthControllers>(builder: (u)=>AlertDialog(
      title: Text("Anda Yakin?",style: Get.textTheme.headline6),
      content: Text('Keluar dari akun @${u.user.username}',style: Get.textTheme.bodyText1),
      actions: [
        TextButton(onPressed: logout, style: TextButton.styleFrom(primary: Get.theme.errorColor), child: Text("Ya",style: Get.textTheme.headline6!.copyWith(color: Get.theme.errorColor))),
        TextButton(onPressed: Get.back, child: Text('Batal',style: Get.textTheme.headline6))
      ],
    )));
  }
  
  Future<void> logout() async {
    var context = Get.context as BuildContext;
    Get.back();
    showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);
    await Future.delayed(const Duration(seconds: 5));
    //await oauth.logout();
    Get.back();
    //Get.offAllNamed('/login');
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: widget.shapeBorder,
        child: InkWell(
          onTap: logoutDialog,
          borderRadius: widget.borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout,size: 35,color: Get.theme.errorColor,),
                const SizedBox(height: 15),
                Text('Logout',style: TextStyle(fontSize: 22,color: Get.theme.errorColor),),
              ],
            ),
          ),
        )
      )
    );
  }
}