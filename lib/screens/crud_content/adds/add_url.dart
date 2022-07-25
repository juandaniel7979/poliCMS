import 'dart:io';

import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddSubcategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class AddSubcategory extends StatefulWidget{
  static const routeName = '/addSubcategory';
  final String id;
  final String id_categoria;
  final String email;
  final String nombre;
  final String categoria;
  final String descripcion;
  // AddSubcategory({required this.id});
  AddSubcategory({required this.id,required this.id_categoria,required this.email,required this.nombre,required this.categoria,required this.descripcion});
  _AddSubCategoryState createState() => _AddSubCategoryState();

}

class _AddSubCategoryState extends State<AddSubcategory> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  String msg = '';
  // String url = "http://192.168.56.1/tienda/login.php";

  // Future _AddSubCategory() async {
  //
  //   setState(() {
  //     visible = true ;
  //   });
  //
  //   String title = TitleController.text;
  //   String Description = DescriptionController.text;
  //
  //   var data = {'nombre':title,'descripcion': Description,'id_categoria_fk':widget.id};
  //
  //
  //   final response = await http.post(
  //       Uri.http("192.168.56.1", "/PPI_ANDROID/crud/adds/add_subcategory.php"), body:json.encode(data));
  //
  //   var msg = json.decode(response.body);
  //
  //   if(msg=="Se ha agregado la categoria exitosamente"){
  //     // Hiding the CircularProgressIndicator.
  //     setState(() {
  //       visible = false;
  //     });
  //     // Navigate to Profile Screen & Sending Email to Next Screen.
  //     // Navigator.pushReplacementNamed(context,LoginScreenStudent.routeName);
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(builder: (context) => LoginPageStudent())
  //     // );
  //
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: new Text(msg),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               child: new Text("OK"),
  //               onPressed: () {
  //                 // Navigator.pop(context);
  //                 // Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion))
  //                 );
  //                 // Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //
  //   }else{
  //
  //     // If Email or Password did not Matched.
  //     // Hiding the CircularProgressIndicator.
  //     setState(() {
  //       visible = false;
  //     });
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: new Text("La categoria que intentas insertar ya existe"  ),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   child: new Text("OK"),
  //                   onPressed: () => Navigator.pop(context, 'OK'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //
  //
  //
  //     // Showing Alert Dialog with Response JSON Message.
  //
  //   }
  // }

  Future _AddSubCategory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    var url ="https://poli-cms.herokuapp.com/api/subcategoria/subcategoria";
    String title = TitleController.text;
    String Description = DescriptionController.text;
    var token= sharedPreferences.getString("token");
    var response = await http.post(Uri.parse(url),
        body:jsonEncode({'nombre':title,'descripcion': Description,'id_categoria':widget.id}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
    );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(msg),
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
    }
    else {
      jsonResponse = json.decode(response.body);
      msg= jsonResponse['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(jsonResponse['message']),
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
        title: Center(child: Text('Agregar Subtematica'),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
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
                          if(valor!.isEmpty){
                            return 'Este campo no puede estar vacío';
                          }
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
                          if (valor!.isEmpty) {
                            return 'El campo descripcion es obligatorio';
                          }
                          if (valor.length<15 || valor.length>150) {
                            return 'El campo descripcion debe contener minimo 15 y máximo 200 caracteres';
                          }

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
                          'Agregar Subtematica',
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
                            _AddSubCategory();
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
