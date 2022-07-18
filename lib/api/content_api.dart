import 'dart:convert';
import 'dart:io';
import 'package:app/model/content.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContentApi{
  static Future<List<Content>> getContent(String query,String id) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    final url = Uri.parse('https://poli-cms.herokuapp.com/api/contenido/contenidos?id=${id}');
    final response = await http.get(url,
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});

    print(response.body);
    if(response.statusCode==200){
      var jsonRes=json.decode(response.body);
      final List contents =jsonRes['contenido'];


      return contents.map((json)=> Content.fromJson(json)).where((category){
        final tituloSubcat = category.nombre.toLowerCase();
        final searchLower = query.toLowerCase();

        return tituloSubcat.contains(searchLower);
      }).toList();
    }else{
      throw Exception();
    }
  }
}

