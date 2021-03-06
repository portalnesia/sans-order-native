
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Version extends StatefulWidget {
  const Version({Key? key}) : super(key: key);

  @override
  State<Version> createState() => _VersionState();
}

class _VersionState extends State<Version> {
  Future<String> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getVersion(),
      builder: (_,version) {
        return Text(version.hasData ? 'v${version.data}' : '',style: const TextStyle(fontSize: 15));
      }
    );
  }
}