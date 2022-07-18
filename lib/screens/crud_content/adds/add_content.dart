import 'dart:io';

import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/List_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Texto show Text,TextStyle;
import 'package:flutter_quill/flutter_quill.dart' hide Text;
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
  final String email;
  final String nombre;
  final String subcategoria;
  final String descripcion;
  final String url;

  AddContent({required this.id,required this.id_subcategoria, required this.email,required this.nombre,required this.subcategoria,required this.descripcion,required this.url});
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
          content: Text(res['mensaje']),
          actions: [
            TextButton(
                onPressed: (){

                },
                child:Text('SUBMIT'))
          ],
        ),
      );
      // return AlertDialog(
      //   title: Text('La categoria se ha agregado con exito'),
      //   content: Text(res['message']),
      //   actions: <Widget>[
      //     ElevatedButton(
      //       child: new Text("OK"),
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => ListContent(
      //               id:widget.id,
      //               id_subcategoria:widget.id_subcategoria,
      //               email: widget.email,
      //               nombre: widget.nombre,
      //               subcategoria:widget.subcategoria,
      //               descripcion:widget.descripcion,
      //               url:widget.url
      //               ,)
      //             )
      //         );
      //         // Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
      //       },
      //     ),
      //   ],
      // );
    }else{
      // return AlertDialog(
      //   title: Text('La categoria que intenta agregar ya existe'),
      //   content: Text(res['message']),
      //   actions: <Widget>[
      //     ElevatedButton(
      //       child: new Text("OK"),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ],
      // );
    }

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
            ),Container(
              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
              child: TextFormField(
                validator: (valor){
                  if(valor!.isEmpty){
                    return 'Este campo no puede estar vacío';
                  }
                },
              keyboardType: TextInputType.text,
                controller: DescriptionController,
              style: TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Descripcion breve de la publicacion',
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
                          _AddContent();
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
        ),
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
