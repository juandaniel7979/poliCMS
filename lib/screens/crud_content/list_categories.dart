import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/screens/crud_content/adds/add_category.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// String id='';
// String name='';
// String email='';
class ListCategories extends StatefulWidget {
  static const route = '/ListCategories';

  final String id;
  final String email;
  final String name;

  ListCategories({required this.id, required this.email, required this.name});

  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  late List data = [];
  Future<List> _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url='https://poli-cms.herokuapp.com/api/categoria/categorias?id=${widget.id}';
    // print(url);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      drawer: MainDrawer(id:widget.id,email: widget.email, name: widget.name),
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
                        name: widget.name,
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
              ]),
              // EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              // color: Colors.white,
              // elevation: 5.0,
              // child: Center(
              //     child: Text('id: '+data[index]['id_categoria']+'\nCategoria: '+data[index]['nombre']+'\nDescripcion: '+data[index]['descripcion'])
              // ),
            ),
          );
        },
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.green,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              onTap: () {
                _getData();
              },
              child: Icon(Icons.copy),
              label: 'Copiar'),
          SpeedDialChild(
              onTap: () {
                // Navigator.pushReplacementNamed(
                //     context, YoutubePlayerDemoApp.routeName);
              },
              child: Icon(Icons.video_collection),
              label: 'Copiar'),
          SpeedDialChild(
              onTap: () {},
              child: Icon(Icons.upload),
              label: 'Subir contenido'),
          SpeedDialChild(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCategory(id: widget.id,name: widget.name,email: widget.email)));
              },
              child: Icon(Icons.add),
              label: 'Add category')
        ],
      ),
    );
  }
}
