import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'lista_alunos.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _token = "";

  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _usernameController.text;

    AuthService authService = AuthService();
    String? token = await authService.login(username, password);

    if (token != null) {
      setState(() {
        _token = token;
      });
    } else {
      setState(() {
        _token = "erro";
      });
    }
  }

  void _navegarParaListaAlunos(BuildContext context) {
    Navigator.push(
      context,
     MaterialPageRoute(builder: (context) => const ListaAlunosPage()
     ),
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(_token.isNotEmpty ? 'Token: $_token' : ''),
            const SizedBox(height: 150),
            ElevatedButton(
              onPressed: () async{
                _login(context);
                _navegarParaListaAlunos(context);
              },
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}
