import 'dart:convert';
import 'dart:io';
import 'package:app/model/category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryApi{
  static Future<List<Category>> getSubcategory(String query) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    final url = Uri.parse('https://poli-cms.herokuapp.com/api/subcategoria/categoria');
    final response = await http.get(url,
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});

    if(response.statusCode==200){
      var jsonRes=json.decode(response.body);
      final List categories =jsonRes['subcategoria'];

      return categories.map((json)=> Category.fromJson(json)).where((category){
        final tituloSubcat = category.nombre.toLowerCase();
        final searchLower = query.toLowerCase();

        return tituloSubcat.contains(searchLower);
      }).toList();
    }else{
      throw Exception();
    }
  }
}

