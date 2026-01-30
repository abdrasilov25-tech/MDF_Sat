
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ================= Главный виджет =================
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

// ================= Экран логина =================
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
          // Прозрачная накладка
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
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
                    'МДФ Фасады',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    onChanged: (value) => login = value,
                    decoration: const InputDecoration(
                      labelText: 'Логин',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    onChanged: (value) => password = value,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (login.trim() == 'beksultan' &&
                          password.trim() == '1234') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FacadesPage()),
                        );
                      } else {
                        setState(() {
                          message = '❌ Неправильный логин или пароль';
                        });
                      }
                    },
                    child: const Text('Войти'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () {
                      // Переход к экрану регистрации по телефону
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RegistrationPhonePage()),
                      );
                    },
                    child: const Text('Зарегистрироваться'),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
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

// ================= Экран регистрации по телефону =================
class RegistrationPhonePage extends StatefulWidget {
  const RegistrationPhonePage({super.key});

  @override
  State<RegistrationPhonePage> createState() => _RegistrationPhonePageState();
}

class _RegistrationPhonePageState extends State<RegistrationPhonePage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  String message = '';
  String sentCode = ''; // код, который мы "отправляем" для проверки

  void sendCode() {
    // Здесь можно интегрировать реальный SMS сервис (например Firebase)
    sentCode = '1234'; // симуляция
    setState(() {
      message = 'На номер ${phoneController.text} отправлен код: $sentCode';
    });
  }

  void verifyCode() {
    if (codeController.text == sentCode) {
      setState(() {
        message = '✅ Регистрация успешна!';
      });
    } else {
      setState(() {
        message = '❌ Неверный код';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация по телефону')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Введите номер телефона',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: sendCode,
              child: const Text('Отправить код'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Введите код',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: verifyCode,
              child: const Text('Подтвердить код'),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Экран фасадов =================
class FacadesPage extends StatelessWidget {
  const FacadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фасады')),
      body: const Center(child: Text('Здесь будет список фасадов')),
    );
  }
}

