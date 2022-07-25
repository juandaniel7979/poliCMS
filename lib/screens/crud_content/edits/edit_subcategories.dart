import 'dart:io';

import 'package:app/main.dart';
import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class EditSubcategory extends StatefulWidget{
  static const routeName = '/EditSubcategory';
  final String id;
  final String id_categoria;
  final String id_subcategoria;
  final String email;
  final String nombre;
  final String categoria;
  final String descripcion;

  EditSubcategory({required this.id, required this.id_categoria,required this.id_subcategoria, required this.email, required this.nombre, required this.categoria, required this.descripcion});

  _EditSubcategoryState createState() => _EditSubcategoryState();

}

class _EditSubcategoryState extends State<EditSubcategory> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  String msg = '';
  // String url = "http://192.168.56.1/tienda/login.php";

  @override
  void initState() {
    super.initState();
    TitleController.text=widget.categoria;
    DescriptionController.text=widget.descripcion;
  }



  Future _EditSubcategory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    String title = TitleController.text;
    String description = DescriptionController.text;
    var data = {'id_subcategoria':widget.id_subcategoria,'nombre':title,'descripcion': description};
    final response = await http.put(
        Uri.parse("https://poli-cms.herokuapp.com/api/subcategoria/editar"),
        body:json.encode({'id_subcategoria':widget.id_subcategoria,'nombre':title,'descripcion': description}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);

    final jsonResponse = json.decode(response.body);
    print(jsonResponse['error']);

    if(response.statusCode==200){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Se ha editado la Subtematica con exito"),
            actions: <Widget>[
              ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,id_categoria:widget.id_categoria,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion))
                  );
                  // Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
                },
              ),
            ],
          );
        },
      );
    }else{

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(jsonResponse['error']),
            actions: <Widget>[
              ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(25,104,68, 1),
        title: Center(child: Text('Editar Subtematica'),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,id_categoria:widget.id_categoria,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion))
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child:
                Form(
                  key: _keyForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Image.asset(
                      //   "assets/images/enroll.php",
                      //   height: 130,
                      // ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        validator: (valor){
                          // if(valor!.isEmpty){
                          //   return 'Este campo no puede estar vacío';
                          // }
                        },
                        controller: TitleController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Titulo',
                          contentPadding: const EdgeInsets.all(15),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (valor) {
                          // if (valor!.isEmpty) {
                          //   return 'El campo descripcion es obligatorio';
                          // }
                          // if (valor.length<15 || valor.length>150) {
                          //   return 'El campo descripcion debe contener minimo 15 y máximo 200 caracteres';
                          // }

                        },
                        keyboardType:TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        controller: DescriptionController,
                        // obscureText: true,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Descripcion',
                          contentPadding: const EdgeInsets.all(15),
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
                      SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        child: Text(
                          'Editar Subtematica',
                          style: TextStyle(
                              fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold
                          ),
                        ),
                        style:
                        OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor:  Color.fromRGBO(25,104,68, 1),
                            padding: EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )
                        ),
                        onPressed: () {
                          if(_keyForm.currentState!.validate()){
                            print("validacion exitosa");
                            _EditSubcategory();
                          }else{
                            print("validacion erronea");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
