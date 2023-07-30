import 'package:animate_do/animate_do.dart';
import 'package:dubravka/constants/assets.dart';
import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/screens/account/account_controller.dart';
import 'package:dubravka/widgets/textfields/date_time_textfield.dart';
import 'package:dubravka/widgets/textfields/dropdown_textfield.dart';
import 'package:dubravka/widgets/textfields/regular_textfield.dart';
import 'package:dubravka/widgets/buttons/wide_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Obx(
          () => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.unfocusTextfields();
            },
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInLeft(
                                  child: Text(
                                    'Health insights',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 26.sp).copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.dialog(
                              AlertDialog(
                                title: const Text(
                                  'Visit Dubrava Hospital website?',
                                  textAlign: TextAlign.center,
                                ),
                                actionsOverflowDirection:
                                    VerticalDirection.down,
                                actionsOverflowAlignment:
                                    OverflowBarAlignment.center,
                                actions: [
                                  WideButton(
                                    title: 'Visit site',
                                    width: 200.w,
                                    height: 60.h,
                                    onPressed: () {
                                      controller.launchMyUrlOnTap(
                                          endpoint: 'https://www.kbd.hr');
                                      Get.back();
                                    },
                                  ),
                                  SizedBox(
                                    width: 200.w,
                                    height: 60.h,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text(
                                        'Go back',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FadeInRight(
                                child: Image.asset(
                                  MyAssets.appLogo,
                                  height: 60.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FadeInLeft(
                          child: Text(
                            'Please provide your accurate credentials below.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.sp)
                                .copyWith(color: Colors.black54),
                          ),
                        ),
                      ),
                      SizedBox(height: 64.h),
                      FormBuilder(
                        key: controller.formKey.value,
                        child: Column(
                          children: [
                            FadeInLeft(
                              delay: const Duration(milliseconds: 200),
                              child: MyRegularTextfield(
                                focusNode: controller.firstNameFocusNode.value,
                                name: 'firstName',
                                label: 'First name',
                                iconData: Icons.person_outline,
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.maxLength(50),
                                    FormBuilderValidators.match(r'^[a-zA-Z]+$',
                                        errorText: 'Invalid characters.'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            FadeInRight(
                              delay: const Duration(milliseconds: 400),
                              child: MyRegularTextfield(
                                focusNode: controller.lastNameFocusNode.value,
                                name: 'lastName',
                                label: 'Last name',
                                iconData: Icons.person_outline,
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.maxLength(50),
                                    FormBuilderValidators.match(r'^[a-zA-Z]+$',
                                        errorText: 'Invalid characters.a'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: FadeInLeft(
                                    delay: const Duration(milliseconds: 600),
                                    child: MyDateTimeTextfield(
                                      name: 'dob',
                                      label: 'Date of birth',
                                      inputType: InputType.date,
                                      focusNode: controller.dobFocusNode.value,
                                      validator:
                                          FormBuilderValidators.required(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.h),
                                Expanded(
                                  child: FadeInRight(
                                    delay: const Duration(milliseconds: 600),
                                    child: MyDropdownTextfield(
                                      label: 'Gender',
                                      onChanged: () => {},
                                      validator:
                                          FormBuilderValidators.required(),
                                      focusNode: controller.sexFocusNode.value,
                                      items: [
                                        DropdownMenuItem(
                                            value: 'male',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.male_outlined,
                                                    color: MyColors.themeLight),
                                                SizedBox(width: 8.h),
                                                const Text(
                                                  'Male',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )),
                                        DropdownMenuItem(
                                            value: 'female',
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.female_outlined,
                                                    color: MyColors.themeLight),
                                                SizedBox(width: 8.h),
                                                const Text(
                                                  'Female',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )),
                                        DropdownMenuItem(
                                            value: 'other',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.not_interested,
                                                    color: MyColors.themeLight),
                                                SizedBox(
                                                    width: 8
                                                        .h), // Optional spacing between the icon and text
                                                const Text(
                                                  'Other',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ))
                                      ],
                                      name: 'gender',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      BounceInUp(
                        delay: const Duration(milliseconds: 800),
                        child: WideButton(
                          height: 60.h,
                          width: double.maxFinite,
                          title: 'Continue',
                          onPressed: () {
                            controller.saveInitialUserData();
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ZoomIn(
                        delay: const Duration(milliseconds: 800),
                        child: RichText(
                          text: TextSpan(
                            text: 'By submitting your info you agree to our ',
                            style: const TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                  text: 'privacy policy.',
                                  style: const TextStyle(
                                      color: MyColors.linkColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      controller.launchMyUrlOnTap(
                                          endpoint:
                                              'https://www.termsfeed.com/live/7d3dea82-1781-4d0e-86ce-b38a33f1e3cf');
                                    }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

typedef CustomValidator = String? Function(dynamic);

CustomValidator requiredValidator(String errorMessage) {
  return (value) {
    if (value == null || value.toString().isEmpty) {
      return errorMessage;
    }
    return null;
  };
}
