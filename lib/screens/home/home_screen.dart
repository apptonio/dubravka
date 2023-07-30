import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          color: MyColors.themeLight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: GNav(
              tabBackgroundColor: MyColors.themeDark,
              backgroundColor: MyColors.themeLight,
              color: MyColors.white,
              activeColor: MyColors.white,
              padding: const EdgeInsets.all(16),
              gap: 8,
              tabs: const [
                GButton(
                  icon: Icons.chat_outlined,
                  text: 'Chat',
                ),
                GButton(
                  icon: Icons.list_outlined,
                  text: 'Report',
                ),
                GButton(
                  icon: Icons.person_outline_outlined,
                  text: 'Profile',
                ),
              ],
              selectedIndex: controller.selectedIndex.value,
              onTabChange: controller.changeScreen,
            ),
          ),
        ),
      ),
    );
  }
}
