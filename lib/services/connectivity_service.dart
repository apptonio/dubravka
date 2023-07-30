import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dubravka/utils/snackbars.dart';
import 'package:get/get.dart';

class ConnectivityService {
  static ConnectivityResult? connectionState;

  dynamic checkConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      connectionState = ConnectivityResult.none;
      MySnackbars.showErrorSnackbar(message: 'noInternet'.tr);
    }
  }

  static void connectivityListen() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        connectionState = result;
        MySnackbars.showErrorSnackbar(message: 'noInternet'.tr);
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile &&
              connectionState == ConnectivityResult.none) {
        connectionState = result;
        Get.closeCurrentSnackbar();
      }
    });
  }
}
