import 'package:dubravka/screens/chat/chat_controller.dart';
import 'package:dubravka/screens/profile/profile_controller.dart';
import 'package:dubravka/screens/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
   final List<Widget> screens = [
    Get.find<ChatController>().chatScreen,
    Get.find<ReportController>().reportScreen,
    Get.find<ProfileController>().profileScreen,
  ];

  final selectedIndex = 0.obs;

  void changeScreen(int index) {
    selectedIndex.value = index;
  }
}