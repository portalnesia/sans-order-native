import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:sans_order/portalnesia/portalnesia_exception.dart';
import 'model/portalnesia.dart';

class Portalnesia {
  final String clientId;
  final List<String> scopes;
  final String redirectUri;
  late Dio _dioApi;
  IToken? _token;
  final String _accountsUrl = 'https://accounts.portalnesia.com/oauth';
  final String _issuerUrl = 'https://portalnesia.com';
  final String apiUrl;
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  Portalnesia(this.apiUrl,this.clientId,this.redirectUri,{
    this.scopes = const [''],
    Map<String, String>? headers,
    String version = '1',
  }) {
    if(headers == null) {
      headers = {'PN-Client-Id': clientId};
    } else {
      headers.addAll({'PN-Client-Id': clientId});
    }
    // ignore: prefer_initializing_formals
    _dioApi = Dio(
      BaseOptions(
        baseUrl: '$apiUrl/api',
        headers: headers,
        receiveDataWhenStatusError: true
      )
    );
  }

  Dio get apiInstance => _dioApi;

  void setToken(IToken token) {
    _token = token;
  }

  Future<PortalnesiaResponse<R>> request<R>(Method method,String path,{dynamic data,Options? options}) async {
    Map<String,dynamic>? headers = {};
    
    var appToken = await FirebaseAppCheck.instance.getToken();
    if(appToken != null) headers['X-App-Token'] = appToken;
    if(_token != null) {
      headers['Authorization'] = 'Bearer ${_token?.jwt}';
    }

    final Options opt = options != null ? options.copyWith(headers: headers,method: method.name.toUpperCase()) : Options(headers: headers,method: method.name.toUpperCase());
    try {
      final Response<Map> response = await _dioApi.request(path,data: data,options: opt);
      
      if(response.data?.containsKey('error') == true && (response.data?['error'] is Map)) {
        return Future.error(PortalnesiaException(response.data));
      }
      final resp = PortalnesiaResponse<R>(response.data ?? {});
      return resp;
    } on DioError catch(e) {
      if (kDebugMode) {
        print(e.requestOptions.uri);
        print(e.response?.data);
      }
      if(e.response?.data != null) {
        return Future.error(PortalnesiaException(e.response!.data));
      } else {
        return Future.error(PortalnesiaException(null));
      }
    }
  }

  AuthorizationServiceConfiguration get appAuthServerConfiguration => AuthorizationServiceConfiguration(
    authorizationEndpoint: '$_accountsUrl/authorize',
    tokenEndpoint: '$_accountsUrl/token'
  );

  Future<AuthorizationTokenResponse?> authorize() async {
    final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(clientId, redirectUri,issuer: _issuerUrl,scopes: scopes,serviceConfiguration: appAuthServerConfiguration)
    );
    return result;
  }

  Future<IToken?> login() async {
    final AuthorizationTokenResponse? result = await authorize();
    if(result == null) return null;

    try {
      final Response<Map> response = await _dioApi.get("/auth/portalnesia/callback",queryParameters: {
        "access_token": result.accessToken,
        "id_token": result.idToken,
        "scopes": result.scopes,
        "token_type": result.tokenType
      });

      if(response.data == null) return null;
      
      final IToken token = IToken.fromMap(response.data!);

      _token = token;

      return token;
    }  on DioError catch(e) {
      if(e.response?.data != null) {
        return Future.error(PortalnesiaException(e.response!.data));
      } else {
        return Future.error(PortalnesiaException(null));
      }
    }
  }

  Future<void> logout() async {
    if(_token != null) {
      _token = null;
    }
  }

  bool isTokenExpired() {
    if(_token != null && _token?.expired is DateTime) {
      return DateTime.now().isAfter(_token?.expired as DateTime);
    }
    return false;
  }

  Future<IToken?> refreshToken(IToken? token) async {
    final finalToken = token ?? _token;

    if(finalToken !=  null) {
      try {
        final Response<Map> response = await _dioApi.post("/auth/refresh",data: {"refresh": token!.refresh});

        if(response.data is Map) {
          _token = IToken.fromMap(response.data!);
          return token;
        }
      }  on DioError catch(e) {
        if (kDebugMode) {
          print(e);
        }
        return null;
      }
    }
    
    return null;
  }
}