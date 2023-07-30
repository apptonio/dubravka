import 'package:dubravka/data/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final Rxn<User> currentUser = Rxn<User>();
  final RxBool userUsedPhoto = false.obs;

  final RxBool potentialSmoker = false.obs;
  final RxBool potentialDrinker = false.obs;
  final RxString potentialMedicines = ''.obs;
  final RxString potentialAllergies = ''.obs;
  final RxString potentialFamilyIllnesses = ''.obs;
  final RxBool potentialCovid = false.obs;
  final RxString potentialShots = '0'.obs;

  void saveUser(User user) async {
    final box = await Hive.openBox('users');
    await box.put('user', user);
    await box.close();
  }

  Future<User> getUser() async {
    final box = await Hive.openBox('users');
    final user = box.get('user') as User;
    currentUser.value = user;
    printBoxContents(box);
    await box.close();
    return user;
  }

  void printBoxContents(Box box) {
    final keys = box.keys;
    for (var key in keys) {
      final user = box.get(key);
      print(user);
    }
  }
}
