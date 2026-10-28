import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snack Circle',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo signup complete! Your form passed validation.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snack Circle'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join the snack club',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A demo signup for people who love a good snack.',
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'Please enter your email';
                        }

                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(email)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SignupTipCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupTipCard extends StatefulWidget {
  const SignupTipCard({super.key});

  @override
  State<SignupTipCard> createState() => _SignupTipCardState();
}

class _SignupTipCardState extends State<SignupTipCard> {
  static const _category = 'password_help';

  static const _tips = <String, List<String>>{
    'password_help': [
      'Choose a long password that you do not use for another account.',
      'A password manager can help you create and remember unique passwords.',
      'Avoid using your name, birthday, or other easy-to-guess information.',
    ],
  };

  bool _loading = false;
  bool _failNext = false;
  int _nextTip = 0;
  String? _tip;
  String? _error;

  Future<void> _getTip() async {
    if (_loading) return;

    final shouldFail = _failNext;

    setState(() {
      _loading = true;
      _failNext = false;
      _tip = null;
      _error = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final choices = _tips[_category];

    setState(() {
      _loading = false;

      if (shouldFail) {
        _error = 'Simulated local error. Tap Retry to get a tip.';
      } else if (choices == null || choices.isEmpty) {
        _error = 'No preset tips available. Tap Retry to try again.';
      } else {
        _tip = choices[_nextTip % choices.length];
        _nextTip++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Signup Coach',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Preset demo tip—not live AI.'),
            const SizedBox(height: 8),
            const Text(
              'General tips only. Your form is checked separately.',
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Simulate next tip error'),
              value: _failNext,
              onChanged: _loading
                  ? null
                  : (value) {
                      setState(() => _failNext = value ?? false);
                    },
            ),
            ElevatedButton(
              onPressed: _loading ? null : _getTip,
              child: Text(
                _error == null ? 'Get a signup tip' : 'Retry',
              ),
            ),
            if (_loading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const Text('Loading preset tip...'),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (_tip != null) ...[
              const SizedBox(height: 12),
              Text(_tip!),
            ],
          ],
        ),
      ),
    );
  }
}