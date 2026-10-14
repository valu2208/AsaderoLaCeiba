class UserModel {
  final String? id;
  final String nombre;
  final String email;
  final String password;
  final String rol;

  UserModel({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
    this.rol = 'usuario',
  });

  // Getter para verificar si el usuario es administrador
  bool get esAdmin => rol.toLowerCase() == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rol: json['rol'] ?? 'usuario',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
      'rol': rol,
    };
  }
}