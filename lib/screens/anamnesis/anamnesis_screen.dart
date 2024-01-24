import 'package:animate_do/animate_do.dart';
import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/constants/text_styles.dart';
import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/screens/anamnesis/anamnesis_controller.dart';
import 'package:dubravka/widgets/buttons/wide_button.dart';
import 'package:dubravka/widgets/textfields/dropdown_textfield.dart';
import 'package:dubravka/widgets/textfields/regular_textfield.dart';
import 'package:dubravka/widgets/textfields/single_checkbox_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AnamnesisScreen extends GetView<AnamnesisController> {
  const AnamnesisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return Scaffold(
      body: Obx(
        () => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BounceInDown(
                              delay: const Duration(milliseconds: 200),
                              child: Text(
                                'Your medical history',
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
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BounceInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'Please provide & review the remaining information below.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18.sp)
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black.withOpacity(0.06),
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: FormBuilder(
                        key: controller.formKey.value,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              children: [
                                FadeInLeft(
                                  child: Text(
                                    'Medical history',
                                    style: MyTextStyles.medium
                                        .copyWith(fontSize: 22.sp),
                                  ),
                                ),
                                const Spacer(),
                                FadeInRight(
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.themeLight,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: MyColors.white,
                                      ),
                                      onPressed: () {
                                        controller.addIllness();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Visibility(
                              visible: controller.illnesses.isNotEmpty,
                              child: FadeIn(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColors.themeLight, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: SizedBox(
                                    height: 200.h,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (int i = 0;
                                                i < controller.illnesses.length;
                                                i++) ...[_buildIllnessField(i)]
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                FadeInLeft(
                                  child: Text(
                                    'Diagnosis',
                                    style: MyTextStyles.medium
                                        .copyWith(fontSize: 22.sp),
                                  ),
                                ),
                                const Spacer(),
                                FadeInRight(
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.themeLight,
                                    child: IconButton(
                                      icon: Icon(
                                        controller.familyMoreInfo.value
                                            ? Icons.arrow_drop_up_outlined
                                            : Icons.arrow_drop_down_outlined,
                                        color: MyColors.white,
                                      ),
                                      onPressed: () {
                                        controller.familyMoreInfo.value =
                                            !controller.familyMoreInfo.value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            if (controller.familyMoreInfo.value) ...[
                              FadeIn(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Please provide your diagnosis.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14.sp)
                                        .copyWith(color: Colors.black54),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              FadeIn(
                                child: MyRegularTextfield(
                                  initialValue: userController
                                      .potentialDiagnosis.value,
                                  focusNode:
                                      controller.diagnosisFocusNode.value,
                                  name: 'diagnosis',
                                  label: 'Diagnosis',
                                  iconData: Icons.medical_information,
                                  validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.maxLength(200)],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                FadeInLeft(
                                  child: Text(
                                    'Covid info',
                                    style: MyTextStyles.medium
                                        .copyWith(fontSize: 22.sp),
                                  ),
                                ),
                                const Spacer(),
                                FadeInRight(
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.themeLight,
                                    child: IconButton(
                                      icon: Icon(
                                        controller.covidMoreInfo.value
                                            ? Icons.arrow_drop_up_outlined
                                            : Icons.arrow_drop_down_outlined,
                                        color: MyColors.white,
                                      ),
                                      onPressed: () {
                                        controller.covidMoreInfo.value =
                                            !controller.covidMoreInfo.value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Visibility(
                              visible: controller.covidMoreInfo.value,
                              child: FadeIn(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: SingleCheckboxField(
                                      focusNode:
                                          controller.hadCovidFocusNode.value,
                                      name: 'hadCovid',
                                      label: 'I had COVID-19',
                                      initialValue:
                                          userController.potentialCovid.value,
                                    )),
                                    Expanded(
                                      child: MyDropdownTextfield(
                                        initialValue:
                                            userController.potentialShots.value,
                                        focusNode: controller
                                            .vaccinationsFocusNode.value,
                                        items: const [
                                          DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: '3',
                                            child: Text('Three (3)'),
                                          ),
                                          DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: '2',
                                            child: Text('Two (2)'),
                                          ),
                                          DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: '1',
                                            child: Text('One (1)'),
                                          ),
                                          DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: '0',
                                            child: Text('Zero (0)'),
                                          ),
                                        ],
                                        name: 'numOfShots',
                                        label: 'Vaccinations',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                FadeInLeft(
                                  child: Text(
                                    'Current medication',
                                    style: MyTextStyles.medium
                                        .copyWith(fontSize: 22.sp),
                                  ),
                                ),
                                const Spacer(),
                                FadeInRight(
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.themeLight,
                                    child: IconButton(
                                      icon: Icon(
                                        controller.medicinesMoreInfo.value
                                            ? Icons.arrow_drop_up_outlined
                                            : Icons.arrow_drop_down_outlined,
                                        color: MyColors.white,
                                      ),
                                      onPressed: () {
                                        controller.medicinesMoreInfo.value =
                                            !controller.medicinesMoreInfo.value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            if (controller.medicinesMoreInfo.value) ...[
                              FadeIn(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Please provide the names of your perscribed drugs, separated by commas.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14.sp)
                                        .copyWith(color: Colors.black54),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              FadeIn(
                                child: MyRegularTextfield(
                                  initialValue:
                                      userController.potentialMedicines.value,
                                  focusNode:
                                      controller.medicinesFocusNode.value,
                                  name: 'medicines',
                                  label: 'Drugs (Ibuprofen, Amlodipin, ...)',
                                  iconData: Icons.medication_outlined,
                                  validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.maxLength(100)],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                FadeInLeft(
                                  child: Text(
                                    'Medicine allergies',
                                    style: MyTextStyles.medium
                                        .copyWith(fontSize: 22.sp),
                                  ),
                                ),
                                const Spacer(),
                                FadeInRight(
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.themeLight,
                                    child: IconButton(
                                      icon: Icon(
                                        controller.allergiesMoreInfo.value
                                            ? Icons.arrow_drop_up_outlined
                                            : Icons.arrow_drop_down_outlined,
                                        color: MyColors.white,
                                      ),
                                      onPressed: () {
                                        controller.allergiesMoreInfo.value =
                                            !controller.allergiesMoreInfo.value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            if (controller.allergiesMoreInfo.value) ...[
                              FadeIn(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Please provide your medicinal allergies, separated by commas.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14.sp)
                                        .copyWith(color: Colors.black54),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              FadeIn(
                                child: MyRegularTextfield(
                                  initialValue:
                                      userController.potentialAllergies.value,
                                  focusNode:
                                      controller.allergiesFocusNode.value,
                                  name: 'allergies',
                                  label: 'Allergies (Penicillin, Sulfa, ...)',
                                  iconData: Icons.sick_outlined,
                                  validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.maxLength(100)],
                                  ),
                                ),
                              ),
                            ],
                            FadeInLeft(
                                child: SingleCheckboxField(
                              focusNode: controller.smokingFocusNode.value,
                              name: 'smoking',
                              label: 'I smoke tobacco.',
                              initialValue:
                                  userController.potentialSmoker.value,
                            )),
                            FadeInLeft(
                                child: SingleCheckboxField(
                              focusNode: controller.drinkingFocusNode.value,
                              name: 'drinking',
                              label: 'I drink alcohol.',
                              initialValue:
                                  userController.potentialDrinker.value,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black.withOpacity(0.06),
                        offset: const Offset(0, -6),
                        spreadRadius: 2,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BounceInUp(
                      child: WideButton(
                        height: 60.h,
                        width: double.maxFinite,
                        title: 'Continue',
                        onPressed: () {
                          controller.saveAdditionalUserInfo();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildIllnessField(int index) {
  AnamnesisController controller = Get.put(AnamnesisController());
  return FadeIn(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyRegularTextfield(
              onChanged: (p0) => controller.illnesses[index].name = p0!,
              name: 'name$index',
              label: 'Illness',
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(50),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '-',
            style: const TextStyle(fontSize: 30)
                .copyWith(color: MyColors.themeLight),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: MyDropdownTextfield(
              onChanged: (p0) => controller.illnesses[index].time = p0 ?? '',
              focusNode: FocusNode(),
              items: const [
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Within a year',
                  child: Text('Within a year'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Within 5 years',
                  child: Text('Within 5 years'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Over 5 years ago',
                  child: Text('Over 5 years ago'),
                ),
              ],
              name: 'time$index',
              label: 'Time',
            ),

            // MyDateTimeTextfield(
            //   //controller: TextEditingController(text: controller.illnesses[index].date),
            //   onChanged: (p0) =>
            //       controller.illnesses[index].date = p0 ?? DateTime.now(),
            //   name: 'date$index',
            //   label: 'Year',
            //   inputType: InputType.date,
            // ),
          ),
          IconButton(
            onPressed: () {
              controller.removeIllness(index);
            },
            icon: const Icon(
              Icons.delete,
              color: MyColors.themeLight,
            ),
          ),
        ],
      ),
    ),
  );
}
