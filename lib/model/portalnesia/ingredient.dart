import 'package:sans_order/model/portalnesia/outlet.dart';

class IIngredient {
  int id;
  String name;
  String? description;
  String unit;
  int? stock;
  IOutlet? outlet;

  IIngredient({
    this.description,
    required this.id,
    required this.name,
    this.stock,
    required this.unit,
    this.outlet
  });

  static IIngredient fromMap(Map data) {
    return IIngredient(
      id: data['id'],
      name: data['name'],
      unit: data['unit'],
      description: data['description'],
      stock: data['stock'],
      outlet: data['outlet'] is Map ? IOutlet.fromMap(data['outlet']) : null
    );
  }
}