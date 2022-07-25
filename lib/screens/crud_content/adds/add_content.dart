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

  AddContent({required this.id,required this.id_subcategoria, required this.email,required this.nombre,required this.subcategoria,required this.descripcion});
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
        Uri.parse('https://poli-cms.herokuapp.com/api/contenido/contenido'),
        body:json.encode({'nombre':title,'id_subcategoria':widget.id_subcategoria,'descripcion_corta':description}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(widget.id_subcategoria);
    print(response.body);
    var res = json.decode(response.body);

    if(response.statusCode==200){
      _controller.document.delete(0, _controller.document.length);

      return showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          title: Text('La publicacion se ha agregado con exito'),
          content: Text(res['message']),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> ListContent(id: widget.id, id_subcategoria: widget.id_subcategoria, email: widget.email, nombre: widget.nombre, subcategoria: widget.subcategoria, descripcion: widget.descripcion)));
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
        backgroundColor:  Color.fromRGBO(25,104,68, 1),
        title: Center(child: Text('Agregar Publicacion'),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Form(

          key: _keyForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green,width: 20),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
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
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green,width: 20),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(onPressed: (){
                        if(_keyForm.currentState!.validate()){
                            _AddContent();
                        }else{
                          print("validacion erronea");
                        }
                    }, child:Texto.Text('Agregar Publicacion',style:Texto.TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                      style:
                      OutlinedButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor:  Color.fromRGBO(25,104,68, 1),
                          padding: EdgeInsets.all(13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )
                      ),
                      // Text('Agregar Publicacion',textS)
                    ),
                    ],
                  ),
              ),
            ],
          ),
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
