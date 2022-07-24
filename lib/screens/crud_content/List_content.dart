import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'dart:async';
import 'package:app/main.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:app/screens/crud_content/detail_content.dart';
import 'package:app/screens/crud_content/edits/edit_content.dart';
import 'package:app/screens/crud_content/edits/edit_content_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:app/Widgets/search_widget.dart';
import 'package:app/api/content_api.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/content.dart';

// String id='';
// String nombre='';
// String email='';


class ListContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
class ListContent extends StatefulWidget{
  static const route = '/list-content';

  final String id;
  final String id_subcategoria;
  final String email;
  final String nombre;
  final String subcategoria;
  final String descripcion;

  ListContent({required this.id,required this.id_subcategoria, required this.email,required this.nombre,required this.subcategoria,required this.descripcion});

  _ListContentState createState() => _ListContentState();
}


class _ListContentState extends State<ListContent> {
  var rol;
  late List<Content> contents =[];
  String query = '';
  Timer? debouncer;
  final _keyForm = GlobalKey<FormState>();
  final UrlController = TextEditingController();


  @override
  void initState() {
    super.initState();
    this.init();
    print(widget.id_subcategoria);
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    rol = sharedPreferences.getString("rol");
    final contents = await ContentApi.getContent(query,widget.id_subcategoria);
    setState(() {
      this.contents=contents;
    });
  }

  Future AddUrl(String url)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    final response = await http.put(Uri.parse("http://192.168.1.1:3002/api/subcategoria/url"),
    body: jsonEncode({'url': url,'id_subcategoria':widget.id_subcategoria}),
    headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'},
    );

    print(response.body);
    if(response.statusCode==200){
      print('Se ha actualizado con exito');
      // return AlertDialog(
      //   title: Text("Se ha configurado la url con exito"),
      //   ,
      // );

    }else{
      print('Se ha actualizado con exito');
    }

  }

  Future _DeleteElement( id_categoria) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    var datos= {"id":id_categoria};
    final response = await http.put(
        Uri.parse("https://poli-cms.herokuapp.com/api/subcategoria/borrar"),
        body:json.encode(datos),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);

    // print(data[1]["nombre"]);

  }



  @override
  Widget build(BuildContext context) {
    if(rol=="administrador" || rol=="profesor"){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25,104,68, 1),
          title: Text(widget.subcategoria),
        ),
        drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
        body:Column(
            children: [
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  itemCount: contents ==null ? 0 :contents.length,
                  itemBuilder: (BuildContext context,int index){
                    return new GestureDetector(
                      onLongPress: (){
                        if(widget.id ==contents[index].id_profesor){
                          MaterialPageRoute(builder:
                              (context) => EditContent(
                            id:widget.id,
                            id_profesor:contents[index].id_profesor,
                            id_subcategoria:contents[index].id_subcategoria,
                            id_content:contents[index].id,
                            email: widget.email,
                            nombre: widget.nombre,
                            subcategoria: widget.subcategoria,
                            descripcion:contents[index].descripcion,
                          )
                          );
                        }else{
                          null;
                        }
                      },
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => DetailContent(
                              id:widget.id,
                              id_profesor:contents[index].id_profesor,
                              id_subcategoria:contents[index].id_subcategoria,
                              id_content:contents[index].id,
                              email: widget.email,
                              nombre: widget.nombre,
                              subcategoria: widget.subcategoria,
                              descripcion:contents[index].descripcion,
                            )
                            ));
                      },
                      child: Card(
                        child:Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.album),
                                title: Text('Publicacion: '+contents[index].nombre+contents[index].id_profesor,
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text('Descripcion: '+contents[index].descripcion_corta),
                              ),
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) => contents[index].id_profesor==widget.id,
                                widgetBuilder: (BuildContext context) => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('EDIT'),
                                      onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                            EditContentHeader(id: widget.id,
                                              id_contenido:contents[index].id,
                                              subcategoria:widget.subcategoria,
                                              email: widget.email,
                                              nombre: widget.nombre,
                                              descripcion: contents[index].descripcion,
                                              nombre_contenido: contents[index].nombre,
                                              id_subcategoria: widget.id_subcategoria,)));
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

                                                    _DeleteElement(contents[index].id);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ListContent(id:widget.id,email: widget.email,nombre: widget.nombre,id_subcategoria: widget.id_subcategoria,descripcion:widget.descripcion,subcategoria: widget.subcategoria,))
                                                    );
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
          backgroundColor:  Color.fromRGBO(25,104,68, 1),
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddContent(id:widget.id,id_subcategoria:widget.id_subcategoria,descripcion: widget.descripcion,email: widget.email,nombre: widget.nombre,subcategoria: widget.subcategoria)));
                },
                child: Icon(Icons.add),
                label: 'Agregar contenido'
            ),
          ],

        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25,104,68, 1),
          title: Text(widget.subcategoria),
        ),
        drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
        body:Column(
            children: [
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  itemCount: contents ==null ? 0 :contents.length,
                  itemBuilder: (BuildContext context,int index){
                    return new GestureDetector(
                      onLongPress: (){
                        if(widget.id ==contents[index].id_profesor){
                          MaterialPageRoute(builder:
                              (context) => EditContent(
                            id:widget.id,
                            id_profesor:contents[index].id_profesor,
                            id_subcategoria:contents[index].id_subcategoria,
                            id_content:contents[index].id,
                            email: widget.email,
                            nombre: widget.nombre,
                            subcategoria: widget.subcategoria,
                            descripcion:contents[index].descripcion,
                          )
                          );
                        }else{
                          null;
                        }
                      },
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => DetailContent(
                              id:widget.id,
                              id_profesor:contents[index].id_profesor,
                              id_subcategoria:contents[index].id_subcategoria,
                              id_content:contents[index].id,
                              email: widget.email,
                              nombre: widget.nombre,
                              subcategoria: widget.subcategoria,
                              descripcion:contents[index].descripcion,
                            )
                            ));
                      },
                      child: Card(
                        child:Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.album),
                                title: Text('Publicacion: '+contents[index].nombre,
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text('Descripcion: '+contents[index].descripcion_corta),
                              ),
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) => contents[index].id_profesor==widget.id,
                                widgetBuilder: (BuildContext context) => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('EDIT'),
                                      onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                            EditContentHeader(id: widget.id,
                                              id_contenido:contents[index].id,
                                              subcategoria:widget.subcategoria,
                                              email: widget.email,
                                              nombre: widget.nombre,
                                              descripcion: contents[index].descripcion,
                                              nombre_contenido: contents[index].nombre,
                                              id_subcategoria: widget.id_subcategoria,)));
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

                                                    _DeleteElement(contents[index].id);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ListContent(id:widget.id,email: widget.email,nombre: widget.nombre,id_subcategoria: widget.id_subcategoria,descripcion:widget.descripcion,subcategoria: widget.subcategoria,))
                                                    );
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
      );
    }
  }


  Widget buildSearch()=>SearchWidget(
      text: query,
      onChanged: searchContent,
      hintText: 'Titulo de la subcategoria');

  void searchContent(String query)async =>debounce(() async {
    final contenidos = await ContentApi.getContent(query,widget.id_subcategoria);

    if(!mounted)return;
    setState(() {
      this.query =query;
      this.contents = contenidos;
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
        key: _keyForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (valor){
                RegExp regExp = new RegExp(r'(http|https):\/\/drive.google.com\/drive\/folders\/[^?]*\?usp=sharing');
                if(valor!.isEmpty){
                  return 'Este campo no puede estar vacío';
                }else if (!regExp.hasMatch(valor)){
                  return "Ingresa una url valida";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Ingresa la url del drive"
              ),
              controller: UrlController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child:Text('Cancel')),
        TextButton(
            onPressed: (){
              if(_keyForm.currentState!.validate()){
                AddUrl(UrlController.text);
                Navigator.pop(context);
              }
              else{
                print("validacion erronea");
              }
            },
            child:Text('SUBMIT'))
      ],
    ),
  );




}



