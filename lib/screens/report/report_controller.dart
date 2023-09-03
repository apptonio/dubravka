import 'dart:convert';

import 'package:dubravka/constants/api_key.dart';
import 'package:dubravka/controllers/loading_controller.dart';
import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/data/models/user.dart';
import 'package:dubravka/screens/report/report_screen.dart';
import 'package:dubravka/utils/stream_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {
  final reportScreen = const ReportScreen();
  final UserController userController = Get.find<UserController>();
  final LoadingController loadingController = Get.find<LoadingController>();
  RxString greeting = ''.obs;
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  final apiKey = APIkey().apiKey;
  RxString userReport = 'The report will appear here.'.obs;
  final url = Uri.https("api.openai.com", "/v1/chat/completions");

  void getReport() async {
    // loadingController.showLoadingDialog();
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
      String illnessDate = currentIllness.date.toString();
      allIllnesses +=
          'The pacient suffered from $illnessName + " and it was on $illnessDate, ';
    }

    Covid? covid = userController.currentUser.value!.covidInfo;
    String? hadCovid = covid!.hadCovid
        ? 'Pacient had COVID-19'
        : 'Pacient did not have COVID-19';
    String? numOfShots =
        'Pacient took ${covid.numOfShots} shots against COVID-19';

    List<String>? familyIllnesses =
        userController.currentUser.value!.familyIllnesses;
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
        '$firstName $lastName, $dob, sex: $gender, $allIllnesses, Family illnesses list: $familyIllnesses, $hadCovid, $numOfShots, List of medicines the pacient takes separated by commas: $medicines . List of pacients allergies separated by commas: $allergies. $smoking, $drinking';

    String? prompt =
        'Assume you are a medical professional and use the data below: \n\n $total.\n\n Write a report with new lines and good formatting, and base your reply on the data provided. Please write academic text, to assist doctors.';

    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final stream = sendMessageStream();

      final savedValue = userReport.value; // Save the current value of myVar

      userReport.value = ''; // Clear myVar

      messages.add({
        'role': 'assistant',
        'content': savedValue, // Add the saved value as a message
      });

      await for (final textChunk in stream) {
        userReport.value += textChunk;
      }

      //  print(myVar.value);
    } catch (exception) {
      Get.snackbar('Error', 'An error has occured.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    messages.removeLast();

    messages.add({
      'role': 'assistant',
      'content': userReport.value,
    });

    //await getAssistantReply();

    // loadingController.hideLoadingDialog();
  }

  // Future<void> getAssistantReply() async {
  //   try {
  //     final res = await http.post(
  //       Uri.parse('https://api.openai.com/v1/chat/completions'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $openAIApiKey',
  //       },
  //       body: jsonEncode({
  //         'model': 'gpt-3.5-turbo',
  //         'messages': messages,
  //       }),
  //     );

  //     if (res.statusCode == 200) {
  //       final responseBody = res.body;
  //       final decodedResponse =
  //           jsonDecode(utf8.decode(responseBody.runes.toList()));

  //       final content = decodedResponse['choices'][0]['message']['content'];
  //       userReport.value = content;
  //     } else {
  //       Get.snackbar('Internal error', 'An unknown error has occured.');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Internal error', 'An unknown error has occured.');
  //   }
  // }

  Map<String, String> _getHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey"
    };
  }

  String _getBody() {
    final body = {
      "model": 'gpt-3.5-turbo',
      "temperature": 1,
      "messages": messages,
      "stream": true
    };
    return jsonEncode(body);
  }

  Stream<String> sendMessageStream() async* {
    final request = http.Request("POST", url)..headers.addAll(_getHeaders());
    request.body = _getBody();

    final response = await StreamClient.instance.send(request);
    final statusCode = response.statusCode;
    final byteStream = response.stream;

    if (!(statusCode >= 200 && statusCode < 300)) {
      var error = "";
      await for (final byte in byteStream) {
        final decoded = utf8.decode(byte).trim();
        final map = jsonDecode(decoded) as Map;
        final errorMessage = map["error"]["message"] as String;
        error += errorMessage;
      }
      throw Exception(
          "($statusCode) ${error.isEmpty ? "Bad Response" : error}");
    }

    await for (final byte in byteStream) {
      var decoded = utf8.decode(byte);
      final strings = decoded.split("data: ");
      for (final string in strings) {
        final trimmedString = string.trim();
        if (trimmedString.isNotEmpty && !trimmedString.endsWith("[DONE]")) {
          final map = jsonDecode(trimmedString) as Map;
          final choices = map["choices"] as List;
          final delta = choices[0]["delta"] as Map;
          if (delta["content"] != null) {
            final content = delta["content"] as String;

            yield content;
          }
        }
      }
    }
  }
}
