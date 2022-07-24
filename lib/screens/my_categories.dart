import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/main.dart';
import 'package:app/main.dart';
import 'package:app/screens/crud_content/adds/add_category.dart';
import 'package:app/screens/crud_content/edits/edit_categories.dart';
import 'package:app/screens/crud_content/edits/edit_subcategories.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// String id='';
// String nombre='';
// String email='';
class MyCategories extends StatefulWidget {
  static const route = '/MyCategories';

  final String id;
  final String email;
  final String nombre;

  MyCategories({required this.id, required this.email, required this.nombre});

  _MyCategoriesState createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  late var data = [];
  Future<List> _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url='https://poli-cms.herokuapp.com/api/categoria/categorias?id=${widget.id}';
    var token= sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(url),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
    );
    var res = jsonDecode(response.body);
    this.setState(() {
      data = res['categoria'];
    });

    return res['categoria'];
  }

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  Future _DeleteElement( id_categoria) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    var datos= {"id":id_categoria};
    final response = await http.put(
        Uri.parse("https://poli-cms.herokuapp.com/api/categoria/borrar"),
        body:json.encode(datos),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);

    // print(data[1]["nombre"]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(25,104,68, 1),
        title: Text('Mis tematicas'),
      ),
      drawer: MainDrawer(id:widget.id,email: widget.email, nombre: widget.nombre),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListSubcategories(
                            id: widget.id,
                            id_categoria:data[index]['_id'],
                            email: widget.email,
                            nombre: widget.nombre,
                            categoria: data[index]['nombre'],
                            descripcion: data[index]['descripcion'],
                          )));
            },
            child: Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(
                    'Categoria: ' + data[index]['nombre'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Descripcion: ' + data[index]['descripcion']),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('EDIT',style: TextStyle(color: Color.fromRGBO(25,104,68, 1)),),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>
                                EditCategory(id:widget.id,nombre:widget.nombre,email: widget.email,id_categoria: data[index]['_id'],nombre_categoria: data[index]['nombre'], descripcion: data[index]['descripcion'])));
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('DELETE',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                              title: const Text('Eliminar'),
                              content: const Text('Está seguro que desea eliminar este elemento?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  // onPressed: () => Navigator.pop(context, 'OK'),
                                  onPressed: () {
                                    _DeleteElement(data[index]['_id']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyCategories(id:widget.id,email: widget.email,nombre: widget.nombre))
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Color.fromRGBO(25,104,68,1),
        onPressed: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddCategory(id: widget.id,nombre: widget.nombre,email: widget.email)));
        },
        child: Icon(Icons.add),
      )
    );
  }

  Future openBrowseURL({required String url,})async{
    if(await canLaunchUrl(Uri.parse(url))){
        await launchUrl(Uri.parse(url),);
    }
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: Text('Agregar categoria'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Ingresa el nombre de la categoria"
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Ingresa el nombre de la categoria"
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){

            },
            child:Text('SUBMIT'))
      ],
    ),
  );



}
