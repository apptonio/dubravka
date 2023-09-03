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
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  final apiKey = APIkey().apiKey;
  final url = Uri.https("api.openai.com", "/v1/chat/completions");
  RxString myVar = ''.obs;

  late ScrollController scrollController;

  @override
  void onInit() async {
    user.value = userController.currentUser.value;
    scrollController = ScrollController();
    getGreeting();

    await getUserData();
    //a

    messages.add({
      'role': 'assistant',
      'content':
          'Hi! In case you have any questions regarding diet, therapy or your disease, following your doctors appointment, feel free to ask. Please keep in mind that I am just an assistant, and not a replacement for doctor consultations.'
      //'Pozdrav! Ukoliko imate popratna pitanja nakon pregleda liječnika koja su vezana za prehranu, terapiju ili vašu bolest, slobodno me pitajte. Imajte na umu da sam ja samo pomoćnik, a ne zamjena za konzultacije s liječnikom.'
    });
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
      String illnessDate = currentIllness.date.toString();
      allIllnesses +=
          'Pacijent boluje od $illnessName + " i dijagnosticirana je $illnessDate, ';
    }

    Covid? covid = userController.currentUser.value!.covidInfo;
    String? hadCovid = covid!.hadCovid
        ? 'Pacijent je prebolio COVID-19'
        : 'Pacijent nije imao COVID-19';
    String? numOfShots =
        'Pacijent je primio ${covid.numOfShots} cjepiva protiv COVID-19';

    List<String>? familyIllnesses =
        userController.currentUser.value!.familyIllnesses;
    List<String>? medicines = userController.currentUser.value!.meds;
    List<String>? allergies = userController.currentUser.value!.allergies;
    bool? isSmoker = userController.currentUser.value!.isSmoking;
    String? smoking = isSmoker! ? 'Pacijent je pušač.' : 'Pacijent je nepušač.';
    bool? isDrinker = userController.currentUser.value!.isDrinking;
    String? drinking =
        isDrinker! ? 'Pacijent pije alkohol' : 'Pacijent ne pije alkohol';
    String? total =
        '$firstName $lastName, $dob, spol: $gender, $allIllnesses, Lista obiteljskih bolesti podjeljenjih zarezom: $familyIllnesses, $hadCovid, $numOfShots, Lista lijekova koje uzima pacijent odvojene zarezom: $medicines . Lista alergija koju pacijent ima odvojene zarezom: $allergies. $smoking, $drinking';

    //String? prompt =
    //  'Predpostavi da si liječnik, te koristi medicinske podatke o pacijentu: \n\n $total.\n\n Koristi ove podatke da sažeto odgovoriš na pitanja pacijenta najbolje što možeš. Odgovore baziraj na danim medicinskim podacima.';

    String? prompt =
        'Assume you are a doctor, and use the this pacient data: \n\n $total.\n\n Use this data to concisely answer the pacients questions to the best of your ability. Base your replies on the provided medical data.';

    messages.add({'role': 'assistant', 'content': prompt});
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

    // loadingController.showLoadingDialog();

    messages.add({
      'role': 'user',
      'content': prompt,
    });

    scrollToBottom();

    try {
      final stream = sendMessageStream();

      final savedValue = myVar.value; // Save the current value of myVar

      myVar.value = ''; // Clear myVar

      messages.add({
        'role': 'assistant',
        'content': savedValue, // Add the saved value as a message
      });

      await for (final textChunk in stream) {
        myVar.value += textChunk;
      }

      print(myVar.value);
    } catch (exception) {
      Get.snackbar('Error', 'An error has occured.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // loadingController.hideLoadingDialog();
    messages.removeLast();
    messages.add({
      'role': 'assistant',
      'content': myVar.value,
    });
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
