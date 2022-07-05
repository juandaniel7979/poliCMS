class Category {
  final String id;
  final String id_profesor;
  final String nombre;
  final String descripcion;
  final int estado;


  const Category ({
    required this.id,
    required this.id_profesor,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory Category.fromJson(Map<String,dynamic> json) =>Category(
    id: json['_id'],
    id_profesor: json['id_profesor'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    estado: json['estado'],
  );


}

