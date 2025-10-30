import 'user.dart';
import 'auth_response.dart';

/// Estados posibles de la autenticación
enum AuthStatus {
  initial,    // Estado inicial
  loading,    // Cargando (enviando solicitud)
  success,    // Éxito (token recibido)
  error,      // Error en la autenticación
  loggedOut,  // Usuario deslogueado
}

/// Modelo de estado de autenticación
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? accessToken;
  final String? refreshToken;
  final bool isAuthenticated;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.accessToken,
    this.refreshToken,
    this.isAuthenticated = false,
  });

  /// Estado inicial
  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      isAuthenticated: false,
    );
  }

  /// Estado de carga
  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
      isAuthenticated: false,
    );
  }

  /// Estado de éxito
  factory AuthState.success({
    required User user,
    required String accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      status: AuthStatus.success,
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
      isAuthenticated: true,
    );
  }

  /// Estado de error
  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
      isAuthenticated: false,
    );
  }

  /// Estado de usuario deslogueado
  factory AuthState.loggedOut() {
    return const AuthState(
      status: AuthStatus.loggedOut,
      isAuthenticated: false,
    );
  }

  /// Constructor desde AuthResponse
  factory AuthState.fromAuthResponse(AuthResponse response) {
    if (response.isSuccess && response.user != null) {
      return AuthState.success(
        user: response.user!,
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken,
      );
    } else {
      return AuthState.error(response.message);
    }
  }

  /// Constructor de copia con campos opcionales
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? accessToken,
    String? refreshToken,
    bool? isAuthenticated,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  /// Verificar si está cargando
  bool get isLoading => status == AuthStatus.loading;

  /// Verificar si hay error
  bool get hasError => status == AuthStatus.error;

  /// Verificar si es exitoso
  bool get isSuccess => status == AuthStatus.success;

  /// Verificar si está deslogueado
  bool get isLoggedOut => status == AuthStatus.loggedOut;

  @override
  String toString() {
    return 'AuthState(status: $status, isAuthenticated: $isAuthenticated, hasUser: ${user != null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.isAuthenticated == isAuthenticated;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        user.hashCode ^
        errorMessage.hashCode ^
        accessToken.hashCode ^
        refreshToken.hashCode ^
        isAuthenticated.hashCode;
  }
}
