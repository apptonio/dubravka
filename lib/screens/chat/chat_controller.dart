import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:dubravka/constants/api_key.dart';
import 'package:dubravka/controllers/loading_controller.dart';
import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/data/models/user.dart';
import 'package:dubravka/screens/chat/chat_screen.dart';
import 'package:dubravka/utils/stream_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatController extends GetxController {
  final chatScreen = const ChatScreen();
  final UserController userController = Get.find<UserController>();
  final LoadingController loadingController = Get.find<LoadingController>();
  RxString greeting = ''.obs;
  Rxn<User> user = Rxn<User>();
  final TextEditingController textEditingController = TextEditingController();
  final apiKey = APIkey().apiKey;
  final url = Uri.https("api.openai.com", "/v1/chat/completions");
  RxString myVar = ''.obs;
  final RxList<Message> messages = <Message>[].obs;

  late ScrollController scrollController;

  @override
  void onInit() async {
    user.value = userController.currentUser.value;
    scrollController = ScrollController();
    getGreeting();

    await getUserData();

    messages.add(Message(
        role: 'assistant',
        content:
            'Hi! In case you have any questions regarding diet, therapy or your disease, following your doctors appointment, feel free to ask. Please keep in mind that I am just an assistant, and not a replacement for doctor consultations.'));
    //'Pozdrav! Ukoliko imate popratna pitanja nakon pregleda liječnika koja su vezana za prehranu, terapiju ili vašu bolest, slobodno me pitajte. Imajte na umu da sam ja samo pomoćnik, a ne zamjena za konzultacije s liječnikom.'

    super.onInit();
  }

  Future<void> getUserData() async {
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
      String illnessDate = currentIllness.time ?? 'not stated how long.';
      allIllnesses +=
          'Pacient suffers from $illnessName + " and it was $illnessDate, ';
    }

    Covid? covid = userController.currentUser.value!.covidInfo;
    String? hadCovid = covid!.hadCovid
        ? 'Patient had COVID-19'
        : 'Patient did not have COVID-19';
    String? numOfShots =
        'Pacient has received ${covid.numOfShots} COVID-19 shots';

    String? diagnosis = userController.currentUser.value!.diagnosis ?? '';
    List<String>? medicines = userController.currentUser.value!.meds;
    List<String>? allergies = userController.currentUser.value!.allergies;
    bool? isSmoker = userController.currentUser.value!.isSmoking;
    String? smoking =
        isSmoker! ? 'Pacient is a smoker.' : 'Pacijent is not a smoker.';
    bool? isDrinker = userController.currentUser.value!.isDrinking;
    String? drinking = isDrinker!
        ? 'Pacient drinks alcohol.'
        : 'Pacient does not drink alcohol';
    String? total =
        '$firstName $lastName, $dob, sex: $gender, $allIllnesses, diagnosis: $diagnosis, $hadCovid, $numOfShots, List of prescribed drugs the patient takes: $medicines . List of allergies the patient has: $allergies. $smoking, $drinking';

    String? prompt =
        'Assume that you are a virtual medical assistant, and use the this pacient data: \n\n $total.\n\n Use this data to concisely answer the pacients questions to the best of your ability, taking into account the patients medical history and the drugs they are currently using, indicating the potential sideeffects of the drugs they are using. In your reply, make a reference to this patient data.';

    messages.add(Message(role: 'assistant', content: prompt));
  }

  void getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      greeting.value = 'Good morning';
    } else if (hour < 18) {
      greeting.value = 'Good afternoon';
    } else {
      greeting.value = 'Good evening';
    }
  }

  void sendMessage() async {
    final prompt = textEditingController.text.trim();
    if (prompt == '') {
      Get.snackbar('No text', 'Please enter more text.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    textEditingController.clear();

    loadingController.showLoadingDialog();

    messages.add(Message(role: 'user', content: prompt));

    scrollToBottom();

    try {
      final chatGpt = ChatGpt(apiKey: apiKey);

      final testRequest = ChatCompletionRequest(
          messages: messages,
          model: ChatGptModel.gpt35Turbo.modelName,
          maxTokens: 1000);

      final result = await chatGpt.createChatCompletion(testRequest);

      myVar.value = result!.choices![0].message!.content;

      final savedValue = myVar.value;

      messages.add(Message(role: 'assistant', content: savedValue));
    } catch (exception) {
      Get.snackbar('Error', 'An error has occured.',
          snackPosition: SnackPosition.BOTTOM);
      loadingController.hideLoadingDialog();
      return;
    }

    loadingController.hideLoadingDialog();

    messages.removeLast();
    messages.add(Message(role: 'assistant', content: myVar.value));

    scrollToBottom();
  }

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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
