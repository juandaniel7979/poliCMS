class Category {
  final String id;
  final String id_profesor;
  final String nombre_profesor;
  final String nombre;
  final String descripcion;
  final int estado;


  const Category ({
    required this.id,
    required this.id_profesor,
    required this.nombre_profesor,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory Category.fromJson(Map<String,dynamic> json) =>Category(
    id: json['categoria']['_id'],
    id_profesor: json['categoria']['id_profesor'],
    nombre: json['categoria']['nombre'],
    descripcion: json['categoria']['descripcion'],
    estado: json['categoria']['estado'],
    nombre_profesor: json['profesor']['nombre']+' '+json['profesor']['nombre_2']+' '+json['profesor']['apellido']+' '+json['profesor']['apellido_2'],
  );


}

