import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:dubravka/constants/api_key.dart';
import 'package:dubravka/controllers/loading_controller.dart';
import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/data/models/user.dart';
import 'package:dubravka/screens/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final reportScreen = const ReportScreen();
  final UserController userController = Get.find<UserController>();
  final LoadingController loadingController = Get.find<LoadingController>();
  RxString greeting = ''.obs;
  final TextEditingController textEditingController = TextEditingController();
  final apiKey = APIkey().apiKey;
  RxString userReport = 'The report will appear here.'.obs;
  final url = Uri.https("api.openai.com", "/v1/chat/completions");
  final RxList<Message> messages = <Message>[].obs;

  void getReport() async {
    loadingController.showLoadingDialog();
    String firstName = userController.currentUser.value!.firstName;
    String lastName = userController.currentUser.value!.lastName;
    DateTime dob = userController.currentUser.value!.dob;
    String gender = userController.currentUser.value!.gender;

    List<Illness>? illnesses =
        userController.currentUser.value!.illnesses ?? [];

    String allIllnesses = '';

    for (var i = 0; i < illnesses.length; i++) {
      Illness currentIllness = illnesses[i];
      String illnessName = currentIllness.name;
      String illnessDate = currentIllness.time ?? '';
      allIllnesses +=
          'The pacient suffered from $illnessName + " and it was $illnessDate, ';
    }

    Covid? covid = userController.currentUser.value!.covidInfo;
    String? hadCovid = covid!.hadCovid
        ? 'Pacient had COVID-19'
        : 'Pacient did not have COVID-19';
    String? numOfShots =
        'Pacient took ${covid.numOfShots} shots against COVID-19';

    String? diagnosis = userController.currentUser.value!.diagnosis ?? '';
    List<String>? medicines = userController.currentUser.value!.meds;
    List<String>? allergies = userController.currentUser.value!.allergies;
    bool? isSmoker = userController.currentUser.value!.isSmoking;
    String? smoking =
        isSmoker! ? 'Pacient is a smoker.' : 'Pacient is not a smoker.';
    bool? isDrinker = userController.currentUser.value!.isDrinking;
    String? drinking = isDrinker!
        ? 'Pacient drinks alcohol.'
        : 'Pacient does not drink alcohol.';
    String? total =
        '$firstName $lastName, $dob, sex: $gender, $allIllnesses, Diagnosis: $diagnosis, $hadCovid, $numOfShots, List of medicines the pacient takes separated by commas: $medicines . List of pacients allergies separated by commas: $allergies. $smoking, $drinking';

    String? prompt =
        'Assume you are a medical professional and use the data below: \n\n $total.\n\n Write a report with new lines and good formatting, and base your reply on the data provided. Please write academic text, to assist doctors.';

    messages.add(Message(role: 'user', content: prompt));

    try {
      final chatGpt = ChatGpt(apiKey: apiKey);

      final testRequest = ChatCompletionRequest(
          messages: messages,
          model: ChatGptModel.gpt35Turbo.modelName,
          maxTokens: 1000);

      final result = await chatGpt.createChatCompletion(testRequest);

      final savedValue = result!.choices![0].message!.content;

      userReport.value = savedValue;

      messages.add(Message(role: 'assistant', content: savedValue));
    } catch (exception) {
      Get.snackbar('Error', 'An error has occured.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    messages.removeLast();

    messages.add(Message(role: 'assistant', content: userReport.value));

    loadingController.hideLoadingDialog();
  }
}
