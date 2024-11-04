import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final Box _boxLogin = Hive.box("login");

  @override
  Widget build(BuildContext context) {
    // Retrieve the username from Hive
    final String username = _boxLogin.get("userName", defaultValue: "Guest") as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login App"),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Implement logout functionality here
                  // Example: Navigate to login page or clear Hive box
                  _boxLogin.clear(); // Clears all saved data
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, $username!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              "This is the home page.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
