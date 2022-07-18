class Subcategory {
  final String id;
  final String id_categoria;
  final String nombre;
  final String descripcion;
  final String url;
  final String id_profesor;
  final int estado;


const Subcategory ({
  required this.id,
  required this.id_categoria,
  required this.nombre,
  required this.descripcion,
  required this.url,
  required this.id_profesor,
  required this.estado,
});

factory Subcategory.fromJson(Map<String,dynamic> json) =>Subcategory(
    id: json['_id'],
    id_profesor: json['id_profesor'],
    id_categoria: json['id_categoria'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    url: json['url'],
    estado: json['estado'],
);


}

