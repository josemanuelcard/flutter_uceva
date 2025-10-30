import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

/// Pantalla completa de autenticación con registro y almacenamiento real
class SimpleAuthScreen extends StatefulWidget {
  const SimpleAuthScreen({super.key});

  @override 
  State<SimpleAuthScreen> createState() => _SimpleAuthScreenState();
}

class _SimpleAuthScreenState extends State<SimpleAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoginMode = true; // true = login, false = registro

  @override
  void initState() {
    super.initState();
    // Inicializar el AuthController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(_isLoginMode ? 'Iniciar Sesión JWT' : 'Registrarse JWT'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          _isLoginMode ? 'Iniciar Sesión JWT' : 'Registrarse JWT',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLoginMode 
                            ? 'Ingresa tus credenciales para acceder'
                            : 'Crea tu cuenta para acceder',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Campo de nombre (solo en registro)
                        if (!_isLoginMode) ...[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre completo',
                              prefixIcon: const Icon(Icons.person_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (!_isLoginMode && (value == null || value.isEmpty)) {
                                return 'El nombre es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Campo de email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El email es requerido';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Formato de email inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Campo de contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La contraseña es requerida';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Botón principal (login o registro)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authController.isLoading ? null : (_isLoginMode ? _handleLogin : _handleRegister),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: authController.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    _isLoginMode ? 'Iniciar Sesión' : 'Registrarse',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Botón para cambiar modo
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                              _formKey.currentState?.reset();
                            });
                          },
                          child: Text(
                            _isLoginMode 
                              ? '¿No tienes cuenta? Regístrate'
                              : '¿Ya tienes cuenta? Inicia sesión',
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Botón para ir a evidencia
                        TextButton(
                          onPressed: () {
                            context.go('/evidencia');
                          },
                          child: const Text('Ver Evidencia Local'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(context, listen: false);
      
      await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Mostrar resultado
      if (authController.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login exitoso - Datos guardados'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar a evidencia
        if (mounted) {
          context.go('/evidencia');
        }
      } else if (authController.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${authController.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(context, listen: false);
      
      await authController.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordController.text,
      );

      // Mostrar resultado
      if (authController.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Registro exitoso - Datos guardados'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar a evidencia
        if (mounted) {
          context.go('/evidencia');
        }
      } else if (authController.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${authController.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}