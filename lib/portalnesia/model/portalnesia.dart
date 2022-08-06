// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class PortalnesiaUser {
  int id;
  String name;
  String username;
  String? picture;
  String email;
  String? telephone;

  PortalnesiaUser({
    required this.name,
    required this.id,
    required this.username,
    required this.picture,
    required this.email,
    this.telephone
  });

  static PortalnesiaUser fromMap(Map data) {
    return PortalnesiaUser(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      picture: data['picture'],
      email: data['email'] ?? '',
      telephone: data['telephone']
    );
  }

  static PortalnesiaUser fromString(String jsonString) {
    Map<String,dynamic> data = jsonDecode(jsonString);

    return fromMap(data);
  }

  

  Map toMap() {
    final Map map = {
      "id": id,
      "name": name,
      "username": username,
      "picture": picture,
      "email": email,
      "telephone": telephone
    };
    return map;
  }
}

class Pagination {
  int page;
  int pageSize;
  int pageCount;
  int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total
  });
}

class Meta {
  Pagination pagination;

  Meta(this.pagination);

  static fromMap(Map data) {
    return Meta(
      Pagination(
        page: data['meta']['pagination']['page'],
        pageSize: data['meta']['pagination']['pageSize'],
        pageCount: data['meta']['pagination']['pageCount'],
        total: data['meta']['pagination']['total']
      )
    );
  }
}

enum Method {
  put,
  delete,
  post,
  get
}

class IToken {
  final PortalnesiaUser? user;
  final String? refresh;
  final String? jwt;
  final DateTime? expired;

  const IToken({
    this.user,
    this.refresh,
    this.jwt,
    this.expired
  });

  @override
  String toString() {
    if(jwt != null) {
      Map<String,dynamic> json = {
        'user': user?.toMap(),
        'refresh': refresh,
        'jwt': jwt,
        'expired': expired?.millisecondsSinceEpoch
      };
      return jsonEncode(json);
    }
    return jsonEncode({});
  }

  static IToken fromMap(Map data) {
    return IToken(
      user: data['user'] != null ? PortalnesiaUser.fromMap(data['user']) : null,
      refresh: data['refresh'],
      jwt: data['jwt'],
      expired: data['expired'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['expired'] * 1000) 
    );
  }

  static IToken fromString(String jsonString) {
    Map<String,dynamic> data = jsonDecode(jsonString);
    return IToken.fromMap(data);
  }

  bool isExpired() {
    if(expired != null) {
      if(DateTime.now().isAfter(expired as DateTime)) return true;
    }
    return false;
  }

  bool isLogin() {
    return jwt != null;
  }
}

abstract class PortalnesiaModel<R> {
  R fromMap(Map data);

  PortalnesiaResponseModel<R> toModel(Map data) {
    final dt = fromMap(data['data']);
    final meta = Meta.fromMap(data);

    return PortalnesiaResponseModel<R>(data: dt, meta: meta);
  }

  PortalnesiaPaginationResponseModel<R> toPaginationModel(Map data) {
    List<R> lists = [];

    if(data['data'] is List) {
      for(Map datas in data['data']) {
        lists.add(fromMap(datas));
      }
    }

    return PortalnesiaPaginationResponseModel<R>(
      meta: Meta.fromMap(data),
      data: lists
    );
  }
}

class PortalnesiaResponseModel<R> {
  R data;
  Meta? meta;

  PortalnesiaResponseModel({required this.data,this.meta});
}

class PortalnesiaPaginationResponseModel<R> {
  List<R> data;
  Meta meta;

  PortalnesiaPaginationResponseModel({
    required this.data,
    required this.meta
  });
}

class PortalnesiaResponse<R> {
  Map data;
  PortalnesiaResponse(this.data);

  PortalnesiaResponseModel<R> toModel(PortalnesiaModel<R> model) {
    return model.toModel(data);
  }

  PortalnesiaPaginationResponseModel<R> toPaginationModel(PortalnesiaModel<R> model) {
    return model.toPaginationModel(data);
  }
}