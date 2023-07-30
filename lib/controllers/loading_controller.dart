import 'package:dubravka/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  RxBool isLoading = false.obs;

  void showLoadingDialog() {
    isLoading.value = true;
    Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: MyColors.themeLight,
                ),
                SizedBox(height: 16),
                Text('Loading results...'),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black54);
  }

  // Function to hide the loading dialog
  void hideLoadingDialog() {
    isLoading.value = false;
    Get.back();
  }
}
