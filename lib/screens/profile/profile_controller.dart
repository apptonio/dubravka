import 'dart:io';
import 'dart:typed_data';

import 'package:dubravka/controllers/user_controller.dart';
import 'package:dubravka/data/models/user.dart';
import 'package:dubravka/screens/profile/profile_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final profileScreen = const ProfileScreen();
  final UserController userController = Get.find<UserController>();
  Rxn<User> user = Rxn<User>();
  Rxn<Uint8List> userImage = Rxn<Uint8List>();

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() async {
    user.value = userController.currentUser.value;
    super.onInit();
  }

  void pickImage() async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes(); // Read image bytes from the file

      userImage.value = imageBytes;
      } else {
        pickedFile = null;
      }
    } catch (e) {
      Get.snackbar(e.toString(), e.toString());
    }
  }
}
