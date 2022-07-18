import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'dart:async';
import 'package:app/main.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:app/screens/crud_content/detail_content.dart';
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
  final String url;

  ListContent({required this.id,required this.id_subcategoria, required this.email,required this.nombre,required this.subcategoria,required this.descripcion,required this.url});

  _ListContentState createState() => _ListContentState();
}


class _ListContentState extends State<ListContent> {
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
    final contents = await ContentApi.getContent(query,widget.id_subcategoria);
    print(widget.url);
    print(widget.id_subcategoria);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => DetailContent(
                            id:contents[index].id,
                            id_subcategoria:contents[index].id_subcategoria,
                            email: widget.email,
                            nombre: widget.nombre,
                            subcategoria: contents[index].nombre,
                            descripcion:contents[index].descripcion,
                            url:widget.url
                            ,)
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
        conditionBuilder: (BuildContext context) => widget.url=="",
        widgetBuilder: (BuildContext context) => Icon(Icons.folder),
        fallbackBuilder: (BuildContext context) => Icon(Icons.launch),
      ),
        label: widget.url==""? "Añadir enlace de drive":"Redirigir a drive",
        onTap:() async{
        if(widget.url==""){
          openDialog();
        }else{
          await openBrowseURL( url: 'https://drive.google.com/drive/folders/1WPsk7EmYGzCUAz1lQ6n1qidvUYIPBKuD?usp=sharing');
        }
        }
    ),
          SpeedDialChild(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContent(id:widget.id,id_subcategoria:widget.id_subcategoria,descripcion: widget.descripcion,email: widget.email,nombre: widget.nombre,subcategoria: widget.subcategoria,url: widget.url,)));
              },
              child: Icon(Icons.add),
              label: 'Agregar contenido'
          ),
        ],

      ),
    );
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
                RegExp regExp = new RegExp(r'(http|https):\/\/drive.google.com\/drive\/folders\/[a-zA-Z-1-9]*\?usp=sharing');
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
              if(_keyForm.currentState!.validate()){
                AddUrl(UrlController.text);
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



