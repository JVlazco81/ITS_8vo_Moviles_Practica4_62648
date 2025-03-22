import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario_model.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final usuario = Usuario(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    final success = await AuthService.login(usuario);
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Iniciar Sesión', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () {
                  final email = _usernameController.text.trim();
                  final password = _passwordController.text;

                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingresa un correo electrónico válido')),
                    );
                    return;
                  }

                  if (password.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres')),
                    );
                    return;
                  }

                  _login();
                },
                  child: const Text('Ingresar'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}