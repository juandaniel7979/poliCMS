import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poli_gestor_contenidos/models/Category.dart';
import 'package:poli_gestor_contenidos/models/tags_model.dart';

// TODO: Corregir url con ip local

class CategoryProvider with ChangeNotifier {

// final _APIKEY = 'eae7a8c6d2f840d1a2595dafe0a195df';
  final _baseURL = 'http://192.168.56.1:3001';
  String _selectedTag = 'business';
  List<String> selectedTags = [];
  List <Categoria> categorias = [];
  late Categoria selectedCategory;
  bool _isLoading = true;
  bool isSaving= false;
  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  List <Tag> tags = [
    Tag( FontAwesomeIcons.building, 'Negocios'),
    Tag( FontAwesomeIcons.tv, 'Entretenimiento'),
    Tag( FontAwesomeIcons.addressCard, 'General'),
    Tag( FontAwesomeIcons.headSideVirus, 'Salud'),
    Tag( FontAwesomeIcons.vials, 'Ciencias'),
    Tag( FontAwesomeIcons.volleyball, 'Deportes'),
    Tag( FontAwesomeIcons.memory, 'Tecnologia'),    
  ];

  Map<String,List<Categoria>> categoriesByTag = {};
  
  CategoryProvider() {
    getTopCategorias();
    tags.forEach((item) {
      categoriesByTag[item.name] = List<Categoria>.empty(growable: true);
    });
    // getCategoriesPorTag( _selectedTag );
  } 

  
  bool get isLoading => _isLoading;

  String get selectedTag => _selectedTag;

  set selectedTag( String valor ) {
    _selectedTag = valor;
    
    _isLoading = true;
    // getCategoriesPorTag( valor );
    notifyListeners();
  }

  List<Categoria> get getCategoriasPorTag => categoriesByTag[selectedTag]!;

  getTopCategorias() async {
    final url = '${_baseURL}/api/categoria';
    final resp = await http.get(Uri.parse(url)).timeout(const Duration(milliseconds: 8000));

    final categoryResponse = Category.fromJson( resp.body );
    
    categorias.addAll( categoryResponse.categorias);
    notifyListeners();
  }

  // getCategoriesPorTag( String tag ) async {
  //   if( categoriesByTag[tag]!.isNotEmpty ) {
  //     _isLoading = false;
  //     notifyListeners();
  //     return categoriesByTag[tag];
  //   }
  //   final url = '$_baseURL/top-headlines?tag=$tag';
  //   final resp = await http.get(Uri.parse(url));
  //   final categoryResponse = Category.fromJson( resp.body );
  //   categoriesByTag[tag]!.addAll( categoryResponse.categorias );
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future saveOrCreateCategoria( Categoria categoria ) async {
    isSaving = true;
    notifyListeners();

    if( categoria.id == null) {
      await createCategory(categoria);
    }else{
      print('Actualizar');
      await updateCategory(categoria);

    }

    isSaving = false;
    notifyListeners();
  }

  Future updateCategory( Categoria categoria ) async {
    final Map<String,dynamic> categoryData = {
        'nombre': categoria.nombre,
        'descripcion': categoria.descripcion,
        'estado':  categoria.estado,
        'imagen': categoria.imagen
    };

    final url = Uri.parse( '${_baseURL}/api/categoria/${categoria.id}');
    final resp = await http.put(url, body: json.encode(categoryData),
    headers: {
    "Content-Type": "application/json", 
    'x-token': await storage.read(key: 'token') ?? ''
    }
    ,).timeout(Duration(milliseconds: 8000));
    final decodedData = resp.body;
    // categoria.forEach((element) {
    //   if(element.id == categoria.id){
    //     element.name = categoria.name;
    //   }
    // });

    // final index = categorias.indexWhere((element) => element.id == categoria.id);
    // categorias[index] = categoria;
    
    return categoria.id;
  }


  Future createCategory( Categoria categoria ) async {
    final Map<String,dynamic> categoryData = {
        'nombre': categoria.nombre,
        'descripcion': categoria.descripcion,
        'estado':  categoria.estado,
        'imagen': categoria.imagen
    };
    print(categoria.estado);
    final url = Uri.parse( '${_baseURL}/api/categoria');
    try {
    final resp = await http.post(url,
    body: json.encode(categoryData),
    headers: {
      "Content-Type": "application/json", 
      'x-token': await storage.read(key: 'token') ?? ''
    }
    ).timeout(const Duration(seconds: 30));
    print(resp.body);  
    categorias.add(categoria);
    
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    if( decodedResp.containsKey('id_profesor')) {
      return null;
    }else{
      print(decodedResp['errors'][0]);
      return 'error';
    }
      
    } catch (e) {
      print(e);
      isSaving = false;
    }
  }

  
  void updateSelectedCategoryImage (String path) async {

    selectedCategory.imagen = path; 
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if ( newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlcmims3m/image/upload?upload_preset=xysn0jp7');

    final imageUploadRequest = http.MultipartRequest( 'POST', url );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body);
      return null;
    }
    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
}



}