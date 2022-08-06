import 'package:sans_order/model/portalnesia/file.dart';
import 'package:sans_order/model/portalnesia/outlet.dart';
import 'package:sans_order/model/portalnesia/product.dart';

class IPromo {
  int id;
  String name;
  String? description;
  IFile? image;
  DateTime from;
  DateTime to;
  bool active;
  String type;
  int amount;
  IOutlet? outlet;
  List<IProducts>? products;

  IPromo({
    required this.active,
    required this.amount,
    this.description,
    required this.from,
    required this.id,
    this.image,
    required this.name,
    this.outlet,
    required this.to,
    required this.type,
    this.products
  });

  static IPromo fromMap(Map data) {
    return IPromo(
      active: data['active'],
      amount: data['amount'],
      description: data['description'],
      from: DateTime.parse(data['from']),
      id: data['id'],
      image: data['image']['id'] is int ? IFile.fromMap(data['image']) : null,
      name: data['name'],
      outlet: data['outlet']['id'] is int ? IOutlet.fromMap(data['outlet']) : null,
      to: DateTime.parse(data['to']),
      type: data['type'],
      products: IProducts.arrayMap(data)
    );
  }
}