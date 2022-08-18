
import 'package:sans_order/portalnesia/model/portalnesia.dart';

class IOutletUserRoles {
  int id;
  String name;
  String? description;

  IOutletUserRoles({required this.id,required this.name,this.description});

  static IOutletUserRoles fromMap(Map data) {
    return IOutletUserRoles(id: data['id'], name: data['name'], description: data['description']);
  }
}

class IOutletUser {
  int id;
  bool pending;
  List<IOutletUserRoles> roles;
  PortalnesiaUser user;

  IOutletUser({
    required this.id,
    required this.pending,
    required this.roles,
    required this.user
  });

  static IOutletUser fromMap(Map data) {
    List<IOutletUserRoles> lists = [];
    for(Map datas in data['roles']) {
      lists.add(IOutletUserRoles.fromMap(datas));
    }
    return IOutletUser(id: data['id'], pending: data['pending'], roles: lists, user: PortalnesiaUser.fromMap(data['user']));
  }

  static List<IOutletUser> arrayMap(Map data) {
    List<IOutletUser> lists = [];
    if(data['users'] is List) {
      for(Map datas in data['users']) {
        lists.add(fromMap(datas));
      }
    }

    return lists;
  }
}