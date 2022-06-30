import 'dart:io';

import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Texto show Text,TextStyle;

import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class AddContent extends StatefulWidget{
  static const routeName = '/AddContent';
  final String id;
  final String id_subcategoria;

  AddContent({required this.id,required this.id_subcategoria});
  _AddContentState createState() => _AddContentState();

}

QuillController _controller = QuillController.basic();

class _AddContentState extends State<AddContent> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  String msg = '';
  // String url = "http://192.168.56.1/tienda/login.php";

  Future _AddContent() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    String title = TitleController.text;
    String Description = 'un Texto cualquiera para probar';
    
    var data = {'id_subcategoria':widget.id_subcategoria,'nombre':title,'descripcion': Description,'descripcion_2':jsonEncode(_controller.document.toDelta().toJson())};

    final response = await http.post(
        Uri.parse('http://192.168.1.1:3002/api/contenido/contenido'),
        // body:json.encode({'nombre':title,'id_subcategoria':widget.id_subcategoria,'descripcion': Description,'descripcion_2':jsonEncode(_controller.document.toDelta().toJson())}),
        body:json.encode({'nombre':title,'id_subcategoria':widget.id_subcategoria,'descripcion': jsonEncode(_controller.document.toDelta().toJson())}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);
    var res = json.decode(response.body);

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
      body: Form(
        key: _keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              //Barra de herramientas
              child: QuillToolbar.basic(controller: _controller),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
              child: TextFormField(
                validator: (valor){
                  if(valor!.isEmpty){
                    return 'Este campo no puede estar vacío';
                  }
                },
              keyboardType: TextInputType.text,
                controller: TitleController,
              style: TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Titulo',
                contentPadding: const EdgeInsets.all(8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              ),
            ),
            Expanded(
                child:Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        _AddContent();
                        // print(Myjson);
                      }
                      // print("validacion exitosa");

                    }else{
                      print("validacion erronea");
                    }

                    // print('en texto plano');
                    // print(_controller.document.toPlainText());
                    // var jsonObj = json.
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

          ],
        ),
      )
    );
  }

}
