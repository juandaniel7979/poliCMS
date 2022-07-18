import 'dart:convert';
import 'dart:io';
import 'package:app/model/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoryApi{
  static Future<List<Subcategory>> getSubcategory(String query,id) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    final url = Uri.parse('https://poli-cms.herokuapp.com/api/subcategoria/subcategorias?id=${id}');
    final response = await http.get(url,
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});

    if(response.statusCode==200){
      var jsonRes=json.decode(response.body);
      final List subcategories =jsonRes['subcategoria'];

      return subcategories.map((json)=> Subcategory.fromJson(json)).where((subcat){
        final tituloSubcat = subcat.nombre.toLowerCase();
        final searchLower = query.toLowerCase();

        return tituloSubcat.contains(searchLower);
      }).toList();
    }else{
      throw Exception();
    }
  }
}

