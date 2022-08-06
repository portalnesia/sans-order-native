// ignore_for_file: constant_identifier_names

import 'package:flutter_appauth/flutter_appauth.dart';

const AUTH_CLIENT_ID = "4976086f-258c-50ed-9243-5d007bcd45fb";
const AUTH_REDIRECT_URI = "com.portalnesia.sansorder.dashboard://login-callback";
const AUTH_ISSUER = "https://portalnesia.com";
const AUTH_SCOPE = ['basic','email','openid'];
const AUTH_DOMAIN = 'https://accounts.portalnesia.com/oauth';

AuthorizationServiceConfiguration serviceConfiguration = const AuthorizationServiceConfiguration(
  authorizationEndpoint: '$AUTH_DOMAIN/authorize',
  tokenEndpoint: '$AUTH_DOMAIN/token',
  endSessionEndpoint: '$AUTH_DOMAIN/revoke'
);