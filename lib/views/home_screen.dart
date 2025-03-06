import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/poll_controller.dart';
import '../controllers/theme_controller.dart';
import 'create_poll_screen.dart';
import 'voting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PollController pollController = Get.put(PollController());
  final AuthController authController = Get.find();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeController.isDarkMode.value
                    ? [Color(0xFF1D1E33), Color(0xFF0A0E21)]
                    : [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Live Polling',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                  themeController.isDarkMode.value
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  color: Colors.white),
                              onPressed: () => themeController.toggleTheme(),
                            ),
                            IconButton(
                              icon: Icon(Icons.logout, color: Colors.white),
                              onPressed: () => _showLogoutDialog(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (pollController.polls.isEmpty) {
                        return Center(
                          child: Text(
                            'No polls available.\nCreate a new poll!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        );
                      }
                      pollController.loadPolls();
                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: pollController.polls.length,
                        itemBuilder: (context, index) {
                          final poll = pollController.polls[index];
                          int totalVotes = poll.votes.reduce((a, b) => a + b);
                          return GestureDetector(
                            onTap: () => Get.to(() => VotingScreen(index)),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      spreadRadius: 3),
                                  BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2),
                                ],
                                gradient: LinearGradient(
                                  colors: themeController.isDarkMode.value
                                      ? [Color(0xFF22223B), Color(0xFF3A3D61)]
                                      : [
                                          Colors.white.withOpacity(0.2),
                                          Colors.blueAccent.withOpacity(0.5)
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    poll.question,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 8),

                                  // Total Votes - Updated in Real Time
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LinearProgressIndicator(
                                        value: (totalVotes / 1000).clamp(0, 1),
                                        backgroundColor:
                                            Colors.white.withOpacity(0.3),
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.yellowAccent),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '$totalVotes votes',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Get.to(() => CreatePollScreen()),
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Create Poll', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orangeAccent,
          ),
        ));
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      confirm: ElevatedButton(
        onPressed: () {
          Get.find<AuthController>().logout();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        child: Text("Yes, Logout", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text("Cancel", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
