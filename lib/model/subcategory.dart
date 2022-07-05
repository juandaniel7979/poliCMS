class Subcategory {
  final String id;
  final String id_categoria;
  final String nombre;
  final String descripcion;
  final int estado;


const Subcategory ({
  required this.id,
  required this.id_categoria,
  required this.nombre,
  required this.descripcion,
  required this.estado,
});

factory Subcategory.fromJson(Map<String,dynamic> json) =>Subcategory(
    id: json['_id'],
    id_categoria: json['id_categoria'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    estado: json['estado'],
);


}

