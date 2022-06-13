
import 'package:sans_order/portalnesia/model/portalnesia.dart';

class IToko extends PortalnesiaModel {
  int id;
  String name;
  String? description;
  String slug;
  String? logo;
  String? slogan;
  bool admin = false;
  
  IToko({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.logo,
    this.slogan,
    this.admin = false
  });
}

class TokoModel extends PortalnesiaPaginationResponse<IToko> {
  @override
  IToko dataMap(Map data) {
    return IToko(
      id: data['id'],
      name: data['name'],
      slug: data['slug'],
      description: data['description'],
      logo: data['logo'],
      slogan: data['slogan'],
      admin: data['admin']
    );
  }
}