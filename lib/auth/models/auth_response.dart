import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'auth_response.g.dart';

/// Modelo de respuesta de autenticación que incluye el token y datos del usuario
@JsonSerializable()
class AuthResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final User? user;

  const AuthResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  /// Constructor desde JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) => 
      _$AuthResponseFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  /// Constructor de copia con campos opcionales
  AuthResponse copyWith({
    bool? success,
    String? message,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    User? user,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      user: user ?? this.user,
    );
  }

  /// Verificar si la respuesta es exitosa y tiene token
  bool get isSuccess => success && accessToken != null && accessToken!.isNotEmpty;

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, hasToken: ${accessToken != null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.success == success &&
        other.message == message &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        message.hashCode ^
        accessToken.hashCode ^
        refreshToken.hashCode;
  }
}
