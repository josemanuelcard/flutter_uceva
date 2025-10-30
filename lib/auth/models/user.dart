import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Modelo de datos para representar un usuario
@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructor desde JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Constructor de copia con campos opcionales
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ phone.hashCode;
  }
}
