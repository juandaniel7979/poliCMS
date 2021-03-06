import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/main.dart';
import 'package:app/model/content.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:app/screens/crud_content/edits/edit_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
// String id='';
// String nombre='';
// String email='';




class DetailContent extends StatefulWidget{
  static const route = '/Detail-Content';

  final String id;
  final String id_subcategoria;
  final String id_content;
  final String id_profesor;
  final String email;
  final String nombre;
  final String subcategoria;
  final String descripcion;

  DetailContent({required this.id,required this.id_subcategoria,required this.id_profesor, required this.id_content, required this.email,required this.nombre,required this.subcategoria,required this.descripcion});


  _DetailContentState createState() => _DetailContentState();

}


quill.QuillController _controller = quill.QuillController.basic();

var editar = 0;

class _DetailContentState extends State<DetailContent> {
  var rol;
  late List data= [];
  late List descripcion= [];
  String content='';
  // late Map<String,dynamic> descripcion2='';

  String MyJson = '';

  void _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    rol=sharedPreferences.getString('rol');
    // var url='https://poli-cms.herokuapp.com/api/contenido/contenidos?id=${widget.id_subcategoria}';
    var url='https://poli-cms.herokuapp.com/api/contenido/contenido?id=${widget.id_content}';
    var token= sharedPreferences.getString("token");
      final response = await http.get(
          Uri.parse(url),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'auth-token': '${token}'
          }
      );
      var res = jsonDecode(response.body);
      print(response.body);
      final contenido =Content.fromJson(res['contenido']);
      print(contenido.descripcion);
      try{
        print('entro aqui');
        // final doc = quill.Document.fromJson(jsonDecode(widget.descripcion));
        final doc = quill.Document.fromJson(jsonDecode(contenido.descripcion));
        this.setState(() {
          _controller = quill.QuillController(
              document: doc, selection: const TextSelection.collapsed(offset: 0));
        });
      }catch(e){
        print('Cayo en el catch');
        final doc = quill.Document()..insert(0, 'Esta publicacion se encuentra vacia');
        setState(() {
          _controller = quill.QuillController(
              document: doc, selection: const TextSelection.collapsed(offset: 0));
        });
      }
  }

  @override
  void initState() {
    super.initState();
    this._getData();
    print(widget.id);
    // print(widget.id_profesor);
  }

  @override
  Widget build(BuildContext context) {
    if(rol=="profesor"|| rol=="administrador" && widget.id_profesor==widget.id){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25,104,68, 1),
          title: Text(widget.subcategoria),
        ),
        drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
        body:Column(
          children: [

            Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          // BoxShadow(
                          //   color: Colors.lightBlueAccent,
                          //   offset:const Offset(5.0, 5.0),
                          //   blurRadius:10.0,
                          //   spreadRadius:2.0
                          // ),
                          BoxShadow(
                            color: Colors.white,
                            offset:const Offset(-5.5, 0.0,),
                            blurRadius:0.0,
                            spreadRadius:0.0,
                          ),
                        ]
                    ),
                    child: quill.QuillEditor.basic(controller: _controller, readOnly: true),
                    // quill.QuillEditor.basic(controller: _controller, readOnly: false),
                  ),
                )
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          backgroundColor:  Color.fromRGBO(25,104,68, 1),
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
                  if(widget.id==widget.id_profesor){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditContent(id:widget.id,id_subcategoria:widget.id_subcategoria,id_profesor: widget.id_profesor,id_content:widget.id_content,descripcion: widget.descripcion,email: widget.email,nombre: widget.nombre,subcategoria: widget.subcategoria)));
                  }else{
                    null;
                  }

                },
                child: Icon(Icons.edit),
                label: 'Editar publicacion'
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

            Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          // BoxShadow(
                          //   color: Colors.lightBlueAccent,
                          //   offset:const Offset(5.0, 5.0),
                          //   blurRadius:10.0,
                          //   spreadRadius:2.0
                          // ),
                          BoxShadow(
                            color: Colors.white,
                            offset:const Offset(-5.5, 0.0,),
                            blurRadius:0.0,
                            spreadRadius:0.0,
                          ),
                        ]
                    ),
                    child: quill.QuillEditor.basic(controller: _controller, readOnly: true),
                    // quill.QuillEditor.basic(controller: _controller, readOnly: false),
                  ),
                )
            ),
          ],
        ),
      );
    }
  }




}



