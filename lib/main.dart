import 'package:dubravka/constants/localization.dart';
import 'package:dubravka/constants/pages.dart';
import 'package:dubravka/constants/theme.dart';
import 'package:dubravka/controllers/loading_controller.dart';
import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/data/hive/user_adapter.dart';
import 'package:dubravka/services/app_lifecycle_service.dart';
import 'package:dubravka/services/connectivity_service.dart';
import 'package:dubravka/services/device_info_service.dart';
// import 'package:dubravka/services/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.deleteBoxFromDisk('users');
  await Hive.openBox('users');

  runApp(MyApp());
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put(AppLifecycleService())
      ..put(DeviceInfoService())
      //..put(DioService())
      ..put(ConnectivityService());
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LoadingController loadingController = Get.put(LoadingController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        builder: (_, __) => GetMaterialApp(
          onGenerateTitle: (_) => 'appName'.tr,
          initialRoute: MyRoutes.accountScreen,
          initialBinding: InitialBinding(),
          theme: theme,
          getPages: pages,
          debugShowCheckedModeBanner: false,
          locale: Localization.locale,
          fallbackLocale: Localization.fallbackLocale,
          translations: Localization(),
        ),
      );
}
