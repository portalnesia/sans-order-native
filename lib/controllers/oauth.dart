
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:sans_order/model/oauth.dart';
import 'package:sans_order/model/user.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/utils/oauth.dart';

class OauthProvider extends GetConnect {
  Future<Response> revokeAccessToken(Oauth oauth) async {
    return post('$AUTH_DOMAIN/revoke','token_type_hint=access_token&token=${oauth.access_token}',contentType: 'application/x-www-form-urlencoded');
  }
  Future<Response> revokeRefreshToken(Oauth oauth) async {
    return post('$AUTH_DOMAIN/revoke','token_type_hint=refresh_token&token=${oauth.refresh_token}',contentType: 'application/x-www-form-urlencoded');
  }
}

class OauthControllers extends GetxController {
  var oauth = const Oauth();
  var user = const User();
  
  Future<void> login(TokenResponse response) async {
    oauth = Oauth.fromResponse(response);
    user = User.fromString(oauth.id_token!);

    portalnesia.setToken(response);

    await secureStorage.write(key:'oauth', value: oauth.toString());
    await secureStorage.write(key: 'user', value: user.toString());

    update();
  }

  Future<void> load() async {
    var lOauth = await secureStorage.read(key: 'oauth');
    var lUser = await secureStorage.read(key: 'user');
  

    if(lUser != null) user = User.fromString(lUser);
    if(lOauth != null) {
      final temp = Oauth.fromString(lOauth);

      if(temp.isExpired()) {
        return await refreshToken(temp.refresh_token!);
      } else {
        oauth = Oauth.fromString(lOauth);
        portalnesia.setToken(oauth.toTokenResponse()!);
      }
    }

    update();
  }

  Future<void> logout() async {
    try {
      await portalnesia.logout();
    // ignore: empty_catches
    } catch(e) {

    }

    await secureStorage.delete(key: 'oauth');
    await secureStorage.delete(key: 'user');

    oauth = const Oauth();
    user = const User();

    update();
  }

  Future<void> refreshToken(String token) async {
    final TokenResponse? result = await portalnesia.refreshToken(tokens: token);

    if(result == null) return;

    await login(result);
  }
}