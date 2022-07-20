import 'dart:io';

import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/List_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Texto show Text,TextStyle;
import 'package:flutter_quill/flutter_quill.dart' hide Text;
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
  final String email;
  final String nombre;
  final String subcategoria;
  final String descripcion;
  final String url;

  EditContent({required this.id,required this.id_subcategoria, required this.id_content, required this.email,required this.nombre,required this.subcategoria,required this.descripcion,required this.url});
  _EditContentState createState() => _EditContentState();

}

QuillController _controller = QuillController.basic();

class _EditContentState extends State<EditContent> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  String msg = '';
  // String url = "http://192.168.56.1/tienda/login.php";

  Future _EditContent() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    String title = TitleController.text;
    String description = DescriptionController.text;
    final response = await http.post(
        Uri.parse('http://192.168.1.1:3002/api/contenido/contenido'),
        body:json.encode({'nombre':title,'id_subcategoria':widget.id_subcategoria,'descripcion_corta':description,'descripcion': jsonEncode(_controller.document.toDelta().toJson())}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(widget.id_subcategoria);
    print(response.body);
    var res = json.decode(response.body);

    if(response.statusCode==200){
      _controller.document.delete(0, _controller.document.length);

      return showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          title: Text('Agregar repositorio de drive'),
          content: Text(res['message']),
          actions: [
            TextButton(
                onPressed: (){

                },
                child:Text('SUBMIT'))
          ],
        ),
      );

    }else{
      return showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          title: Text('Agregar repositorio de drive'),
          content: Text(res['message']),
          actions: [
            TextButton(
                onPressed: (){

                },
                child:Text('SUBMIT'))
          ],
        ),
      );
    }

  }

  void _getData() async {

    try{
      print('entro aqui');
      // final doc = quill.Document.fromJson(jsonDecode(result));
      // final doc = quill.Document.fromJson(jsonDecode(extraccion));
      final doc = Document.fromJson(jsonDecode(widget.descripcion));
      this.setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }catch(e){
      print('Cayo en el catch');
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
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
        backgroundColor: Colors.blue,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              //Barra de herramientas
              child: QuillToolbar.basic(controller: _controller),
            ),
            Expanded(
                child:Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
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
                            offset:const Offset(0.0, 0.0,),
                            blurRadius:0.0,
                            spreadRadius:0.0,
                          ),
                        ]
                    ),
                    child: QuillEditor.basic(controller: _controller, readOnly: false),
                  ),
                )
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: (){
                    _controller.document.delete(0, _controller.document.length);
                    print(jsonEncode(_controller.document.toDelta().toJson()));
                    print(_controller.document.toPlainText());
                  }, child:Texto.Text('Eliminar contenido',style:Texto.TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                    style:
                    OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.all(13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                    ),

                    // Text('Añadir contenido',textS)
                  ),
                  OutlinedButton(onPressed: (){
                    if(_keyForm.currentState!.validate()){
                      if(!_controller.document.isEmpty()){
                        var Myjson= jsonEncode(_controller.document.toDelta().toJson());
                        // print(_controller.document.toDelta().toJson());
                        _EditContent();
                        _controller.document.delete(0, _controller.document.length);
                        // print(Myjson);
                      }
                      // print("validacion exitosa");

                    }else{
                      print("validacion erronea");
                    }
                  }, child:Texto.Text('Agregar contenido',style:Texto.TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                    style:
                    OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.all(13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                    ),
                    // Text('Añadir contenido',textS)
                  ),
                ],
              ),
            ),
          ],
        )
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
}
