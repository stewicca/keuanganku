import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const KeuanganKuApp());
}

class KeuanganKuApp extends StatelessWidget {
  const KeuanganKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeuanganKu',
      theme: ThemeData(useMaterial3: true),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selamat Datang di KeuanganKu',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                );
              },
              child: const Text('Mulai'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _locationPage(),
          _salaryPage(),
          const LoginRegisterPage(),
        ],
      ),
    );
  }

  Widget _locationPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Kami membutuhkan akses lokasi Anda'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await Permission.location.request();
              _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
            child: const Text('Izinkan'),
          ),
        ],
      ),
    );
  }

  Widget _salaryPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Masukkan gaji bulanan Anda'),
          TextField(
            controller: _salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Gaji bulanan'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
            child: const Text('Selanjutnya'),
          ),
        ],
      ),
    );
  }
}

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Login atau Register'),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Masuk / Daftar'),
          ),
        ],
      ),
    );
  }
}

