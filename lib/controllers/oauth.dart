import 'package:get/get.dart';
import 'package:sans_order/utils/main.dart';

class OauthControllers extends GetxController {
  var token = const IToken();
  
  Future<void> login(IToken response) async {
    token = response;

    portalnesia.setToken(response);

    await secureStorage.write(key:'token', value: token.toString());
    update();
  }

  Future<void> load() async {
    var lToken = await secureStorage.read(key: 'token');
    if(lToken != null) {
      final temp = IToken.fromString(lToken);
      if(temp.isExpired()) {
        return await refreshToken(temp);
      } else {
        token = temp;
        portalnesia.setToken(temp);
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

    await secureStorage.delete(key: 'token');

    token = const IToken();

    update();
  }

  Future<void> refreshToken(IToken token) async {
    final IToken? result = await portalnesia.refreshToken(token);
    if(result == null) return;
    await login(result);
  }
}