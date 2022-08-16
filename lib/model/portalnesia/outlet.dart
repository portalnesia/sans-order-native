// ignore_for_file: non_constant_identifier_names

import 'package:sans_order/model/portalnesia/outlet_users.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/portalnesia/model/portalnesia.dart';

class BusinessHour {
  int id;
  String day;
  DateTime from;
  DateTime to;

  BusinessHour({
    required this.day,
    required this.from,
    required this.id,
    required this.to
  });

  static BusinessHour fromMap(Map data) {
    return BusinessHour(day: data['day'], from: DateTime.parse(data['from']), id: data['id'], to: DateTime.parse(data['to']));
  }

  static List<BusinessHour> arrayMap(Map data) {
    List<BusinessHour> lists = [];
    if(data['business_hour'] is List) {
      for(Map datas in data['business_hour']) {
        lists.add(fromMap(datas));
      }
    }

    return lists;
  }
}

class IOutlet {
  int id;
  String name;
  String? description;
  String? address;
  bool busy;
  bool self_order;
  bool online_payment;
  bool cod;
  bool table_number;
  bool block;
  List<IOutletUser>? users;
  IToko? toko;
  List<BusinessHour>? business_hour;

  IOutlet({
    this.address,
    required this.block,
    this.business_hour,
    required this.busy,
    required this.cod,
    this.description,
    required this.id,
    required this.name,
    required this.online_payment,
    required this.self_order,
    required this.table_number,
    this.toko,
    this.users
  });

  static IOutlet fromMap(Map data) {
    return IOutlet(
      block: data['block'],
      business_hour: BusinessHour.arrayMap(data),
      busy: data['busy'],
      cod: data['cod'],
      id: data['id'],
      name: data['name'],
      online_payment: data['online_payment'],
      self_order: data['self_order'],
      table_number: data['table_number'],
      users: IOutletUser.arrayMap(data),
      address: data['address'],
      description: data['description'],
      toko: data['toko'] is Map ? IToko.fromMap(data['toko']) : null
    );
  }
}

class OutletModel extends PortalnesiaModel<IOutlet> {
  @override
  IOutlet fromMap(Map data) {
    return IOutlet.fromMap(data);
  }

}