import 'package:dubravka/screens/anamnesis/anamnesis_binding.dart';
import 'package:dubravka/screens/anamnesis/anamnesis_screen.dart';
import 'package:dubravka/screens/chat/chat_binding.dart';
import 'package:dubravka/screens/chat/chat_screen.dart';
import 'package:dubravka/screens/account/account_binding.dart';
import 'package:dubravka/screens/account/account_screen.dart';
import 'package:dubravka/screens/home/home_binding.dart';
import 'package:dubravka/screens/home/home_screen.dart';
import 'package:dubravka/screens/profile/profile_binding.dart';
import 'package:dubravka/screens/profile/profile_screen.dart';
import 'package:dubravka/screens/report/report_binding.dart';
import 'package:dubravka/screens/report/report_screen.dart';
import 'package:get/get.dart';

final pages = [
  GetPage(
    name: MyRoutes.accountScreen,
    page: AccountScreen.new,
    binding: AccountBinding(),
  ),
  GetPage(
    name: MyRoutes.anamnesisScreen,
    page: AnamnesisScreen.new,
    binding: AnamnesisBinding(),
  ),
  GetPage(
    name: MyRoutes.homeScreen,
    page: HomeScreen.new,
    binding: HomeBinding(),
  ),
  GetPage(
    name: MyRoutes.chatScreen,
    page: ChatScreen.new,
    binding: ChatBinding(),
  ),
  GetPage(
    name: MyRoutes.reportScreen,
    page: ReportScreen.new,
    binding: ReportBinding(),
  ),
  GetPage(
    name: MyRoutes.profileScreen,
    page: ProfileScreen.new,
    binding: ProfileBinding(),
  ),
];

class MyRoutes {
  static const accountScreen = '/account-screen';
  static const anamnesisScreen = '/anamnesis-screen';
  static const homeScreen = '/home-screen';
  static const chatScreen = '/chat-screen';
  static const reportScreen = '/report-screen';
  static const profileScreen = '/profile-screen';
}
