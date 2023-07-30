import 'package:get/get.dart';
import 'anamnesis_controller.dart';

class AnamnesisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AnamnesisController.new);
  }
}
