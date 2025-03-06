import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/poll_controller.dart';
import '../controllers/theme_controller.dart';

class VotingScreen extends StatefulWidget {
  final int pollIndex;
  const VotingScreen(this.pollIndex, {super.key});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final PollController pollController = Get.find();
  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final poll = pollController.polls[widget.pollIndex];
    final bool hasVoted =
        pollController.votedPolls.contains("poll_${widget.pollIndex}");

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
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                        Text('Vote Now',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Poll Question
                  Hero(
                    tag: "poll_${widget.pollIndex}",
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                spreadRadius: 2),
                            BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                blurRadius: 5,
                                spreadRadius: 1),
                          ],
                        ),
                        child: Text(
                          poll.question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Voting Options OR Already Voted Message
                  hasVoted
                      ? Center(
                          child: Text(
                            "You have already voted!",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                        )
                      : Column(
                          children: poll.options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;
                            return GestureDetector(
                              onTap: () {
                                pollController.vote(widget.pollIndex, index,
                                    authController.username.value);
                                setState(() {}); // Refresh UI after voting
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: themeController.isDarkMode.value
                                        ? [Color(0xFF3A3D61), Color(0xFF22223B)]
                                        : [
                                            Colors.blueAccent.withOpacity(0.4),
                                            Colors.purpleAccent.withOpacity(0.5)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        spreadRadius: 2),
                                    BoxShadow(
                                        color:
                                            Colors.blueAccent.withOpacity(0.4),
                                        blurRadius: 5,
                                        spreadRadius: 1),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      option,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    Obx(() => Text(
                                          pollController.polls[widget.pollIndex]
                                              .votes[index]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.yellowAccent),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                  SizedBox(height: 20),

                  // Animated Poll Chart
                  Expanded(child: PollChart(pollController, widget.pollIndex)),
                ],
              ),
            ),
          ),
        ));
  }
}

// Poll Chart with Smooth Animations
class PollChart extends StatefulWidget {
  final PollController pollController;
  final int pollIndex;
  const PollChart(this.pollController, this.pollIndex, {super.key});

  @override
  _PollChartState createState() => _PollChartState();
}

class _PollChartState extends State<PollChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartAnimation;

  @override
  void initState() {
    super.initState();
    _chartAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _chartAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final poll = widget.pollController.polls[widget.pollIndex];

      return AnimatedBuilder(
        animation: _chartAnimation,
        builder: (context, child) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 1),
              ],
            ),
            child: BarChart(
              BarChartData(
                barGroups: List.generate(
                  poll.options.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (poll.votes[index] * _chartAnimation.value)
                            .toDouble(),
                        color: Colors.yellowAccent,
                        width: 20,
                        borderRadius: BorderRadius.circular(5),
                      )
                    ],
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                          poll.options[value.toInt()],
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                      reservedSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
