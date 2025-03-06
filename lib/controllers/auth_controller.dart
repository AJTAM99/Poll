import 'package:get/get.dart';
import 'package:poll_booth/controllers/poll_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var username = "".obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString("username");

    if (storedUsername != null && storedUsername.isNotEmpty) {
      username.value = storedUsername;
      Get.offAllNamed('/home'); // Redirect to Polls Screen
    }
  }

  void login(String user) async {
    if (user.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", user);
      username.value = user;
      Get.offAllNamed('/home'); // Redirect to Polls Screen
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("username");

    Get.find<PollController>().resetVotedPolls();

    username.value = "";
    Get.offAllNamed('/login');
  }
}
