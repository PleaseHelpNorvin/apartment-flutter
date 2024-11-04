import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for jsonEncode
import '../pages/clientdatasignup.dart';
import '../api/api.dart';


Future<http.Response> registerUser(String username, String email, String password) async {
  
  final response = await http.post(
    
    Uri.parse(Api.registerEndpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'email': email,
      'password': password,
    }),
  );

  return response;
}

Future<http.Response> updateClientInfo(Map<String, dynamic> clientData, String token, String userId) async {
  
  return await http.put(
    Uri.parse('${Api.tenantInfoUpdateEndpoint}/$userId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(clientData),
    
  );

  
}

Future<http.Response> loginUser(String username, String password) async {
  return await http.post(
    Uri.parse(Api.loginEndpoint),
    headers: {
      'Content-Type': 'application/json', // Set content type for JSON
    },
    body: jsonEncode({ // Convert body to JSON
      'username': username,
      'password': password,
    }),
  );
}
