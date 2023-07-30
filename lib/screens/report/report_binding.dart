import 'package:dubravka/screens/report/report_controller.dart';
import 'package:get/get.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ReportController.new);
  }
}
