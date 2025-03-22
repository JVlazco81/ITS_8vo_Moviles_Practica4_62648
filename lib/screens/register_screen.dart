import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    final usuario = Usuario(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    final success = await AuthService.register(usuario);
    if (success && mounted) {
      Navigator.pop(context); // Volver a Login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrarse')),
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
              Text('Registro', style: Theme.of(context).textTheme.headlineMedium),
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

                    _register();
                  },
                  child: const Text('Registrarse'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Volver al Login
                },
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}