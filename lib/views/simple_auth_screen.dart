import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/services/auth_service.dart';
import '../auth/models/auth_response.dart';

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
  bool _isLoading = false;
  bool _isLoginMode = true; // true = login, false = registro
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        hintText: 'test@test.com',
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
                        hintText: '123456',
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
                    const SizedBox(height: 16),
                    
                    // Botón para llenar credenciales de prueba
                    TextButton.icon(
                      onPressed: () {
                        _emailController.text = 'test@test.com';
                        _passwordController.text = '123456';
                        if (!_isLoginMode) {
                          _nameController.text = 'Test';
                        }
                      },
                      icon: const Icon(Icons.science, size: 16),
                      label: const Text('Usar credenciales de prueba'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[600],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Botón principal (login o registro)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : (_isLoginMode ? _handleLogin : _handleRegister),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
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
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Usar el servicio real de autenticación
        final response = await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        if (response.success && response.accessToken != null) {
          // Guardar tokens en almacenamiento seguro
          await _storage.write(key: 'access_token', value: response.accessToken!);
          if (response.refreshToken != null) {
            await _storage.write(key: 'refresh_token', value: response.refreshToken!);
          }
          
          // Guardar datos del usuario en shared_preferences
          final prefs = await SharedPreferences.getInstance();
          if (response.user != null) {
            await prefs.setString('user_name', response.user!.name);
            await prefs.setString('user_email', response.user!.email);
            await prefs.setInt('user_id', response.user!.id);
          } else {
            await prefs.setString('user_email', _emailController.text.trim());
          }
          
          setState(() {
            _isLoading = false;
          });

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${response.message}'),
              backgroundColor: Colors.green,
            ),
          );

          // Navegar a evidencia
          context.go('/evidencia');
        } else {
          setState(() {
            _isLoading = false;
          });
          
          // Mostrar error de la API con más detalles
          String errorMessage = response.message;
          if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
            errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
          } else if (errorMessage.contains('404')) {
            errorMessage = 'Servicio no disponible. Contacta al administrador.';
          } else if (errorMessage.contains('500')) {
            errorMessage = 'Error del servidor. Intenta más tarde.';
          } else if (errorMessage.contains('timeout') || errorMessage.contains('Timeout')) {
            errorMessage = 'Tiempo de espera agotado. Verifica tu conexión.';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        String errorMessage = 'Error de conexión';
        if (e.toString().contains('SocketException')) {
          errorMessage = 'Sin conexión a internet. Verifica tu red.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Tiempo de espera agotado. El servidor tardó demasiado.';
        } else if (e.toString().contains('ClientException')) {
          errorMessage = 'No se pudo conectar con el servidor.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Usar el servicio real de autenticación
        final response = await _authService.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _passwordController.text,
        );
        
        if (response.success && response.accessToken != null) {
          // Guardar tokens en almacenamiento seguro
          await _storage.write(key: 'access_token', value: response.accessToken!);
          if (response.refreshToken != null) {
            await _storage.write(key: 'refresh_token', value: response.refreshToken!);
          }
          
          // Guardar datos del usuario en shared_preferences
          final prefs = await SharedPreferences.getInstance();
          if (response.user != null) {
            await prefs.setString('user_name', response.user!.name);
            await prefs.setString('user_email', response.user!.email);
            await prefs.setInt('user_id', response.user!.id);
          } else {
            await prefs.setString('user_name', _nameController.text.trim());
            await prefs.setString('user_email', _emailController.text.trim());
          }
          
          setState(() {
            _isLoading = false;
          });

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${response.message}'),
              backgroundColor: Colors.green,
            ),
          );

          // Navegar a evidencia
          context.go('/evidencia');
        } else {
          setState(() {
            _isLoading = false;
          });
          
          // Mostrar error de la API con más detalles
          String errorMessage = response.message;
          if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
            errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
          } else if (errorMessage.contains('404')) {
            errorMessage = 'Servicio no disponible. Contacta al administrador.';
          } else if (errorMessage.contains('500')) {
            errorMessage = 'Error del servidor. Intenta más tarde.';
          } else if (errorMessage.contains('timeout') || errorMessage.contains('Timeout')) {
            errorMessage = 'Tiempo de espera agotado. Verifica tu conexión.';
          } else if (errorMessage.contains('422') || errorMessage.contains('validation')) {
            errorMessage = 'Datos inválidos. Verifica la información ingresada.';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        String errorMessage = 'Error de conexión';
        if (e.toString().contains('SocketException')) {
          errorMessage = 'Sin conexión a internet. Verifica tu red.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Tiempo de espera agotado. El servidor tardó demasiado.';
        } else if (e.toString().contains('ClientException')) {
          errorMessage = 'No se pudo conectar con el servidor.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}