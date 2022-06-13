import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:sans_order/portalnesia/portalnesia_exception.dart';
import 'model/portalnesia.dart';

class Portalnesia {
  final String clientId;
  final List<String> scopes;
  final String redirectUri;
  late Dio _dioApi;
  late String version;
  late Map<String, String> headers;
  TokenResponse? _token;
  final String _accountsUrl = 'https://accounts.portalnesia.com/oauth';
  final String _issuerUrl = 'https://portalnesia.com';
  final String _apiUrl = 'https://api.portalnesia.com';
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  Portalnesia(this.clientId,this.redirectUri,{
    this.scopes = const [''],
    Map<String, String>? headers,
    String version = '1'
  }) {
    if(headers == null) {
      headers = {'PN-Client-Id': clientId};
    } else {
      headers.addAll({'PN-Client-Id': clientId});
    }
    // ignore: prefer_initializing_formals
    this.headers = headers;
    this.version = '1';
    _dioApi = Dio(
      BaseOptions(
        baseUrl: '$_apiUrl/v$version',
        headers: headers,
        receiveDataWhenStatusError: true
      )
    );
  }

  Dio get apiInstance => _dioApi;

  void setToken(TokenResponse token) {
    _token = token;
  }

  Future<R> request<R extends PortalnesiaModel>(PortalnesiaResponse<R> model, Method method,String path,{dynamic data,Options? options}) async {
    Map<String,dynamic>? headers;
    
    if(_token != null) {
      headers = {
        'Authorization': 'Bearer ${_token?.accessToken}'
      };
    }
    final Options opt = options != null ? options.copyWith(headers: headers,method: method.name.toUpperCase()) : Options(headers: headers,method: method.name.toUpperCase());
    try {
      final Response<Map> response = await _dioApi.request(path,data: data,options: opt);
      
      if(response.data?.containsKey('error') == true && (response.data?['error'] is Map || response.data?['error'] is bool && response.data?['error'] == true)) {
        return Future.error(PortalnesiaException(data: response.data, httpStatus: response.statusCode));
      }
      return model.fromMap(response.data?['data'] ?? {});
    } on DioError catch(e) {
      if(e.response?.data != null) {
        return Future.error(PortalnesiaException(data: e.response!.data,httpStatus: e.response?.statusCode));
      } else {
        return Future.error(PortalnesiaException(data: e.message,httpStatus: e.response?.statusCode));
      }
    }
  }

  AuthorizationServiceConfiguration get appAuthServerConfiguration => AuthorizationServiceConfiguration(
    authorizationEndpoint: '$_accountsUrl/authorize',
    tokenEndpoint: '$_accountsUrl/token'
  );

  Future<AuthorizationTokenResponse?> login() async {
    final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(clientId, redirectUri,issuer: _issuerUrl,scopes: scopes,serviceConfiguration: appAuthServerConfiguration)
    );

    if(result != null) _token = result;
    return result;
  }

  Future<void> logout() async {
    if(_token != null) {
      await Dio().post('$_accountsUrl/revoke',data: {'token_type_hint': 'access_token','token': _token?.accessToken},options: Options(contentType: Headers.formUrlEncodedContentType));
      await Dio().post('$_accountsUrl/revoke',data: {'token_type_hint': 'refresh_token','token': _token?.refreshToken},options: Options(contentType: Headers.formUrlEncodedContentType));
      _token = null;
    }
  }

  bool isTokenExpired() {
    if(_token != null && _token?.accessTokenExpirationDateTime is DateTime) {
      return DateTime.now().isAfter(_token?.accessTokenExpirationDateTime as DateTime);
    }
    return false;
  }

  Future<TokenResponse?> refreshToken({String? tokens}) async {
    final finalToken = tokens ?? _token?.accessToken;

    if(finalToken !=  null) {
      final TokenResponse? result = await appAuth.token(
        TokenRequest(clientId, redirectUri,issuer: _issuerUrl,scopes: scopes,serviceConfiguration: appAuthServerConfiguration,grantType: 'refresh_token',refreshToken: finalToken)
      );

      if(result != null) _token = result;
      return result;
    }
    
    return null;
  }
}