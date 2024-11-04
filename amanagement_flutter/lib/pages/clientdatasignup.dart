import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../utils/httpmethods.dart';
import 'dart:convert';
import '../pages/home.dart';

class ClientDataSignup extends StatefulWidget {
  final String username;
  final String token;
  final String userId;

  const ClientDataSignup({super.key, required this.username, required this.token, required this.userId});

  @override
  State<ClientDataSignup> createState() => _ClientSignupState();
}

class _ClientSignupState extends State<ClientDataSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerMiddleName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerContactNumber = TextEditingController();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                "Client Information",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _controllerName,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerMiddleName,
                decoration: InputDecoration(
                  labelText: "Middle Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerLastName,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your last name' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerAddress,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerContactNumber,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your contact number' : null,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _submitClientData,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
void _submitClientData() async {
  if (_formKey.currentState?.validate() ?? false) {
    final clientData = {
      'username': widget.username,
      'name': _controllerName.text,
      'middlename': _controllerMiddleName.text,
      'lastname': _controllerLastName.text,
      'gender': _selectedGender,
      'address': _controllerAddress.text,
      'contact_number': _controllerContactNumber.text,
    };

    try {
      final response = await updateClientInfo(clientData, widget.token, widget.userId);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Client data registered successfully")),
        );

        // Store the username in Hive
        final Box _boxLogin = Hive.box("login");
        await _boxLogin.put("userName", widget.username);
         // Store username

        // Navigate to Home after successful submission
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(), // Redirect to Home
          ),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${errorData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }
}


  @override
  void dispose() {
    _controllerName.dispose();
    _controllerMiddleName.dispose();
    _controllerLastName.dispose();
    _controllerAddress.dispose();
    _controllerContactNumber.dispose();
    super.dispose();
  }
}
