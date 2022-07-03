import 'dart:io';

import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/search_widget.dart';
import 'package:app/main.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:app/screens/crud_content/adds/add_subcategory.dart';
import 'package:app/screens/crud_content/detail_content.dart';
import 'package:app/screens/crud_content/edit_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  late List subcategorias =[];
  late List data= [];
  String query = '';
  Future<List> _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url='https://poli-cms.herokuapp.com/api/subcategoria/subcategorias?id=${widget.id_categoria}';
    // print(url);
    var token= sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(url),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
    );
    // print(response.body);
    var res = jsonDecode(response.body);
    // print(res['subcategoria']);


    this.setState(() {
      data = res['subcategoria'];
      subcategorias=data;
      print('data');
      print(data.toString());
      print(subcategorias[0]['nombre']);
    });

    return res['subcategoria'];
  }

  Future _DeleteElement( num) async {
    var datos= {"id":num};
    final response = await http.post(
        Uri.http("192.168.56.1", "/PPI_ANDROID/crud/deleteData.php"), body:json.encode(datos));

    // data = json.decode(response.body);
    this.setState(() {
      data = json.decode(response.body);
    });
    // print(data[1]["nombre"]);

  }

  showAlertDialog(BuildContext context,String num) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        _DeleteElement(num);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar"),
      content: Text("Está seguro que desea eliminar este elemento?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        title: Text(widget.categoria),
      ),
      drawer: MainDrawer(id:widget.id,email:widget.email,name: widget.name),
      body:new ListView.builder(
        itemCount: subcategorias ==null ? 0 :subcategorias.length,
        itemBuilder: (BuildContext context,int index){
          return new GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailContent(
                id:widget.id,
                id_subcategoria:subcategorias[index]['_id'],
                email: widget.email,
                name: widget.name,
                subcategoria: subcategorias[index]['nombre'],
                descripcion:subcategorias[index]['descripcion']
                ,)
              ));
            },
            child: Card(
              child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.album),
                      title: Text('Subcategoria: '+data[index]['nombre'],
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text('Descripcion: '+data[index]['descripcion']),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('EDIT'),
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>EditSubcategory(id: data[index]['id_subcategoria'], nombre: data[index]['nombre'], descripcion: data[index]['descripcion'])));
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
                                    // _DeleteElement(data[index]['id_subcategoria']);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,email: widget.email,name: widget.name,categoria: widget.categoria,descripcion:widget.descripcion))
                                    // );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          // showAlertDialog(context,data[index]['id_subcategoria']
                          // );
                          // },
                        ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  // ElevatedButton(onPressed: (){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=> DownloadImages(id: widget.id)));
                  // }, child: Text('Ver imagenes'))
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
              onTap: (){
                _getData();
              },
              child: Icon(Icons.video_collection),
              label: 'Copiar'
          ),
          SpeedDialChild(
              onTap: (){
                // pickAndUploadFile();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => AddContent(id:widget.id,id_subcategoria:widget.))
                // );
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

  void searchSubcategory(String query){
    final subcategoria = data.where((subcat){
      final tituloSubcat = subcat['titulo'].toString().toLowerCase();
      final searchLower = query.toLowerCase();

      return tituloSubcat.contains(searchLower);
    }).toList();

    setState(() {
      this.query =query;
      this.subcategorias = subcategoria;
    });
  }

//
//   Widget buildSearch()=>SearchWidget(
//       text: query,
//       onChanged: onChanged,
//       hintText: 'Titulo de la subcategoria');
//
}


