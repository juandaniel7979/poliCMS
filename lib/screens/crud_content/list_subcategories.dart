import 'dart:async';
import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/search_widget.dart';
import 'package:app/api/subcategory_api.dart';
import 'package:app/screens/crud_content/List_content.dart';
import 'package:app/screens/crud_content/adds/add_subcategory.dart';
import 'package:app/screens/crud_content/detail_content.dart';
import 'package:app/screens/crud_content/edit_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import '../../model/subcategory.dart';

// String id='';
// String nombre='';
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
  final String nombre;
  final String categoria;
  final String descripcion;

  ListSubcategories({required this.id,required this.id_categoria, required this.email,required this.nombre,required this.categoria,required this.descripcion});

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
    final subcategories = await SubcategoryApi.getSubcategory(query,widget.id_categoria);
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
      drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
      body: Column(
        children: [
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: subcategories ==null ? 0 :subcategories.length,
              itemBuilder: (BuildContext context,int index){
                return new GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder:
                            (context) => ListContent(
                      id:widget.id,
                      id_subcategoria:subcategories[index].id,
                      email: widget.email,
                      nombre: widget.nombre,
                      subcategoria: subcategories[index].nombre,
                      descripcion:subcategories[index].descripcion,
                      url:subcategories[index].url
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
                          Conditional.single(
                            context: context,
                            conditionBuilder: (BuildContext context) => subcategories[index].id_profesor==widget.id,
                            widgetBuilder: (BuildContext context) => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('EDIT'),
                                  onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>EditSubcategory(id: widget.id,
                                      id_categoria:subcategories[index].id_categoria,
                                      id_subcategoria:subcategories[index].id,
                                      email: widget.email,
                                      nombre: widget.nombre,
                                      categoria: subcategories[index].nombre,
                                      descripcion: subcategories[index].descripcion,)));
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
                                                //     MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion))
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
                            fallbackBuilder: (BuildContext context) => Text(''),
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
            child: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => subcategories.isEmpty,
              widgetBuilder: (BuildContext context) => Icon(Icons.window_outlined),
              fallbackBuilder: (BuildContext context) => Icon(Icons.launch),
            ),
            // label: subcategories[1].url==""? "Alguna monda":"Esta monda"
          ),
          SpeedDialChild(
              onTap: (){
                // _getData();
              },
              child: Icon(Icons.video_collection),
              // label: subcategories[1].url==""? "Alguna monda":"Esta monda"
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
                    MaterialPageRoute(builder: (context) => AddSubcategory(id:widget.id,id_categoria:widget.id_categoria,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion))
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
   final subcategorias = await SubcategoryApi.getSubcategory(query,widget.id_categoria);

   if(!mounted)return;
    setState(() {
      this.query =query;
      this.subcategories = subcategorias;
    });
  });

  Future openBrowseURL({required String url,})async{
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url),);
    }
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: Text('Agregar repositorio de drive'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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


