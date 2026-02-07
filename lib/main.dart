import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png')
            .animate()
            .fadeIn(duration: 1000.ms) // плавное появление
            .scale(duration: 800.ms, curve: Curves.easeOut),
      ),
    );
  }
}

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
                  Text(
  'МДФ Фасады',
  style:  TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
)
.animate()
.fadeIn(duration: 600.ms)
.slideY(begin: -0.3),
                  const SizedBox(height: 30),
                  TextField(
  onChanged: (value) => login = value,
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
  ),
)
.animate()
.fadeIn(delay: 200.ms)
.slideY(begin: 0.3),
                  const SizedBox(height: 15),
                  TextField(
  obscureText: true,
  onChanged: (value) => password = value,
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: 'Пароль',
    border: OutlineInputBorder(),
  ),
)
.animate()
.fadeIn(delay: 350.ms)
.slideY(begin: 0.3),
                  const SizedBox(height: 20),
                  ElevatedButton(
  onPressed: () {
    if (login.trim() == 'bbb' && password.trim() == '000') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        message = '❌ Неверный логин или пароль';
      });
    }
  },
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
  ),
  child: const Text('Войти'),
)
.animate()
.fadeIn(delay: 500.ms)
.scale(begin: const Offset(0.95, 0.95)),
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
                    style: const TextStyle(fontSize: 18, color: Colors.white),
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
    backgroundColor: Colors.white, // однотонный белый фон
    appBar: AppBar(
      title: const Text('Регистрация через Email'),
      backgroundColor: Colors.deepPurpleAccent, // можно оставить ярким
    ),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Email
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.black), // текст чёрный
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.grey[700]), // подсказка серой
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!), // рамка серой
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurpleAccent), // рамка при фокусе
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Пароль
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Пароль',
              labelStyle: TextStyle(color: Colors.grey[700]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurpleAccent),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Кнопка регистрации
          ElevatedButton(
            onPressed: register,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.deepPurpleAccent,
            ),
            child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 20),

          // Сообщение об ошибке или успехе
          Text(
            message,
            style: TextStyle(
              color: message.isEmpty
                  ? Colors.grey
                  : (message.startsWith('✅') ? Colors.green : Colors.red),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}}

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
  String _verificationId = '';

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
      backgroundColor: Colors.white, // белый фон
      appBar: AppBar(
        title: const Text('Регистрация по телефону'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ===== Ввод номера с регионом =====
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Номер телефона (с кодом страны)',
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixText: '+7 ', // можно изменить для региона
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // ===== Ввод кода подтверждения =====
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Код подтверждения',
                labelStyle: TextStyle(color: Colors.grey[700]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ===== Кнопки =====
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Отправить код', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Подтвердить', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== Сообщение =====
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: message.isEmpty
                    ? Colors.grey
                    : (message.startsWith('✅') ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Главная страница =================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== Фон =====
          Positioned.fill(
            child: Image.asset(
              'assets/bb.png', // твой фон
              fit: BoxFit.cover,
            ),
          ),
          // ===== Полупрозрачная накладка для контраста =====
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // ===== Контент =====
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FacadesPage()),
    );
  },
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 80),
    backgroundColor: Colors.transparent, // прозрачный фон
    shadowColor: Colors.transparent, // убираем тень
    side: BorderSide(color: Colors.black), // можно добавить рамку, если нужно
  ),
  child: const Text(
    'Фасады',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // черный текст
  ),
),
                const SizedBox(height: 30),
                ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FurniturePage()),
    );
  },
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 80),
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    side: BorderSide(color: Colors.black),
  ),
  child: const Text(
    'Корпусная мебель',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= Фасады =================
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

// ================= Детали фасада =================
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
          Expanded(child: Image.asset(image, fit: BoxFit.cover)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Заказать'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ================= Корпусная мебель =================
class FurniturePage extends StatelessWidget {
  const FurniturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> furniture = [
      {'image': 'assets/furniture1.png', 'name': 'Шкаф'},
      {'image': 'assets/furniture2.png', 'name': 'Кухня'},
      {'image': 'assets/furniture3.png', 'name': 'Комод'},
      {'image': 'assets/furniture4.png', 'name': 'Стеллаж'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Корпусная мебель')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: furniture.length,
        itemBuilder: (context, index) {
          final item = furniture[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FurnitureDetailPage(
                    image: item['image']!,
                    name: item['name']!,
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
                      item['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name']!,
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

// ================= Детали мебели =================
class FurnitureDetailPage extends StatelessWidget {
  final String image;
  final String name;
  const FurnitureDetailPage({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Expanded(child: Image.asset(image, fit: BoxFit.cover)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Заказать'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

