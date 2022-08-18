import 'package:sans_order/portalnesia/model/portalnesia.dart';

class IFile {
  int id;
  String url;

  IFile({
    required this.id,
    required this.url
  });

  static IFile fromMap(Map data) {
    return IFile(
      id: data['id'],
      url: data['url']
    );
  }
}

class FileModel extends PortalnesiaModel<IFile> {
  @override
  IFile fromMap(Map data) {
    return IFile.fromMap(data);
  }
}