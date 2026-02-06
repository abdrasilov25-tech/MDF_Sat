
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
                      labelText: 'Email',
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
                    onPressed: () async {
                      // Вход через Email/Password
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: login.trim(),
                                password: password.trim());
                        setState(() {
                          message = '✅ Успешный вход: ${userCredential.user?.email}';
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FacadesPage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          message = '❌ Ошибка входа: ${e.message}';
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
                      // Регистрация через телефон
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPhonePage()),
                      );
                    },
                    child: const Text('Регистрация по телефону'),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.white)),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () {
                      // Регистрация через Email
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationEmailPage()),
                      );
                    },
                    child: const Text('Регистрация через Email'),
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

// ================= Экран регистрации через Email =================
class RegistrationEmailPage extends StatefulWidget {
  const RegistrationEmailPage({super.key});

  @override
  State<RegistrationEmailPage> createState() => _RegistrationEmailPageState();
}

class _RegistrationEmailPageState extends State<RegistrationEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  void register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => message = '❌ Введите email и пароль');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      setState(() => message = '✅ Регистрация успешна: ${userCredential.user?.email}');
      Navigator.pop(context); // возвращаемся на экран логина
    } on FirebaseAuthException catch (e) {
      setState(() => message = '❌ Ошибка регистрации: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация через Email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Зарегистрироваться'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                  color: message.startsWith('✅') ? Colors.green : Colors.red,
                  fontSize: 16),
            ),
          ],
        ),
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String message = '';
  String _verificationId = ''; // для хранения ID, который возвращает Firebase

  void sendCode() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => message = '❌ Введите номер телефона');
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setState(() => message = '✅ Телефон подтверждён автоматически');
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => message = '❌ Ошибка: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          message = '✅ Код отправлен на номер $phone';
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyCode() async {
    String smsCode = codeController.text.trim();
    if (smsCode.isEmpty) {
      setState(() => message = '❌ Введите код');
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      setState(() => message = '✅ Регистрация успешна!');
    } catch (e) {
      setState(() => message = '❌ Неверный код или ошибка');
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
            ElevatedButton(onPressed: sendCode, child: const Text('Отправить код')),
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
            ElevatedButton(onPressed: verifyCode, child: const Text('Подтвердить код')),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                  fontSize: 16,
                  color: message.startsWith('✅') ? Colors.green : Colors.red),
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
    final List<Map<String, String>> facades = [
      {'image': 'assets/fasad1.png', 'name': 'Рефленый'},
      {'image': 'assets/fasad2.png', 'name': 'Минимализм'},
      {'image': 'assets/fasad3.png', 'name': 'Рис:026'},
      {'image': 'assets/fasad4.png', 'name': 'Рис:027'},
      {'image': 'assets/fasad5.png', 'name': 'Рис:Выборка'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Фасады')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: facades.length,
        itemBuilder: (context, index) {
          final facade = facades[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacadeDetailPage(
                    image: facade['image']!,
                    name: facade['name']!,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      facade['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  facade['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= Экран деталей фасада =================
class FacadeDetailPage extends StatelessWidget {
  final String image;
  final String name;

  const FacadeDetailPage({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Expanded(
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Логика заказа фасада
            },
            child: const Text('Заказать'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

