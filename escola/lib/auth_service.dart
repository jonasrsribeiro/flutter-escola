import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://demo4909971.mockable.io/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return data['token'];
      } else {
        return null;
      }
    }
    return null;
  }
}
