import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/constants/text_styles.dart';
import 'package:dubravka/screens/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.themeDark.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 80.h),
                  Center(
                    child: Obx(
                      () => Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          BounceInDown(
                            child: IconButton(
                              onPressed: () => controller.pickImage(),
                              padding: EdgeInsets.zero,
                              icon: CircleAvatar(
                                radius: 50.r,
                                child: ClipOval(
                                  child: controller.userImage.value == null
                                      ? const Icon(
                                          Icons.person_outline,
                                          color: MyColors.white,
                                          size: 50,
                                        )
                                      : Image.memory(
                                          controller.userImage.value!,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          BounceInDown(
                            delay: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () => controller.pickImage(),
                              child: const CircleAvatar(
                                radius: 15,
                                backgroundColor: MyColors.linkColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: BounceInDown(
                      delay: const Duration(milliseconds: 600),
                      child: Text(
                        '${controller.user.value!.firstName} ${controller.user.value!.lastName}',
                        style: MyTextStyles.subtitleStyle
                            .copyWith(color: MyColors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Accordion(
              paddingListHorizontal: 20,
              maxOpenSections: 2,
              headerBackgroundColorOpened: Colors.black54,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: [
                AccordionSection(
                  isOpen: true,
                  leftIcon: const Icon(Icons.info, color: Colors.white),
                  headerBackgroundColor: MyColors.linkColor,
                  headerBackgroundColorOpened: MyColors.themeDark,
                  header: Text('General info',
                      style:
                          MyTextStyles.medium.copyWith(color: MyColors.white)),
                  content: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline_outlined,
                          color: MyColors.themeDark,
                        ),
                        title: Text(controller.user.value!.firstName),
                      ),
                      const Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline_outlined,
                          color: MyColors.themeDark,
                        ),
                        title: Text(controller.user.value!.lastName),
                      ),
                      const Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.date_range_outlined,
                          color: MyColors.themeDark,
                        ),
                        title: Text(
                            'Born:  ${DateFormat('MMM dd, yyyy').format(controller.user.value!.dob)}'),
                      ),
                      const Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        leading: Icon(
                          controller.user.value!.gender == 'male'
                              ? Icons.male_outlined
                              : controller.user.value!.gender == 'female'
                                  ? Icons.female_outlined
                                  : Icons.not_interested_outlined,
                          color: MyColors.themeDark,
                        ),
                        title: Text(
                            'Gender:  ${controller.user.value!.gender.capitalize}'),
                      ),
                    ],
                  ),
                  contentHorizontalPadding: 16,
                  contentBorderWidth: 1,
                  // onOpenSection: () => print('onOpenSection ...'),
                  // onCloseSection: () => print('onCloseSection ...'),
                ),
                // AccordionSection(
                //   isOpen: true,
                //   leftIcon: const Icon(Icons.medical_information,
                //       color: Colors.white),
                //   headerBackgroundColor: MyColors.linkColor,
                //   headerBackgroundColorOpened: MyColors.themeDark,
                //   header: Text('Medical info',
                //       style:
                //           MyTextStyles.medium.copyWith(color: MyColors.white)),
                //   content: const Text('Content', style: MyTextStyles.light),
                //   contentHorizontalPadding: 16,
                //   contentBorderWidth: 1,
                //   // onOpenSection: () => print('onOpenSection ...'),
                //   // onCloseSection: () => print('onCloseSection ...'),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
