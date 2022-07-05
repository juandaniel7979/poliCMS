import 'dart:async';
import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/search_widget.dart';
import 'package:app/api/subcategory_api.dart';
import 'package:app/screens/crud_content/adds/add_subcategory.dart';
import 'package:app/screens/crud_content/detail_content.dart';
import 'package:app/screens/crud_content/edit_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/subcategory.dart';

// String id='';
// String name='';
// String email='';


class DetailContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}



class ListSubcategories extends StatefulWidget{
  static const route = '/Detail-subcategory';

  final String id;
  final String id_categoria;
  final String email;
  final String name;
  final String categoria;
  final String descripcion;

  ListSubcategories({required this.id,required this.id_categoria, required this.email,required this.name,required this.categoria,required this.descripcion});

  _ListSubcategoriesState createState() => _ListSubcategoriesState();
}

class _ListSubcategoriesState extends State<ListSubcategories> {

  late List<Subcategory> subcategories =[];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    this.init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final subcategories = await SubcategoryApi.getSubcategory(query);
    setState(() {
      this.subcategories=subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria),
      ),
      drawer: MainDrawer(id:widget.id,email:widget.email,name: widget.name),
      body:Column(
        children: [
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: subcategories ==null ? 0 :subcategories.length,
              itemBuilder: (BuildContext context,int index){
                return new GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailContent(
                      id:widget.id,
                      id_subcategoria:subcategories[index].id,
                      email: widget.email,
                      name: widget.name,
                      subcategoria: subcategories[index].nombre,
                      descripcion:subcategories[index].descripcion
                      ,)
                    ));
                  },
                  child: Card(
                    child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.album),
                            title: Text('Subcategoria: '+subcategories[index].nombre,
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text('Descripcion: '+subcategories[index].descripcion),
                          ),
                        ]),
                  ),
                );

              },
            ),
          ),
        ]
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.green,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              onTap: (){
                // _getData();
              },
              child: Icon(Icons.video_collection),
              label: 'Copiar'
          ),
          SpeedDialChild(
              onTap: (){

              },
              child: Icon(Icons.upload),
              label: 'Subir contenido'
          ),
          SpeedDialChild(
              onTap: (){
                Navigator.push(
                    context,
                    // MaterialPageRoute(builder: (context) => AddSubcategory(id:widget.id))
                    MaterialPageRoute(builder: (context) => AddSubcategory(id:widget.id,id_categoria:widget.id_categoria,email: widget.email,name: widget.name,categoria: widget.categoria,descripcion:widget.descripcion))
                );
              },
              child: Icon(Icons.add),
              label: 'Añadir subcategoria'
          )
        ],

      ),
    );
  }


  Widget buildSearch()=>SearchWidget(
      text: query,
      onChanged: searchSubcategory,
      hintText: 'Titulo de la subcategoria');

  void searchSubcategory(String query)async =>debounce(() async {
   final subcategorias = await SubcategoryApi.getSubcategory(query);

   if(!mounted)return;
    setState(() {
      this.query =query;
      this.subcategories = subcategorias;
    });
  });
  // void searchSubcategory(String query){
  //   final subcategoria = data.where((subcat){
  //     final tituloSubcat = subcat['titulo'].toString().toLowerCase();
  //     final searchLower = query.toLowerCase();
  //
  //     return tituloSubcat.contains(searchLower);
  //   }).toList();
  //
  //   setState(() {
  //     this.query =query;
  //     this.subcategorias = subcategoria;
  //   });
  // }



}


