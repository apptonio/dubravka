import 'package:dubravka/screens/chat/chat_controller.dart';
import 'package:dubravka/screens/home/home_controller.dart';
import 'package:dubravka/screens/profile/profile_controller.dart';
import 'package:dubravka/screens/report/report_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HomeController.new);
    Get.lazyPut(ChatController.new);
    Get.lazyPut(ReportController.new);
    Get.lazyPut(ProfileController.new);
  }
}
