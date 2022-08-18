// ignore_for_file: non_constant_identifier_names

import 'package:sans_order/model/portalnesia/file.dart';
import 'package:sans_order/model/portalnesia/ingredient.dart';
import 'package:sans_order/model/portalnesia/promo.dart';

class IRecipes {
  int id;
  int consume;
  IIngredient item;

  IRecipes({required this.id,required this.consume,required this.item});

  static IRecipes fromMap(Map data) {
    return IRecipes(
      id: data['id'],
      consume: data['consume'],
      item: IIngredient.fromMap(data['item'])
    );
  }

  static List<IRecipes> arrayMap(Map data) {
    List<IRecipes> lists = [];
    if(data['recipes'] is List) {
      for(Map datas in data['recipes']) {
        lists.add(fromMap(datas));
      }
    }
    return lists;
  }
}

class IProducts {
  int id;
  String name;
  String? description;
  int price;
  int? hpp;
  IFile? image;
  bool active;
  String? category;
  bool show_in_menu;
  bool block;
  dynamic metadata;
  List<IRecipes> recipes;
  IPromo? promo;

  IProducts({
    required this.active,
    required this.block,
    this.category,
    this.description,
    this.hpp,
    required this.id,
    this.image,
    this.metadata,
    required this.name,
    required this.price,
    this.promo,
    required this.recipes,
    required this.show_in_menu
  });

  static IProducts fromMap(Map data) {
    return IProducts(
      active: data['active'],
      block: data['block'],
      category: data['category'],
      description: data['description'],
      hpp: data['hpp'],
      id: data['id'],
      image: data['image'] is Map ? IFile.fromMap(data['image']) : null,
      metadata: data['metadata'],
      name: data['name'],
      price: data['price'],
      promo: data['promo'] is Map ? IPromo.fromMap(data['promo']) : null,
      recipes: IRecipes.arrayMap(data),
      show_in_menu: data['show_in_menu']
    );
  }

  static List<IProducts> arrayMap(Map data) {
    List<IProducts> lists = [];
    if(data['products'] is List) {
      for(Map datas in data['products']) {
        lists.add(fromMap(datas));
      }
    }
    return lists;
  }
}