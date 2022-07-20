import 'dart:async';
import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/search_widget.dart';
import 'package:app/api/category_api.dart';
import 'package:app/model/category.dart';
import 'package:app/screens/access_code.dart';
import 'package:app/screens/crud_content/adds/add_category.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

// String id='';
// String nombre='';
// String email='';
class Explorer extends StatefulWidget {
  static const route = '/explorer';

  final String id;
  final String email;
  final String nombre;

  Explorer({required this.id, required this.email, required this.nombre});

  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {

  late List<Category> categories =[];
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
    final categories = await CategoryApi.getCategory(query,widget.id);
    setState(() {
      this.categories=categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorar'),
      ),
      drawer: MainDrawer(id:widget.id,email: widget.email, nombre: widget.nombre),
      body:  Column(
        children: [
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: categories == null ? 0 : categories.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListSubcategories(
                                  id: widget.id,
                                  id_categoria:categories[index].id,
                                  email: widget.email,
                                  nombre: widget.nombre,
                                  categoria: categories[index].nombre,
                                  descripcion: categories[index].descripcion,
                                )));
                  },
                  child: Card(
                    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text(
                          'Categoria: ' + categories[index].nombre,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Descripcion: ' + categories[index].descripcion),
                      ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Creado por:',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                        Text(categories[index].nombre_profesor,style: TextStyle(color: Colors.grey),)
                      ]
                  ),
                    ]),
                    // EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    // color: Colors.white,
                    // elevation: 5.0,
                    // child: Center(
                    //     child: Text('id: '+categories[index]['id_categoria']+'\nCategoria: '+categories[index]['nombre']+'\nDescripcion: '+categories[index]['descripcion'])
                    // ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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

  Widget buildSearch()=>SearchWidget(
      text: query,
      onChanged: searchCategory,
      hintText: 'Titulo de la categoria');

  void searchCategory(String query)async =>debounce(() async {
    final categories = await CategoryApi.getCategory(query,widget.id);

    if(!mounted)return;
    setState(() {
      this.query =query;
      this.categories = categories;
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
