import 'package:animate_do/animate_do.dart';
import 'package:dubravka/constants/pages.dart';
import 'package:dubravka/controllers/loading_controller.dart';
import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/data/models/user.dart';
import 'package:dubravka/widgets/buttons/wide_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AnamnesisController extends GetxController {
  final LoadingController loadingController = Get.find<LoadingController>();
  final UserController userController = Get.find<UserController>();
  Rxn<User> currentUser = Rxn<User>();
  final formKey = GlobalKey<FormBuilderState>().obs;

  final familyIllnessesFocusNode = FocusNode().obs;
  final hadCovidFocusNode = FocusNode().obs;
  final vaccinationsFocusNode = FocusNode().obs;
  final medicinesFocusNode = FocusNode().obs;
  final allergiesFocusNode = FocusNode().obs;
  final smokingFocusNode = FocusNode().obs;
  final drinkingFocusNode = FocusNode().obs;

  RxBool familyMoreInfo = false.obs;
  RxBool covidMoreInfo = false.obs;
  RxBool medicinesMoreInfo = false.obs;
  RxBool allergiesMoreInfo = false.obs;
  RxList<Illness> illnesses = <Illness>[].obs;
  RxList<Illness> familyIllnesses = <Illness>[].obs;

  @override
  void onInit() async {
    currentUser.value = await userController.getUser();

    if (userController.userUsedPhoto.value) {
      openAutofillDialog();
    }
    super.onInit();
  }

  void addIllness() {
    illnesses.add(Illness(name: '', date: DateTime.now()));
  }

  void removeIllness(int index) {
    illnesses.removeAt(index);
  }

  void openAutofillDialog() {
    Get.dialog(
      FadeInRight(
        child: AlertDialog(
          actionsOverflowDirection: VerticalDirection.down,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          title: const Text(
            'Automatically Filling the Form',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "We have attempted to autofill the form on this screen using the photo you provided.\n\nPlease take a moment to review and make any necessary changes.",
            textAlign: TextAlign.center,
          ),
          actions: [
            WideButton(
              title: 'Continue',
              onPressed: () => Get.back(),
              width: double.infinity,
              height: 60.h,
            )
          ],
        ),
      ),
    );
  }

  void saveAdditionalUserInfo() async {
    final validationCheck = formKey.value.currentState?.validate();
    if (validationCheck != null && validationCheck) {
      List<Illness> userIllnesses = [];

      for (int i = 0; i < illnesses.length; i++) {
        Illness illness = Illness(
            name: formKey.value.currentState?.fields['name$i']?.value ?? '',
            date: formKey.value.currentState?.fields['date$i']?.value);
        userIllnesses.add(illness);
      }
      Covid covidInfo = Covid(
          hadCovid:
              formKey.value.currentState?.fields['hadCovid']?.value ?? false,
          numOfShots: int.parse(
              formKey.value.currentState?.fields['numOfShots']?.value ?? '0'));

      List<String> familyIllnesses = (formKey.value.currentState
                  ?.fields['familyIllnesses']?.value as String?)
              ?.split(',')
              .map((e) => e.trim())
              .toList() ??
          [];

      List<String> medicines =
          (formKey.value.currentState?.fields['medicines']?.value as String?)
                  ?.split(',')
                  .map((e) => e.trim())
                  .toList() ??
              [];

      List<String> allergies =
          (formKey.value.currentState?.fields['allergies']?.value as String?)
                  ?.split(',')
                  .map((e) => e.trim())
                  .toList() ??
              [];
      bool isSmoking =
          formKey.value.currentState?.fields['smoking']?.value ?? false;
      bool isDrinking =
          formKey.value.currentState?.fields['drinking']?.value ?? false;

      User user = User(
        firstName: currentUser.value!.firstName,
        lastName: currentUser.value!.lastName,
        dob: currentUser.value!.dob,
        gender: currentUser.value!.gender,
        illnesses: userIllnesses,
        familyIllnesses: familyIllnesses,
        covidInfo: covidInfo,
        meds: medicines,
        allergies: allergies,
        isSmoking: isSmoking,
        isDrinking: isDrinking,
      );

      userController.saveUser(user);
      await userController.getUser();

      Get.offAllNamed(MyRoutes.homeScreen);
    } else {
      Get.snackbar('Validation error', 'Please check the fields above.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
  }
}
