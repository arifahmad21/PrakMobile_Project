import 'package:flutter/material.dart';
import 'package:projek_akhir/view/home.dart';
import 'package:projek_akhir/view/register.dart';
import 'package:hive/hive.dart';
import '../model/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHovering = false;

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var box = Hive.box<User>('users');
    User user = box.values.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => User(username: '', password: ''),
    );
    if (user.username.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      _showDialog('Login Berhasil', 'Selamat datang! Anda telah berhasil login.');
    } else {
      _showDialog('Login Gagal!', 'Username atau Password salah');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _header(),
            SizedBox(height: 20),
            _inputField(),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          "Login Akun",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text("Masukkan username dan password untuk melanjutkan", textAlign: TextAlign.center),
      ],
    );
  }

  Widget _inputField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: _usernameController,
        decoration: InputDecoration(
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.person),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock),
        ),
        obscureText: true,
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _login,
        child: Text(
          "Login",
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum punya akun? ',
            style: TextStyle(fontSize: 16),
          ),
          MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovering = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHovering = false;
              });
            },
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                "Daftar Sekarang",
                style: TextStyle(
                  fontSize: 16,
                  color: _isHovering ? Colors.blue : null,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
}