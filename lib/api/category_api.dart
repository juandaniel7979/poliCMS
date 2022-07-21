import 'dart:convert';
import 'dart:io';
import 'package:app/main.dart';
import 'package:app/model/category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


//Api para consumir las categorias y transformarlas en objetos de tipo categoria
class CategoryApi{
  static Future<List<Category>> getCategory(String query,String id) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    // final url = Uri.parse('https://poli-cms.herokuapp.com/api/categoria/categorias?id=${id}');
    final url = Uri.parse('http://192.168.56.1:3002/api/categoria/categoria');
    // final url = Uri.parse('https://poli-cms.herokuapp.com/api/categoria/categoria');
    final response = await http.get(url,
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    if(response.statusCode==200){
      var jsonRes=json.decode(response.body);
      final List categories =jsonRes['categoria'];


      return categories.map((json)=> Category.fromJson(json)).where((category){
        final tituloSubcat = category.nombre.toLowerCase();
        final profeosorSubcat = category.nombre_profesor.toLowerCase();
        final searchLower = query.toLowerCase();

        return tituloSubcat.contains(searchLower) || profeosorSubcat.contains(searchLower);
      }).toList();
    }else{
      throw Exception();
    }
  }
}

