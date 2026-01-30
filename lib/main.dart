
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Facade>> fetchFacades() async {
  final response = await http.get(Uri.parse('https://mocki.io/v1/5a8c78d0-3c5c-4b7e-9d2f-1f6a4f5b2f9e'));

  if (response.statusCode == 200) {
    List jsonData = jsonDecode(response.body);
    return jsonData.map((item) => Facade.fromJson(item)).toList();
  } else {
    throw Exception('Ошибка загрузки фасадов');
  }
}



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String login = '';
  String password = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фон
          Positioned.fill(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          // Прозрачная тёмная накладка
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3), // ✅ исправлено
            ),
          ),
          // Контент
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Мдф фасады',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 6, 13, 7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      login = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Логин',
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                     if (login == 'beksultan' && password == '1234') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(

                      builder: (context) => const HomePage(),
        ),
      );
    } else {
      setState(() {
        message = '❌ ОШИБКА';
      });
    }
  },
  child: const Text('Войти'),
),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Бацок ты в теме 🚀',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // выйти назад
              },
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
class Facade {
  final String name;
  final String image;
  final int price;

  Facade({required this.name, required this.image, required this.price});

  factory Facade.fromJson(Map<String, dynamic> json) {
    return Facade(
      name: json['name'],
      image: json['image'],
      price: json['price'],
    );
  }
}
