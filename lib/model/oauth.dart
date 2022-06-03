// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';

class Oauth {
  final String? id_token;
  final String? access_token;
  final String? refresh_token;
  final String? scope;
  final DateTime? expired;

  const Oauth({
    this.access_token,
    this.refresh_token,
    this.scope,
    this.id_token,
    this.expired
  });

  static Oauth fromResponse(TokenResponse response) {
    if(response.accessTokenExpirationDateTime == null ||
      response.accessToken == null ||
      response.refreshToken == null || response.idToken == null) {
        throw 'Invalid json';
    }
    final parts = response.idToken?.split(r'.') as List<String>;

    assert(parts.length == 3);

    final idToken = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));

    DateTime expired = response.accessTokenExpirationDateTime!;

    return Oauth(
      access_token: response.accessToken,
      refresh_token: response.refreshToken,
      id_token: idToken,
      scope: response.scopes?.join(" ") ?? "",
      expired: expired
    );
  }

  static Oauth fromString(String jsonString) {
    Map<String,dynamic> json = jsonDecode(jsonString);
    if(
      !json.containsKey('access_token') ||
      !json.containsKey('refresh_token') ||
      !json.containsKey('expired')
    ) {
      throw 'Invalid json';
    }

    DateTime expired = DateTime.parse(json['expired']);

    return Oauth(
      access_token: json['access_token'],
      refresh_token: json['refresh_token'],
      id_token: json['id_token'],
      scope: json['scope'],
      expired: expired
    );
  }

  @override
  String toString() {
    Map<String,dynamic> json = {
      'access_token': access_token,
      'refresh_token': refresh_token,
      'id_token': id_token,
      'scope': scope,
      'expired': expired.toString()
    };
    return jsonEncode(json);
  }

  bool isExpired() {
    return DateTime.now().isAfter(expired!);
  }

  bool isLogin(bool? withExpired) {
    if(access_token == null || refresh_token == null) return false;
    if(withExpired == true && isExpired()) return false;
    return true;
  }
}