import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/poll_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/poll.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  _CreatePollScreenState createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final PollController pollController = Get.find();
  final ThemeController themeController = Get.put(ThemeController());
  final TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ]; // Start with 2 options

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text('Create Poll',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Poll Question Input
                      _buildTextField(
                          questionController, "Enter poll question"),
                      SizedBox(height: 16),

                      // Dynamic Options List
                      Column(
                        children:
                            List.generate(optionControllers.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      optionControllers[index],
                                      "Option ${index + 1}"),
                                ),
                                SizedBox(width: 10),

                                // Remove Option Button (Only if more than 2 options)
                                if (optionControllers.length > 2)
                                  IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        optionControllers.removeAt(index);
                                      });
                                    },
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 10),

                      // Add Option Button (Max 4)
                      if (optionControllers.length < 4)
                        ElevatedButton.icon(
                          onPressed: () {
                            if (optionControllers.length < 4) {
                              setState(() {
                                optionControllers.add(TextEditingController());
                              });
                            }
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text("Add Option",
                              style: TextStyle(color: Colors.white)),
                          style: _buildButtonStyle(),
                        ),

                      SizedBox(height: 20),

                      // Create Poll Button
                      ElevatedButton(
                        onPressed: () {
                          if (questionController.text.isNotEmpty &&
                              optionControllers.any((c) => c.text.isNotEmpty)) {
                            pollController.addPoll(
                              Poll(
                                question: questionController.text,
                                options: optionControllers
                                    .map((c) => c.text)
                                    .where((text) => text.isNotEmpty)
                                    .toList(),
                              ),
                            );
                            Get.back();
                          }
                        },
                        style: _buildButtonStyle(),
                        child: Text('Create Poll',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.purpleAccent.withOpacity(0.5),
      elevation: 10,
    ).copyWith(
      overlayColor:
          WidgetStateProperty.all(Colors.purpleAccent.withOpacity(0.3)),
      side: WidgetStateProperty.all(
          BorderSide(color: Colors.white.withOpacity(0.4), width: 1)),
    );
  }
}
