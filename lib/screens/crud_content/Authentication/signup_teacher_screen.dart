import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/Authentication/login_teacher_screen.dart';
import 'package:app/screens/crud_content/Authentication/signup_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreenTeacher extends StatelessWidget {
  static const routeName = '/signup-teacher';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class SignupPageTeacher extends StatefulWidget{
  _SignupPageState createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPageTeacher> {

  final _keyForm = GlobalKey<FormState>();

  bool visible = false;
  final uidController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final nombre2Controller = TextEditingController();
  final apellidoController = TextEditingController();
  final apellido2Controller = TextEditingController();

  // TextEditingController controllerUser = new TextEditingController();
  // TextEditingController controllerPass = new TextEditingController();

  String msg = '';
  // String url = "http://192.168.56.1/tienda/login.php";

  Future _signup() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String uid = uidController.text;
      String correo = emailController.text;
      String nombre = nombreController.text;
      String nombre2 = nombre2Controller.text;
      String apellido = apellidoController.text;
      String apellido2 = apellido2Controller.text;
      String contrasena = passwordController.text;
      var jsonResponse = null;
      var url ="https://poli-cms.herokuapp.com/api/user/register-profesor";

      var response = await http.post(Uri.parse(url), body: {'uid':uid,'nombre':nombre,'nombre_2':nombre2,'apellido':apellido,'apellido_2':apellido2,'correo': correo.toLowerCase().trim(), 'contrasena' : contrasena});
      if(response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print("Token "+jsonResponse['token']);
        if(jsonResponse != null) {
          sharedPreferences.setString("token", jsonResponse['token']);
          Navigator.pushReplacementNamed(context, LoginScreenTeacher.routeName);
        }
      }
      else {
        jsonResponse = json.decode(response.body);
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
        title: Center(child: Text('Registro')),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreenTeacher.routeName);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            color: Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Image.asset(
                      //   'assets/images/login.php',
                      //   height: 130,
                      // ),
                      Center(
                          child: Text("Registrate para empezar a compartir tu conocimiento",
                            style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),)),

                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        controller: emailController,
                        validator: (email)=>email!=null && !EmailValidator.validate(email)
                            ?'Ingresa un email válido'
                            :null,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Correo electronico',
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: Icon(Icons.mail),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (valor){
                          if(valor!.isEmpty){
                            return 'El numero de documento vacio';
                          }
                          if(valor.length<5 || valor.length>10){
                            return 'Numero de documento no es válido';
                          }

                        },
                        controller: uidController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Documento de identidad',
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(5),
                      ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              validator: (valor) {
                                if (valor!.isEmpty) {
                                  return 'El campo debe contener un nombre';
                                }
                              },
                              keyboardType:TextInputType.name,
                              controller: nombreController,
                              style: TextStyle(fontSize: 18, color: Colors.black54),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '1er nombre',
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
                          SizedBox(width: 20.0,),
                          new Flexible(
                            child: new TextField(
                              controller: nombre2Controller,
                              style: TextStyle(fontSize: 18, color: Colors.black54),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '2do nombre',
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              validator: (valor) {
                                if (valor!.isEmpty) {
                                  return 'El campo está vacío';
                                }
                              },
                              keyboardType:TextInputType.name,
                              controller: apellidoController,
                              style: TextStyle(fontSize: 18, color: Colors.black54),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '1er apellido',
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
                          SizedBox(width: 20.0,),
                          new Flexible(
                            child: new TextField(
                              controller: apellido2Controller,
                              style: TextStyle(fontSize: 18, color: Colors.black54),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '2do apellido',
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (valor) {
                          if (valor!.isEmpty) {
                            return 'El campo contrasena es obligatorio';
                          }
                          if (valor.length<4 || valor.length>15) {
                            return 'El campo contrasena debe contener entre 4 y 15 caracteres';
                          }

                        },
                        keyboardType:TextInputType.name,
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Contrasena',
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
                      SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        child: Text(
                          'Registrarse',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        style:OutlinedButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor:  Color.fromRGBO(25,104,68, 1),
                          padding: EdgeInsets.all(13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {

                          if(_keyForm.currentState!.validate()){
                            print("validacion exitosa");
                            _signup();
                          }else{
                            print("validacion exitosa");
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
