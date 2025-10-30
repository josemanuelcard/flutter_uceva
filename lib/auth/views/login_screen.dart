import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

/// Pantalla de login con formulario y validaciones
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRegisterMode = false;

  // Controllers para el modo registro
  final _nameController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
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
                      // Logo o título
                      _buildHeader(),
                      const SizedBox(height: 32),
                      
                      // Toggle entre login y registro
                      _buildModeToggle(),
                      const SizedBox(height: 24),
                      
                      // Formulario
                      if (_isRegisterMode) _buildRegisterForm() else _buildLoginForm(),
                      
                      const SizedBox(height: 24),
                      
                      // Botón de envío
                      _buildSubmitButton(),
                      
                      const SizedBox(height: 16),
                      
                      // Enlace para cambiar modo
                      _buildModeSwitch(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construir header con logo y título
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo (puedes reemplazar con tu logo)
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
        const SizedBox(height: 16),
        Text(
          _isRegisterMode ? 'Crear Cuenta' : 'Iniciar Sesión',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isRegisterMode 
            ? 'Regístrate para comenzar'
            : 'Ingresa tus credenciales',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Toggle entre modo login y registro
  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isRegisterMode = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isRegisterMode ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: !_isRegisterMode ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: !_isRegisterMode ? FontWeight.bold : FontWeight.normal,
                    color: !_isRegisterMode ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isRegisterMode = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isRegisterMode ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _isRegisterMode ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  'Registro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: _isRegisterMode ? FontWeight.bold : FontWeight.normal,
                    color: _isRegisterMode ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formulario de login
  Widget _buildLoginForm() {
    return Column(
      children: [
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
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
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
      ],
    );
  }

  /// Formulario de registro
  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Campo de nombre
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
            if (value == null || value.isEmpty) {
              return 'El nombre es requerido';
            }
            if (value.length < 2) {
              return 'El nombre debe tener al menos 2 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
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
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
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
        
        // Campo de confirmación de contraseña
        TextFormField(
          controller: _passwordConfirmationController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Confirmar contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La confirmación de contraseña es requerida';
            }
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Botón de envío del formulario
  Widget _buildSubmitButton() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: authController.isLoading ? null : _handleSubmit,
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
                    _isRegisterMode ? 'Crear Cuenta' : 'Iniciar Sesión',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// Enlace para cambiar entre login y registro
  Widget _buildModeSwitch() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isRegisterMode = !_isRegisterMode;
          _formKey.currentState?.reset();
        });
      },
      child: Text(
        _isRegisterMode
            ? '¿Ya tienes cuenta? Inicia sesión'
            : '¿No tienes cuenta? Regístrate',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Manejar envío del formulario
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(context, listen: false);
      
      if (_isRegisterMode) {
        // Registro
        authController.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmationController.text,
        );
      } else {
        // Login
        authController.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    }
  }
}
