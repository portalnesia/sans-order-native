import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';
import 'package:sans_order/widget/loading.dart';

class HomeAppbar extends AppBar {
  HomeAppbar({Key? key}) : super(key: key, 
    title: const Text('SansOrder'),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    bottom: const PreferredSize(preferredSize: Size.fromHeight(110.0), child: HomeProfile())
  );
}

class HomeProfile extends StatelessWidget {
  const HomeProfile({Key? key}) : super(key: key);

  Widget getProfileView() {
    return Stack(
      children: <Widget>[
        GetBuilder<OauthControllers>(builder: (u)=>CircleAvatar(
          radius: 32,
          backgroundColor: Get.theme.backgroundColor,
          backgroundImage: u.user.picture != null ? CachedNetworkImageProvider(u.user.picture!) : null,
          child: u.user.picture == null ? const Icon(Icons.person_outline_rounded) : null,
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, bottom: 20,right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              getProfileView(),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<OauthControllers>(builder: (u)=>Text(
                      u.user.name!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
                    GetBuilder<OauthControllers>(builder: (u)=>Text(
                      '@${u.user.username}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ))
                  ],
                )
              )
            ]
          ),
          
          /*GetBuilder<OauthControllers>(builder: (u)=>Stack(
            children:  [
              ElevatedButton(onPressed: ()=>openUrl('https://portalnesia.com/user/${u.user.username}'), child: const Text('Profile'))
            ],
          ))*/
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final oauth = Get.find<OauthControllers>();

  void logoutDialog() {
    var context = Get.context as BuildContext;

    showDialog(context: context, builder: (_)=>GetBuilder<OauthControllers>(builder: (u)=>AlertDialog(
      title: Text("Anda Yakin?",style: Get.textTheme.headline4),
      content: Text('Keluar dari akun @${u.user.username}',style: Get.textTheme.bodyText1),
      actions: [
        TextButton(onPressed: logout, style: TextButton.styleFrom(primary: Get.theme.errorColor), child: Text("Ya",style: Get.textTheme.headline4!.copyWith(color: Get.theme.errorColor))),
        TextButton(onPressed: Get.back, child: Text('Batal',style: Get.textTheme.headline4))
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

  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(15));
  final ShapeBorder shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)));
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      shape: shapeBorder,
                      child: InkWell(
                        onTap: logoutDialog,
                        borderRadius: borderRadius,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Icon(Icons.logout,size: 35,color: Get.theme.errorColor,),
                              const SizedBox(height: 15),
                              Text('LOGOUT',style: TextStyle(fontSize: 22,color: Get.theme.errorColor),),
                            ],
                          ),
                        ),
                      )
                    ),
                  ]
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}