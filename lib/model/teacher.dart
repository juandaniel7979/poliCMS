class Teacher {
  final String id;
  final String nombre;
  final String correo;
  final int estado;


const Teacher ({
  required this.id,
  required this.nombre,
  required this.correo,
  required this.estado,
});

factory Teacher.fromJson(Map<String,dynamic> json) =>Teacher(
    id: json['id'],
    nombre: json['nombre'],
    correo: json['correo'],
    estado: json['estado'],
);


}

