import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dubravka/constants/api_key.dart';
import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/constants/pages.dart';
import 'package:dubravka/controllers/loading_controller.dart';
import 'package:dubravka/controllers/user_controller.dart';
// import 'package:dubravka/screens/amnesis/amnesis_controller.dart';
import 'package:dubravka/services/connectivity_service.dart';
import 'package:dubravka/utils/snackbars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:dubravka/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>().obs;
  final firstNameFocusNode = FocusNode().obs;
  final lastNameFocusNode = FocusNode().obs;
  final dobFocusNode = FocusNode().obs;
  final sexFocusNode = FocusNode().obs;
  final raceFocusNode = FocusNode().obs;
  final ImagePicker _picker = ImagePicker();
  final apiKey = APIkey().apiKey;

  String? firstName = '';
  String? lastName = '';
  DateTime dob = DateTime.now();
  String gender = '';
  String race = '';

  final LoadingController loadingController = Get.find<LoadingController>();
  final UserController userController = Get.find<UserController>();

  //AmnesisController amnesisController = Get.put(AmnesisController());

  File? _image;
  final RxString extractedText = ''.obs;
  final RxList<Map<String, dynamic>> potentialMessages =
      <Map<String, dynamic>>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameFocusNode.value.dispose();
    lastNameFocusNode.value.dispose();
    dobFocusNode.value.dispose();
    sexFocusNode.value.dispose();
    raceFocusNode.value.dispose();
  }

  void saveInitialUserData() async {
    final validationCheck = formKey.value.currentState?.validate();
    if (validationCheck != null && validationCheck) {
      firstName = formKey.value.currentState?.fields['firstName']?.value
          .toString()
          .trim()
          .capitalize;

      lastName = formKey.value.currentState?.fields['lastName']?.value
          .toString()
          .trim()
          .capitalize;

      dob = formKey.value.currentState?.fields['dob']?.value;
      gender = formKey.value.currentState?.fields['gender']?.value;
      race = formKey.value.currentState?.fields['race']?.value;

      User user = User(
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        dob: dob,
        gender: gender,
        race: race,
      );

      userController.saveUser(user);
      userController.getUser();

      Get.toNamed(MyRoutes.anamnesisScreen);
      userController.userUsedPhoto.value = false;
      //openAmnesisDialog();
    } else {
      Get.snackbar('Validation error', 'Please check the fields above.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
  }

  void openAmnesisDialog() {
    Get.dialog(
        ZoomIn(
          child: AlertDialog(
            actionsOverflowDirection: VerticalDirection.down,
            actionsOverflowAlignment: OverflowBarAlignment.center,
            title: const Text(
              'Do you have an anamnesis?',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "If available, please provide a photo of your medical history paper or any document provided by your doctor containing your medical information. This will allow us to automatically fill in the data for you.",
              textAlign: TextAlign.center,
            ),
            actionsPadding: EdgeInsets.zero,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 60.h,
                      child: ElevatedButton.icon(
                        label: Text(
                          'Gallery',
                          style: const TextStyle(color: MyColors.white)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: MyColors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.themeLight),
                        onPressed: () {
                          getFromGallery(true);
                          userController.userUsedPhoto.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 60.h,
                      child: ElevatedButton.icon(
                        label: Text(
                          'Camera',
                          style: const TextStyle(color: MyColors.white)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: MyColors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.themeLight),
                        onPressed: () {
                          getFromGallery(false);
                          userController.userUsedPhoto.value = true;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              SizedBox(
                height: 60.h,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(MyRoutes.anamnesisScreen);
                    userController.userUsedPhoto.value = false;
                  },
                  child: const Text(
                    'Enter manually',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black);
  }

  void getFromGallery(bool hasPhoto) async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: hasPhoto ? ImageSource.gallery : ImageSource.camera,
      );

      if (pickedFile != null) {
        Get.back();
        loadingController.showLoadingDialog();
        _image = File(pickedFile.path);
        extractedText.value = '';
        //await _extractTextFromImage();
        loadingController.hideLoadingDialog();
        Get.toNamed(MyRoutes.anamnesisScreen);
      } else {
        pickedFile = null;
      }
    } catch (e) {
      Get.snackbar(e.toString(), e.toString());
    }
  }

  // ignore: unused_element
  Future<void> _extractTextFromImage() async {
    final inputImage = InputImage.fromFile(_image!);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText =
        await textDetector.processImage(inputImage);
    extractedText.value = recognisedText.text.trim();

    potentialMessages.add({
      'role': 'user',
      'content':
          'I will provide you with a patient anamnesis below. Please understand the text and be prepared to answer some questions from the text. \n\n${extractedText.value}', // Add the saved value as a message
    });

    String potentialCovid = await chatGPT(
        'If the patient had COVID-19 reply only "true", otherwise reply "false"');
    if (potentialCovid.contains('true') ||
        potentialCovid.contains('True') ||
        potentialCovid.contains('true.') ||
        potentialCovid.contains('True.')) {
      userController.potentialCovid.value = true;
    }

    String potentialSmoker = await chatGPT(
        'If the patient is a smoker, reply only "true", otherwise reply "false"');
    if (potentialSmoker.contains('true') ||
        potentialSmoker.contains('True') ||
        potentialSmoker.contains('true.') ||
        potentialSmoker.contains('True.')) {
      userController.potentialSmoker.value = true;
    }

    String potentialDrinker = await chatGPT(
        'If the patient is an alcoholic, reply only "true", otherwise reply "false"');
    if (potentialDrinker.contains('true') ||
        potentialDrinker.contains('True') ||
        potentialDrinker.contains('true.') ||
        potentialDrinker.contains('True.')) {
      userController.potentialDrinker.value = true;
    }

    String potentialShots = await chatGPT(
        'From the above text, can you count the number of vaccines or similar that the patient had for COVID-19? If there are any, please return just the number (for example: 2). If not, please return just a 0');

    if (potentialShots.contains('0') ||
        potentialShots.contains('zero') ||
        potentialShots.contains('Zero')) {
      userController.potentialShots.value = '0';
    } else if (potentialShots.contains('1') ||
        potentialShots.contains('one') ||
        potentialShots.contains('One')) {
      userController.potentialShots.value = '1';
    } else if (potentialShots.contains('2') ||
        potentialShots.contains('two') ||
        potentialShots.contains('Two')) {
      userController.potentialShots.value = '2';
    } else if (potentialShots.contains('3') ||
        potentialShots.contains('three') ||
        potentialShots.contains('Three')) {
      userController.potentialShots.value = '3';
    }

    userController.potentialMedicines.value =
        await chatGPT('Return patients medicines separated by commas.');

    userController.potentialAllergies.value = await chatGPT(
        'Return patients medicinal allergies separated by commas.');

    userController.potentialDiagnosis.value =
        await chatGPT('Return patients diagnosis.');
  }

  Future<String> chatGPT(String prompt) async {
    try {
      potentialMessages.add({
        'role': 'user',
        'content': prompt, // Add the saved value as a message
      });
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': potentialMessages,
          'temperature': 1,
        }),
      );

      if (res.statusCode == 200) {
        final responseBody = res.body;
        final decodedResponse =
            jsonDecode(utf8.decode(responseBody.runes.toList()));

        final content = decodedResponse['choices'][0]['message']['content'];

        potentialMessages.add({
          'role': 'assistant',
          'content': content,
        });

        return content;
      } else {
        potentialMessages.add({
          'role': 'assistant',
          'content': 'An internal error occurred.',
        });
        return '';
      }
    } catch (e) {
      potentialMessages.add({
        'role': 'assistant',
        'content': e.toString(),
      });
      return '';
    }
  }

  void unfocusTextfields() {
    firstNameFocusNode.value.unfocus();
    lastNameFocusNode.value.unfocus();
    dobFocusNode.value.unfocus();
    sexFocusNode.value.unfocus();
    raceFocusNode.value.unfocus();
  }

  void launchMyUrlOnTap({required String endpoint}) async {
    if (ConnectivityService.connectionState != ConnectivityResult.none) {
      await launchUrlString(endpoint, mode: LaunchMode.inAppWebView);
    } else {
      MySnackbars.showErrorSnackbar(message: 'Please connect to the internet.');
    }
  }

  // void updateState(List<Country> newState) => change(
  //       newState,
  //       status: newState.isEmpty ? RxStatus.empty() : RxStatus.success(),
  //     );
}
