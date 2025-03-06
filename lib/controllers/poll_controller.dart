import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../models/poll.dart';

class PollController extends GetxController {
  var polls = <Poll>[].obs;
  var votedPolls = <String>[].obs;

  final AuthController authController = Get.find();

  @override
  void onInit() {
    loadPolls();
    loadVotedPolls();
    super.onInit();
  }

  void addPoll(Poll poll) {
    polls.add(poll);
    savePolls();
  }

  void loadPolls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedPolls = prefs.getString("polls");

    if (encodedPolls != null && encodedPolls.isNotEmpty) {
      List<dynamic> decodedList = jsonDecode(encodedPolls);
      polls.assignAll(decodedList.map((poll) => Poll.fromJson(poll)).toList());
    }
  }

  void vote(int pollIndex, int optionIndex, String userName) async {
    String pollId = "poll_$pollIndex"; // Unique poll identifier

    if (!votedPolls.contains(pollId)) {
      polls[pollIndex].votes[optionIndex]++;
      votedPolls.add(pollId);
      savePolls();
      saveVotedPolls();
    }
  }

  void savePolls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedPolls =
        jsonEncode(polls.map((poll) => poll.toJson()).toList());
    prefs.setString("polls", encodedPolls);
  }

  void saveVotedPolls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = authController.username.value;
    prefs.setStringList("voted_polls_$username", votedPolls);
  }

  void loadVotedPolls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = authController.username.value;
    List<String>? storedVotes = prefs.getStringList("voted_polls_$username");

    votedPolls.assignAll(storedVotes ?? []);
  }

  void resetVotedPolls() {
    votedPolls.clear();
  }
}
