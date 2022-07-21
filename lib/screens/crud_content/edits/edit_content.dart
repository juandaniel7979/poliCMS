import 'dart:io';

import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/List_content.dart';
import 'package:app/screens/crud_content/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Texto show Text,TextStyle;
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class EditContent extends StatefulWidget{
  static const routeName = '/EditContent';
  final String id;
  final String id_subcategoria;
  final String id_content;
  final String id_profesor;
  final String email;
  final String nombre;
  final String subcategoria;
  final String descripcion;

  EditContent({required this.id,required this.id_subcategoria,required this.id_profesor, required this.id_content, required this.email,required this.nombre,required this.subcategoria,required this.descripcion});
  _EditContentState createState() => _EditContentState();

}

QuillController _controllerEdit = QuillController.basic();

class _EditContentState extends State<EditContent> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  String msg = '';

  Future _EditContent() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    final response = await http.put(
        Uri.parse('http://192.168.56.1:3002/api/contenido/editarPub'),
        body:json.encode({'id_contenido':widget.id_content,'descripcion':jsonEncode(_controllerEdit.document.toDelta().toJson())}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(jsonEncode(_controllerEdit.document.toDelta().toJson()).toString());

    print(response.body);
    var res = json.decode(response.body);

    if(response.statusCode==200){
      _controllerEdit.document.delete(0, _controllerEdit.document.length);
      print(response.body);
      // return showDialog(
      //   context: context,
      //   builder: (context)=>AlertDialog(
      //     title: Text('Agregar repositorio de drive'),
      //     content: Text(res['message']),
      //     actions: [
      //       TextButton(
      //           onPressed: (){
      //
      //           },
      //           child:Text('SUBMIT'))
      //     ],
      //   ),
      // );

    }else{
      print(response.body);
      // return showDialog(
      //   context: context,
      //   builder: (context)=>AlertDialog(
      //     title: Text('Agregar repositorio de drive'),
      //     content: Text(res['message']),
      //     actions: [
      //       TextButton(
      //           onPressed: (){
      //
      //           },
      //           child:Text('SUBMIT'))
      //     ],
      //   ),
      // );
    }

  }

  void _getData() async {

    try{
      print('entro aqui');
      // final doc = quill.Document.fromJson(jsonDecode(result));
      // final doc = quill.Document.fromJson(jsonDecode(extraccion));
      final doc = Document.fromJson(jsonDecode(widget.descripcion));
      this.setState(() {
        _controllerEdit = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }catch(e){
      print('Cayo en el catch');
      final doc = Document()..insert(0, 'Not Empty');
      setState(() {
        _controllerEdit = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          // title: Center(child: Text('Añadir categoria'),),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            QuillToolbar.basic(controller: _controllerEdit),
            Expanded(
              child: Container(
                child: QuillEditor.basic(
                  controller: _controllerEdit,
                  readOnly: false, // true for view only mode
                ),
              ),
            )
          ],
        ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              onTap: (){
                DialogueClear();
              },
              child: Icon(Icons.clear),
              label: "Limpiar"
          ),
          SpeedDialChild(
            onTap: (){
              DialogueSave();
            },
              label: "Guardar cambios",
            child: Icon(Icons.save)
          ),

        ],
      ),
    );
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


  Future DialogueClear() => showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: Text('¿Estás seguro que deseas limpiar el documento?'),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child:Text('CANCELAR')),
        TextButton(
            onPressed: (){
              _controllerEdit.document.delete(0, _controllerEdit.document.length);
              Navigator.pop(context);
            },
            child:Text('SUBMIT'))
      ],
    ),
  );


  Future DialogueSave() => showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: Text('¿Estás seguro que deseas guardar los cambios realizados?'),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child:Text('CANCELAR')),
        TextButton(
            onPressed: (){

              if(!_controllerEdit.document.isEmpty()){
                _EditContent();

                MaterialPageRoute(builder:
                (context) =>DetailContent(id: widget.id, id_subcategoria: widget.id_subcategoria,id_profesor: widget.id_profesor, id_content: widget.id_content, email: widget.email, nombre: widget.nombre, subcategoria: widget.subcategoria, descripcion: widget.descripcion));
              }else{
              AlertDialog(
                  title: Texto.Text("error"),
                  content: Texto.Text("El documento está vacio"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    },
                    child:Texto.Text("OK")
                    )
                  ],
                );
              }
              // _controllerEdit.document.delete(0, _controllerEdit.document.length);
              Navigator.pop(context);
            },
            child:Text('SUBMIT'))
      ],
    ),
  );
}
