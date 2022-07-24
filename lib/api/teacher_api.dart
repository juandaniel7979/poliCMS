import 'dart:convert';
import 'dart:io';
import 'package:app/model/teacher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeacherApi{
  static Future<List<Teacher>> getTeacher(String query) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    // final url = Uri.parse('https://poli-cms.herokuapp.com/api/subcategoria/subcategorias?id=${id}');
    final url = Uri.parse('http://192.168.56.1:3002/api/user/profesoressv');
    final response = await http.get(url,
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    // print(response.body);
    if(response.statusCode==200){
      var jsonRes=json.decode(response.body);
      // print(jsonRes['profesores']);
      final List teachers =jsonRes['profesores'];

      return teachers.map((json)=> Teacher.fromJson(json)).where((teacher){
        final tituloSubcat = teacher.nombre.toLowerCase();
        final searchLower = query.toLowerCase();

        return tituloSubcat.contains(searchLower);
      }).toList();
    }else{
      throw Exception();
    }
  }
}

