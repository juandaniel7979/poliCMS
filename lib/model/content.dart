class Content {
  final String id;
  final String id_subcategoria;
  final String id_profesor;
  final String nombre;
  final String descripcion;
  final String descripcion_corta;
  final int estado;
  const Content ({
    required this.id,
    required this.id_profesor,
    required this.id_subcategoria,
    required this.nombre,
    required this.descripcion,
    required this.descripcion_corta,
    required this.estado,
  });


  factory Content.fromJson(Map<String,dynamic> json) =>Content(
    id: json['_id'],
    id_profesor: json['id_profesor'],
    id_subcategoria: json['id_subcategoria'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    descripcion_corta: json['descripcion_corta'],
    estado: json['estado'],
  );


}

