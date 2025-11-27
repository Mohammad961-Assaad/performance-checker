import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PerformanceCheckerPage(),
    );
  }
}

class PerformanceCheckerPage extends StatefulWidget {
  const PerformanceCheckerPage({super.key});

  @override
  State<PerformanceCheckerPage> createState() => _PerformanceCheckerPageState();
}

class _PerformanceCheckerPageState extends State<PerformanceCheckerPage> {
  final TextEditingController ramController = TextEditingController();
  final TextEditingController usedStorageController = TextEditingController();
  final TextEditingController totalStorageController = TextEditingController();
  final TextEditingController appsController = TextEditingController();

  int score = 0;
  String status = "";
  String recommendation = "";

  void calculateScore() {
    double ram = double.tryParse(ramController.text) ?? 0;
    double used = double.tryParse(usedStorageController.text) ?? 0;
    double total = double.tryParse(totalStorageController.text) ?? 0;
    int apps = int.tryParse(appsController.text) ?? 0;

    if (total <= 0) {
      setState(() {
        score = 0;
        status = "Invalid Input";
        recommendation = "Please enter valid storage values.";
      });
      return;
    }

    double free = total - used;
    double freePercent = (free / total) * 100;

    // Storage score (0–40)
    int storageScore = 0;
    if (freePercent > 70) storageScore = 40;
    else if (freePercent > 50) storageScore = 30;
    else if (freePercent > 30) storageScore = 20;
    else if (freePercent > 10) storageScore = 10;
    else storageScore = 5;

    // RAM score (0–30)
    int ramScore = 0;
    if (ram >= 12) ramScore = 30;
    else if (ram >= 8) ramScore = 25;
    else if (ram >= 6) ramScore = 18;
    else if (ram >= 4) ramScore = 10;
    else ramScore = 5;

    // Apps score (0–30)
    int appsScore = 0;
    if (apps <= 40) appsScore = 30;
    else if (apps <= 80) appsScore = 20;
    else if (apps <= 120) appsScore = 10;
    else appsScore = 5;

    int totalScore = storageScore + ramScore + appsScore;

    String deviceStatus;
    String rec;

    if (totalScore >= 80) {
      deviceStatus = "Excellent";
      rec = "Your device is performing very well.\n- Keep storage above 30% free.\n- Avoid installing unnecessary apps.";
    } else if (totalScore >= 60) {
      deviceStatus = "Good";
      rec = "Good performance.\n- Try removing unused apps.\n- Keep storage clean.";
    } else if (totalScore >= 40) {
      deviceStatus = "Fair";
      rec = "Some issues detected.\n- Delete files to free storage.\n- Reduce background apps.";
    } else {
      deviceStatus = "Poor";
      rec = "Your device is slow.\n- Uninstall heavy apps.\n- Free at least 10–15GB.\n- Restart the phone daily.";
    }

    setState(() {
      score = totalScore;
      status = deviceStatus;
      recommendation = rec;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance Score Checker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields
            MyTextField(label: "RAM (GB)", controller: ramController),
            const SizedBox(height: 12),
            MyTextField(label: "Used Storage (GB)", controller: usedStorageController),
            const SizedBox(height: 12),
            MyTextField(label: "Total Storage (GB)", controller: totalStorageController),
            const SizedBox(height: 12),
            MyTextField(label: "Installed Apps", controller: appsController),
            const SizedBox(height: 20),

            // Button
            Center(
              child: ElevatedButton(
                onPressed: calculateScore,
                child: const Text("Calculate Score"),
              ),
            ),

            const SizedBox(height: 20),

            // Output
            Text("Score: $score / 100",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Status: $status",
                style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
            const SizedBox(height: 10),
            Text(
              recommendation,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
// own reusable TextField widget instead of writing the same code many times.
class MyTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const MyTextField({required this.label, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
