import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class DeviceInfoService extends GetxService {
  late final deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iOSInfo;
  WebBrowserInfo? webBrowserInfo;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initProperInfo();
  }

  Future<void> initProperInfo() async {
    if (GetPlatform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    }
    if (GetPlatform.isIOS) {
      iOSInfo = await deviceInfo.iosInfo;
    }
    if (GetPlatform.isWeb) {
      webBrowserInfo = await deviceInfo.webBrowserInfo;
    }
  }
}
