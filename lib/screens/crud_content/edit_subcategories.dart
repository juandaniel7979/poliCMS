import 'package:app/main.dart';
import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

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
  final String nombre;
  final String descripcion;
  EditSubcategory({required this.id,required this.nombre,required this.descripcion});
  _EditSubcategoryState createState() => _EditSubcategoryState();

}

class _EditSubcategoryState extends State<EditSubcategory> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  String msg = '';
  // String url = "http://192.168.56.1/tienda/login.php";

  Future _AddCategory() async {

    setState(() {
      visible = true ;
    });

    String title = TitleController.text=widget.nombre;
    String Description = DescriptionController.text=widget.descripcion;

    var data = {'id_subcategoria':widget.id,'nombre':title,'descripcion': Description};


    final response = await http.post(
        Uri.http("192.168.56.1", "/PPI_ANDROID/crud/edit/editdata.php"), body:json.encode(data));

    var msg = json.decode(response.body);

    if(msg=="Se ha agregado la categoria exitosamente"){
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      // Navigator.pushReplacementNamed(context,LoginScreenStudent.routeName);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => LoginPageStudent())
      // );
    }else{
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });


      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(msg),
            actions: <Widget>[
              ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
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
        backgroundColor: Colors.green,
        title: Center(child: Text('Editar subcategoria'),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
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
                          'Añadir categoria',
                          style: TextStyle(
                              fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold
                          ),
                        ),
                        style:
                        OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )
                        ),
                        onPressed: () {
                          if(_keyForm.currentState!.validate()){
                            print("validacion exitosa");
                            _AddCategory();
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
