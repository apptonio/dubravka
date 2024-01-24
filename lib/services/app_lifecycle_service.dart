import 'package:get/get.dart';

class AppLifecycleService extends FullLifeCycleController
    with FullLifeCycleMixin {
  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
  
  @override
  void onHidden() {
  }
}
