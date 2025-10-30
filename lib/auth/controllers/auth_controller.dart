import 'package:flutter/foundation.dart';
import '../models/auth_state.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

/// Controlador de autenticación que maneja el estado y la lógica de negocio
class AuthController extends ChangeNotifier {
  // Servicios
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  // Estado actual
  AuthState _state = AuthState.initial();

  // Getters
  AuthState get state => _state;
  bool get isAuthenticated => _state.isAuthenticated;
  bool get isLoading => _state.isLoading;
  bool get hasError => _state.hasError;
  User? get user => _state.user;
  String? get errorMessage => _state.errorMessage;
  String? get accessToken => _state.accessToken;

  /// Inicializar el controlador y verificar autenticación existente
  Future<void> init() async {
    try {
      // Inicializar servicios de almacenamiento
      await _storageService.init();

      // Verificar si hay una sesión activa
      final isAuth = await _storageService.isAuthenticated();
      
      if (isAuth) {
        // Cargar datos del usuario desde el almacenamiento local
        final user = await _storageService.getUserData();
        final token = await _storageService.getAccessToken();
        
        if (user != null && token != null) {
          _state = AuthState.success(
            user: user,
            accessToken: token,
          );
          notifyListeners();
        } else {
          // Datos inconsistentes, limpiar
          await _storageService.clearAuthData();
          _state = AuthState.initial();
          notifyListeners();
        }
      } else {
        _state = AuthState.initial();
        notifyListeners();
      }
    } catch (e) {
      _state = AuthState.error('Error al inicializar: ${e.toString()}');
      notifyListeners();
    }
  }

  /// Realizar login con email y contraseña
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      // Actualizar estado a loading
      _state = AuthState.loading();
      notifyListeners();

      // Realizar login
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.isSuccess && response.user != null) {
        // Login exitoso
        _state = AuthState.fromAuthResponse(response);
        
        // Guardar datos en almacenamiento local
        await _storageService.saveAuthData(
          user: response.user!,
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken,
          tokenType: response.tokenType,
          expiresIn: response.expiresIn,
        );

        notifyListeners();
      } else {
        // Error en el login
        _state = AuthState.error(response.message);
        notifyListeners();
      }
    } catch (e) {
      _state = AuthState.error('Error inesperado: ${e.toString()}');
      notifyListeners();
    }
  }

  /// Registrar un nuevo usuario
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      // Actualizar estado a loading
      _state = AuthState.loading();
      notifyListeners();

      // Realizar registro
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response.isSuccess && response.user != null) {
        // Registro exitoso
        _state = AuthState.fromAuthResponse(response);
        
        // Guardar datos en almacenamiento local
        await _storageService.saveAuthData(
          user: response.user!,
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken,
          tokenType: response.tokenType,
          expiresIn: response.expiresIn,
        );

        notifyListeners();
      } else {
        // Error en el registro
        _state = AuthState.error(response.message);
        notifyListeners();
      }
    } catch (e) {
      _state = AuthState.error('Error inesperado: ${e.toString()}');
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    try {
      // Actualizar estado a loading
      _state = AuthState.loading();
      notifyListeners();

      // Intentar cerrar sesión en el servidor si hay token
      if (_state.accessToken != null) {
        await _authService.logout(_state.accessToken!);
      }

      // Limpiar datos locales
      await _storageService.clearAuthData();

      // Actualizar estado a logged out
      _state = AuthState.loggedOut();
      notifyListeners();
    } catch (e) {
      // Aunque haya error, limpiar datos locales
      await _storageService.clearAuthData();
      _state = AuthState.loggedOut();
      notifyListeners();
    }
  }

  /// Refrescar token de acceso
  Future<void> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      
      if (refreshToken == null) {
        // No hay refresh token, hacer logout
        await logout();
        return;
      }

      // Intentar refrescar el token
      final response = await _authService.refreshToken(refreshToken);

      if (response.isSuccess && response.accessToken != null) {
        // Token refrescado exitosamente
        final user = await _storageService.getUserData();
        
        if (user != null) {
          _state = AuthState.success(
            user: user,
            accessToken: response.accessToken!,
            refreshToken: response.refreshToken,
          );

          // Actualizar almacenamiento
          await _storageService.saveAccessToken(response.accessToken!);
          if (response.refreshToken != null) {
            await _storageService.saveRefreshToken(response.refreshToken!);
          }
          if (response.expiresIn != null) {
            await _storageService.saveTokenExpiration(response.expiresIn!);
          }

          notifyListeners();
        } else {
          // No se pudo obtener usuario, hacer logout
          await logout();
        }
      } else {
        // Error al refrescar token, hacer logout
        await logout();
      }
    } catch (e) {
      // Error al refrescar token, hacer logout
      await logout();
    }
  }

  /// Obtener información actualizada del usuario
  Future<void> refreshUserInfo() async {
    try {
      if (_state.accessToken == null) return;

      final user = await _authService.getUserInfo(_state.accessToken!);
      
      if (user != null) {
        // Actualizar datos del usuario
        _state = _state.copyWith(user: user);
        
        // Guardar datos actualizados
        await _storageService.saveUserData(user);
        
        notifyListeners();
      }
    } catch (e) {
      // Error al obtener información del usuario
      // No cambiar el estado, solo log del error
      if (kDebugMode) {
        print('Error al actualizar información del usuario: $e');
      }
    }
  }

  /// Limpiar mensaje de error
  void clearError() {
    if (_state.hasError) {
      _state = _state.copyWith(
        status: AuthStatus.initial,
        errorMessage: null,
      );
      notifyListeners();
    }
  }

  /// Verificar si el token necesita ser refrescado
  Future<bool> needsTokenRefresh() async {
    return await _storageService.isTokenExpired();
  }

  /// Obtener información de autenticación para la vista de evidencia
  Future<Map<String, dynamic>> getAuthInfo() async {
    return await _storageService.getAuthInfo();
  }

  /// Verificar si hay datos almacenados localmente
  Future<bool> hasStoredData() async {
    final authInfo = await getAuthInfo();
    return authInfo['hasToken'] == true || authInfo['user'] != null;
  }

}
