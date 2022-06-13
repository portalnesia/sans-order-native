import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';
import 'package:sans_order/widget/loading.dart';
import 'package:sans_order/widget/screen.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/version.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);

  final oauth = Get.find<OauthControllers>();

  Future<void> loginAction(BuildContext context) async {
    showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);

    try {
      /*final AuthorizationResponse? resp = await appAuth.authorize(
        AuthorizationRequest(AUTH_CLIENT_ID, AUTH_REDIRECT_URI,issuer: AUTH_ISSUER,scopes: AUTH_SCOPE,serviceConfiguration: serviceConfiguration)
      );
      
      if(resp == null) throw 'Something went wrong';

      print({
        resp.nonce
      });

      final TokenResponse? result = await appAuth.token(
        TokenRequest(AUTH_CLIENT_ID, AUTH_REDIRECT_URI,issuer: AUTH_ISSUER,scopes: AUTH_SCOPE,serviceConfiguration: serviceConfiguration,nonce: resp.nonce,authorizationCode: resp.authorizationCode,codeVerifier: resp.codeVerifier)
      );
      
      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(AUTH_CLIENT_ID, AUTH_REDIRECT_URI,issuer: AUTH_ISSUER,scopes: AUTH_SCOPE,serviceConfiguration: serviceConfiguration)
      );
      */

      final AuthorizationTokenResponse? result = await portalnesia.login();
      
      if(result == null) throw 'Something went wrong';

      await oauth.login(result);
      
      // ignore: use_build_context_synchronously
      Get.offAllNamed('/apps');
    } on PlatformException catch (e) {
      Navigator.pop(context);
      showSnackbar('Error', e.message ?? 'Something went wrong',type: SnackType.error);
      if (kDebugMode) {
        print(e);
      }
    } catch(e) {
      Navigator.pop(context);
      showSnackbar('Error', e.toString(),type: SnackType.error);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'setting'.tr,
            icon: Icon(Icons.settings,color: context.theme.textTheme.headline1!.color),
            onPressed: () => Get.toNamed('/base_setting'),
          )
        ],
      ),
      body: Screen(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  alignment: Alignment.topCenter,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'welcome'.tr,
                      style: TextStyle(color: context.theme.textTheme.headline1!.color,fontSize: 26),
                      children: const [
                        TextSpan(text: 'SansOrder',style: TextStyle(color: Color.fromARGB(255, 47, 111, 78),fontWeight: FontWeight.bold))
                      ]
                    )
                  )
                ),
                
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: ()=>loginAction(context), 
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.login),
                            const SizedBox(width: 15),
                            Text('login'.tr,style: const TextStyle(fontSize: 18),)
                          ],
                        )
                      )
                    ]
                  ),
                ),

              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(onPressed: ()=>openUrl('https://portalnesia.com/pages/terms-of-service'), child: Text('terms_of_service'.tr,style: context.theme.textTheme.bodyText2,)),
                    CupertinoButton(onPressed: ()=>openUrl('https://portalnesia.com/pages/privacy-policy'), child: Text('privacy_policy'.tr,style: context.theme.textTheme.bodyText2)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Version()
                  ],
                ),
                const SizedBox(height: 15,)
              ],
            )
          ],
        ),
      ),
    );
  }
}


/*
class _LandingState extends State {

  Future<void> loginAction(BuildContext context) async {
    showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);

    try {
      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(AUTH_CLIENT_ID, AUTH_REDIRECT_URI,issuer: AUTH_ISSUER,scopes: AUTH_SCOPE,serviceConfiguration: serviceConfiguration)
      );
      if(result == null) throw 'Something went wrong';

      Oauth oauth = Oauth.fromResponse(result);
      User user = User.fromLogin(oauth.id_token!);
      
      await secureStorage.write(key:'oauth', value: oauth.toString());
      await secureStorage.write(key: 'user', value: user.toString());
      
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on PlatformException catch (e) {
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(e.message ?? 'Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch(e) {
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,Oauth?>(
      builder: (_,oauth){
        return Scaffold(
          body: Pages(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      alignment: Alignment.topCenter,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Selamat Datang di ',
                          style: TextStyle(color: Theme.of(context).textTheme.headline1!.color,fontSize: 26),
                          children: const [
                            TextSpan(text: 'SansOrder',style: TextStyle(color: Color.fromARGB(255, 47, 111, 78),fontWeight: FontWeight.bold))
                          ]
                        )
                      )
                    ),
                    
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: ()=>loginAction(context), 
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.login),
                                SizedBox(width: 15),
                                Text('Masuk dengan Portalnesia',style: TextStyle(fontSize: 18),)
                              ],
                            )
                          )
                        ]
                      ),
                    ),

                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: ()=>{}, child: const Text('Terms of Services')),
                        TextButton(onPressed: ()=>{}, child: const Text('Privacy Policy')),
                      ],
                    ),
                    const SizedBox(height: 15,)
                  ],
                )
              ],
            )
          )
        );
      },
      converter: (store) => store.state.oauth,
      onInit: (store) {
        if(store.state.oauth != null) {
          SystemNavigator.pop(animated: true);
        }
      },
    );
  }
}
*/