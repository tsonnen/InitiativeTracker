import 'package:package_info/package_info.dart';

class AppInfo {
  static PackageInfo _packageInfo;
  static String get version => _packageInfo?.version ?? 'TESTING';

  static void getAppInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }
}
