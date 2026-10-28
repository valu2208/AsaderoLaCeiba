class UserModel {
  final String? id;
  final String nombre;
  final String email;
  final String password;
  final String rol;
  final String? avatar;
  final String telefono;

  UserModel({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
    this.rol = 'usuario',
    this.avatar,
    this.telefono = '',
  });

  bool get esAdmin => rol.toLowerCase() == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rol: json['rol'] ?? 'usuario',
      telefono: json['telefono'] ?? '',
      avatar:
          json['avatar']?.toString() ??
          json['foto_perfil']?.toString() ??
          json['foto']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
      'rol': rol,
      'telefono': telefono,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
