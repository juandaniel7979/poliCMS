import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Texto show Text,TextStyle;

import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    setState(() {
      visible = true ;
    });
    String title = TitleController.text;
    String Description = DescriptionController.text;
    var data = {'nombre':title,'descripcion': Description,'id_profesor_fk':widget.id};
    final response = await http.post(
        Uri.http("192.168.56.1", "/PPI_ANDROID/crud/adds/add_content.php"), body:json.encode(data));

    var msg = json.decode(response.body);

    if(msg=="Se ha agregado el contenido exitosamente"){
      setState(() {
        visible = false;
      });

    }else{
      setState(() {
        visible = false;
      });

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            //Barra de herramientas
            child: QuillToolbar.basic(controller: _controller),
          ),
          TextFormField(
          keyboardType: TextInputType.text,
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
                  var Myjson= jsonEncode(_controller.document.toDelta().toJson());
                  print(_controller.document.toDelta().toJson());
                  print('el json');
                  print(Myjson);
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
      )
    );
  }

}
