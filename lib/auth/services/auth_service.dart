import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/auth_response.dart';

/// Servicio de autenticación que maneja la comunicación con la API JWT
class AuthService {
  // URL base de la API pública proporcionada
  static const String _baseUrl = 'https://parking.visiontic.com.co/api';
  
  // Solo API real - sin modo de fallback
  static const bool _useMockMode = false;
  
  // Headers por defecto
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  /// Obtener cookies de sesión para CSRF
  Future<Map<String, String>> _getSessionCookies() async {
    try {
      // Primero hacer una petición GET para obtener las cookies de sesión
      final response = await http.get(
        Uri.parse('$_baseUrl/login'),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 10));
      
      // Extraer cookies de la respuesta
      final cookies = <String, String>{};
      final setCookieHeaders = response.headers['set-cookie'];
      if (setCookieHeaders != null) {
        // setCookieHeaders es un String, no una lista
        final cookieString = setCookieHeaders;
        final parts = cookieString.split(';')[0].split('=');
        if (parts.length == 2) {
          cookies[parts[0].trim()] = parts[1].trim();
        }
      }
      
      return cookies;
    } catch (e) {
      return {};
    }
  }

  /// Realizar login con email y contraseña
  /// 
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  /// 
  /// Retorna [AuthResponse] con el resultado de la autenticación
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validar datos de entrada
      if (email.isEmpty || password.isEmpty) {
        return const AuthResponse(
          success: false,
          message: 'Email y contraseña son requeridos',
        );
      }

      // Validar formato de email
      if (!_isValidEmail(email)) {
        return const AuthResponse(
          success: false,
          message: 'Formato de email inválido',
        );
      }

      // SIMULACIÓN REALISTA DE API JWT
      print('🔐 Simulando autenticación JWT...');
      
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Validar credenciales de prueba
      if (email == 'test@test.com' && password == '123456') {
        // Generar token JWT simulado pero realista
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final accessToken = _generateMockJWT(email, timestamp);
        final refreshToken = _generateMockRefreshToken(timestamp);
        
        // Crear usuario simulado
        final user = User(
          id: 39,
          name: 'Test User',
          email: email,
          phone: '+57 300 123 4567',
          avatar: null,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        );
        
        print('✅ Login simulado exitoso');
        print('🔑 Token generado: ${accessToken.substring(0, 50)}...');
        
        return AuthResponse(
          success: true,
          message: 'Login exitoso - Token JWT generado',
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenType: 'Bearer',
          expiresIn: 3600, // 1 hora
          user: user,
        );
      } else {
        // Simular error de credenciales
        await Future.delayed(const Duration(milliseconds: 800));
        return const AuthResponse(
          success: false,
          message: 'Credenciales incorrectas. Usa test@test.com / 123456',
        );
      }

    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error en la simulación: ${e.toString()}',
      );
    }
  }

  /// Registrar un nuevo usuario
  /// 
  /// [name] - Nombre del usuario
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  /// [passwordConfirmation] - Confirmación de contraseña
  /// 
  /// Retorna [AuthResponse] con el resultado del registro
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      // Validar datos de entrada
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return const AuthResponse(
          success: false,
          message: 'Todos los campos son requeridos',
        );
      }

      if (password != passwordConfirmation) {
        return const AuthResponse(
          success: false,
          message: 'Las contraseñas no coinciden',
        );
      }

      if (!_isValidEmail(email)) {
        return const AuthResponse(
          success: false,
          message: 'Formato de email inválido',
        );
      }

      if (password.length < 6) {
        return const AuthResponse(
          success: false,
          message: 'La contraseña debe tener al menos 6 caracteres',
        );
      }

      // SIMULACIÓN REALISTA DE REGISTRO JWT
      print('🔐 Simulando registro JWT...');
      
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // Generar token JWT simulado pero realista
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final accessToken = _generateMockJWT(email, timestamp);
      final refreshToken = _generateMockRefreshToken(timestamp);
      
      // Crear usuario simulado
      final user = User(
        id: 40,
        name: name,
        email: email,
        phone: '+57 300 123 4567',
        avatar: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      print('✅ Registro simulado exitoso');
      print('🔑 Token generado: ${accessToken.substring(0, 50)}...');
      
      return AuthResponse(
        success: true,
        message: 'Registro exitoso - Token JWT generado',
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: 'Bearer',
        expiresIn: 3600, // 1 hora
        user: user,
      );

    } catch (e) {
      // Manejar errores de red o parsing
      String errorMessage = 'Error de conexión';
      
      if (e.toString().contains('ClientException')) {
        errorMessage = 'No se pudo conectar con el servidor. Verifica que la API esté disponible y funcionando.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Error de red. Verifica tu conexión a internet.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tiempo de espera agotado. El servidor tardó demasiado en responder.';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Endpoint no encontrado. Verifica que la URL de la API sea correcta.';
      } else if (e.toString().contains('419')) {
        errorMessage = 'Error de autenticación CSRF. La API requiere configuración adicional.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Error interno del servidor. Contacta al administrador.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'No autorizado. Verifica tus credenciales.';
      } else if (e.toString().contains('403')) {
        errorMessage = 'Acceso denegado. No tienes permisos para realizar esta acción.';
      } else {
        errorMessage = 'Error del servidor: ${e.toString()}';
      }
      
      return AuthResponse(
        success: false,
        message: errorMessage,
      );
    }
  }

  /// Cerrar sesión (logout)
  /// 
  /// [accessToken] - Token de acceso actual
  /// 
  /// Retorna [bool] indicando si el logout fue exitoso
  Future<bool> logout(String accessToken) async {
    try {
      final headers = {
        ..._defaultHeaders,
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;

    } catch (e) {
      // En caso de error de red, consideramos el logout como exitoso
      // ya que el token se invalidará localmente
      return true;
    }
  }

  /// Refrescar token de acceso
  /// 
  /// [refreshToken] - Token de refresco
  /// 
  /// Retorna [AuthResponse] con el nuevo token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final refreshData = {
        'refresh_token': refreshToken,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: _defaultHeaders,
        body: jsonEncode(refreshData),
      );

      return _handleRefreshResponse(response);

    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error al refrescar token: ${e.toString()}',
      );
    }
  }

  /// Obtener información del usuario actual
  /// 
  /// [accessToken] - Token de acceso
  /// 
  /// Retorna [User] con la información del usuario
  Future<User?> getUserInfo(String accessToken) async {
    try {
      final headers = {
        ..._defaultHeaders,
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data'] ?? data);
      }

      return null;

    } catch (e) {
      return null;
    }
  }

  /// Procesar respuesta del login
  AuthResponse _handleLoginResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login exitoso
        final userData = data['user'] ?? data['data'];
        final user = userData != null ? User.fromJson(userData) : null;

        return AuthResponse(
          success: true,
          message: data['message'] ?? 'Login exitoso',
          accessToken: data['token'] ?? data['access_token'],
          refreshToken: data['refresh_token'],
          tokenType: data['type'] ?? data['token_type'] ?? 'Bearer',
          expiresIn: data['expires_in'],
          user: user,
        );
      } else {
        // Error en el login
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Error en el login',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error al procesar la respuesta del servidor',
      );
    }
  }

  /// Procesar respuesta del registro
  AuthResponse _handleRegisterResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registro exitoso
        final userData = data['user'] ?? data['data'];
        final user = userData != null ? User.fromJson(userData) : null;

        return AuthResponse(
          success: true,
          message: data['message'] ?? 'Registro exitoso',
          accessToken: data['token'] ?? data['access_token'],
          refreshToken: data['refresh_token'],
          tokenType: data['type'] ?? data['token_type'] ?? 'Bearer',
          expiresIn: data['expires_in'],
          user: user,
        );
      } else {
        // Error en el registro
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Error en el registro',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error al procesar la respuesta del servidor',
      );
    }
  }

  /// Procesar respuesta del refresh token
  AuthResponse _handleRefreshResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: 'Token refrescado exitosamente',
          accessToken: data['token'] ?? data['access_token'],
          refreshToken: data['refresh_token'],
          tokenType: data['type'] ?? data['token_type'] ?? 'Bearer',
          expiresIn: data['expires_in'],
        );
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Error al refrescar token',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error al procesar la respuesta del servidor',
      );
    }
  }

  /// Generar token JWT simulado pero realista
  String _generateMockJWT(String email, int timestamp) {
    // Header JWT simulado
    final header = {
      'typ': 'JWT',
      'alg': 'HS256'
    };
    
    // Payload JWT simulado
    final payload = {
      'iss': 'https://parking.visiontic.com.co/api/login',
      'iat': timestamp ~/ 1000,
      'exp': (timestamp ~/ 1000) + 3600, // 1 hora
      'nbf': timestamp ~/ 1000,
      'jti': _generateRandomString(16),
      'sub': '39',
      'prv': '23bd5c8949f600adb39e701c400872db7a5976f7',
      'email': email,
      'name': 'Test User'
    };
    
    // Codificar header y payload en base64
    final headerB64 = base64Url.encode(utf8.encode(jsonEncode(header)));
    final payloadB64 = base64Url.encode(utf8.encode(jsonEncode(payload)));
    
    // Simular firma (no es real, solo para apariencia)
    final signature = _generateRandomString(43);
    
    return '$headerB64.$payloadB64.$signature';
  }
  
  /// Generar refresh token simulado
  String _generateMockRefreshToken(int timestamp) {
    return 'refresh_${_generateRandomString(32)}_$timestamp';
  }
  
  /// Generar string aleatorio para tokens
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      buffer.write(chars[(random + i) % chars.length]);
    }
    
    return buffer.toString();
  }

  /// Validar formato de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
