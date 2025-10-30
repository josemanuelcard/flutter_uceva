import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

/// Servicio de almacenamiento local que maneja datos seguros y no seguros
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Instancia de SharedPreferences para datos no sensibles
  SharedPreferences? _prefs;
  
  // Instancia de FlutterSecureStorage para datos sensibles
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Inicializar el servicio de almacenamiento
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== DATOS NO SENSIBLES (SharedPreferences) ==========

  /// Guardar nombre del usuario
  Future<bool> saveUserName(String name) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('user_name', name);
  }

  /// Obtener nombre del usuario
  Future<String?> getUserName() async {
    if (_prefs == null) await init();
    return _prefs!.getString('user_name');
  }

  /// Guardar email del usuario
  Future<bool> saveUserEmail(String email) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('user_email', email);
  }

  /// Obtener email del usuario
  Future<String?> getUserEmail() async {
    if (_prefs == null) await init();
    return _prefs!.getString('user_email');
  }

  /// Guardar tema de la aplicación
  Future<bool> saveTheme(String theme) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('app_theme', theme);
  }

  /// Obtener tema de la aplicación
  Future<String?> getTheme() async {
    if (_prefs == null) await init();
    return _prefs!.getString('app_theme') ?? 'light';
  }

  /// Guardar idioma de la aplicación
  Future<bool> saveLanguage(String language) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('app_language', language);
  }

  /// Obtener idioma de la aplicación
  Future<String?> getLanguage() async {
    if (_prefs == null) await init();
    return _prefs!.getString('app_language') ?? 'es';
  }

  /// Guardar datos completos del usuario (no sensibles)
  Future<bool> saveUserData(User user) async {
    if (_prefs == null) await init();
    
    final userData = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'avatar': user.avatar,
      'created_at': user.createdAt?.toIso8601String(),
      'updated_at': user.updatedAt?.toIso8601String(),
    };

    return await _prefs!.setString('user_data', jsonEncode(userData));
  }

  /// Obtener datos completos del usuario
  Future<User?> getUserData() async {
    if (_prefs == null) await init();
    
    final userDataString = _prefs!.getString('user_data');
    if (userDataString == null) return null;

    try {
      final userData = jsonDecode(userDataString) as Map<String, dynamic>;
      
      // Convertir fechas de string a DateTime
      if (userData['created_at'] != null) {
        userData['created_at'] = DateTime.parse(userData['created_at']);
      }
      if (userData['updated_at'] != null) {
        userData['updated_at'] = DateTime.parse(userData['updated_at']);
      }

      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // ========== DATOS SENSIBLES (FlutterSecureStorage) ==========

  /// Guardar token de acceso
  Future<bool> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(key: 'access_token', value: token);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener token de acceso
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: 'access_token');
    } catch (e) {
      return null;
    }
  }

  /// Guardar token de refresco
  Future<bool> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: 'refresh_token', value: token);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener token de refresco
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: 'refresh_token');
    } catch (e) {
      return null;
    }
  }

  /// Guardar tipo de token
  Future<bool> saveTokenType(String tokenType) async {
    try {
      await _secureStorage.write(key: 'token_type', value: tokenType);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener tipo de token
  Future<String?> getTokenType() async {
    try {
      return await _secureStorage.read(key: 'token_type');
    } catch (e) {
      return null;
    }
  }

  /// Guardar tiempo de expiración del token
  Future<bool> saveTokenExpiration(int expiresIn) async {
    try {
      final expirationTime = DateTime.now().add(Duration(seconds: expiresIn));
      await _secureStorage.write(
        key: 'token_expiration', 
        value: expirationTime.toIso8601String(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener tiempo de expiración del token
  Future<DateTime?> getTokenExpiration() async {
    try {
      final expirationString = await _secureStorage.read(key: 'token_expiration');
      if (expirationString == null) return null;
      return DateTime.parse(expirationString);
    } catch (e) {
      return null;
    }
  }

  /// Verificar si el token está expirado
  Future<bool> isTokenExpired() async {
    final expiration = await getTokenExpiration();
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }

  // ========== MÉTODOS DE CONVENIENCIA ==========

  /// Guardar todos los datos de autenticación
  Future<bool> saveAuthData({
    required User user,
    required String accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
  }) async {
    try {
      // Guardar datos no sensibles
      await saveUserData(user);
      
      // Guardar datos sensibles
      await saveAccessToken(accessToken);
      if (refreshToken != null) {
        await saveRefreshToken(refreshToken);
      }
      if (tokenType != null) {
        await saveTokenType(tokenType);
      }
      if (expiresIn != null) {
        await saveTokenExpiration(expiresIn);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    // Verificar si el token no está expirado
    return !(await isTokenExpired());
  }

  /// Obtener información de autenticación
  Future<Map<String, dynamic>> getAuthInfo() async {
    final token = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final tokenType = await getTokenType();
    final expiration = await getTokenExpiration();
    final user = await getUserData();

    return {
      'hasToken': token != null,
      'token': token,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiration': expiration,
      'isExpired': await isTokenExpired(),
      'user': user,
    };
  }

  /// Limpiar todos los datos de autenticación
  Future<bool> clearAuthData() async {
    try {
      // Limpiar datos sensibles
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      await _secureStorage.delete(key: 'token_type');
      await _secureStorage.delete(key: 'token_expiration');

      // Limpiar datos no sensibles
      if (_prefs == null) await init();
      await _prefs!.remove('user_data');
      await _prefs!.remove('user_name');
      await _prefs!.remove('user_email');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Limpiar todos los datos de la aplicación
  Future<bool> clearAllData() async {
    try {
      // Limpiar datos sensibles
      await _secureStorage.deleteAll();

      // Limpiar datos no sensibles
      if (_prefs == null) await init();
      await _prefs!.clear();

      return true;
    } catch (e) {
      return false;
    }
  }
}
