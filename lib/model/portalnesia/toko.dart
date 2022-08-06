
import 'package:sans_order/model/portalnesia/wallet.dart';
import 'package:sans_order/portalnesia/model/portalnesia.dart';
import 'package:sans_order/model/portalnesia/file.dart';
//import 'package:sans_order/model/portalnesia/wallet.dart';

class IToko {
  int id;
  String name;
  String? description;
  String slug;
  IFile? logo;
  String? slogan;
  PortalnesiaUser? user;
  IWallet? wallet;

  IToko({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.logo,
    this.slogan,
    this.user,
    this.wallet
  });

  static IToko fromMap(Map data) {
    return IToko(
      id: data['id'],
      name: data['name'],
      slug: data['slug'],
      description: data['description'],
      slogan: data['slogan'],
      user: data['user']['username'] is String ? PortalnesiaUser.fromMap(data['user']) : null,
      logo: data['logo']['url'] is String ? IFile.fromMap(data['logo']) : null,
      wallet: data['wallet']['balance'] is int ? IWallet.fromMap(data['wallet']) : null
    );
  }
}

class TokoModel extends PortalnesiaModel<IToko> {
  @override
  IToko fromMap(Map data) {
    return IToko.fromMap(data);
  }
}