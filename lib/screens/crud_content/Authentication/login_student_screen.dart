import 'package:app/screens/getting_started.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/crud_content/Authentication/signup_student_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';


String username= '';
String password = '';

class LoginScreenStudent extends StatelessWidget {
  static const routeName = '/login-student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class LoginPageStudent extends StatefulWidget{
  _LoginPageStudentState createState() => _LoginPageStudentState();
}

class _LoginPageStudentState extends State<LoginPageStudent> {
  final _keyForm = GlobalKey<FormState>();
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var jsonResponse = null;
  var msg = '';


  Future _login(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String correo = emailController.text;
    String contrasena = passwordController.text;

    var url ="https://poli-cms.herokuapp.com/api/user/login-estudiante";

    var response = await http.post(Uri.parse(url), body: {'correo': correo, 'contrasena' : contrasena});
    print(response.body);
    if(response.statusCode == 200) {
       jsonResponse = json.decode(response.body);


        sharedPreferences.setString("token", jsonResponse['data']['token']);
        sharedPreferences.setString("rol", "estudiante");
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    }
    else {
      jsonResponse = json.decode(response.body);
      msg= jsonResponse['message'];
      print(msg);
      return showDialog(
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(25,104,68, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context,GettingStarted.routeName);
          },
        ),
        title: Center(
          child:Text('Iniciar Sesion'),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        width: double.infinity,
        child: Form(
          key: _keyForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Image.network(
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/student-1.png"),
                radius: 150,
              ),

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
                  hintText: 'Correo',
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
              TextFormField(
                validator: (contrasena){
                  if(contrasena!.isEmpty){
                    'El campo no puede estar vacío';
                  }

                },
                controller: passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 18, color: Colors.black54),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Contrasena',

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
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                child: Text(
                  'Iniciar Sesion',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style:
                OutlinedButton.styleFrom(
                    backgroundColor:  Color.fromRGBO(25,104,68, 1),
                    primary: Colors.white,
                    surfaceTintColor:  Color.fromRGBO(25,104,68, 1),
                    shadowColor:  Color.fromRGBO(25,104,68, 1),
                    // backgroundColor:  Color.fromRGBO(25,104,68, 1),
                    padding: EdgeInsets.all(13),
                    side: BorderSide(color:  Color.fromRGBO(25,104,68, 1),width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
                onPressed: () async {
                  if(_keyForm.currentState!.validate()){
                    print("validacion exitosa");
                    String correo = emailController.text;
                    String contrasena = passwordController.text;
                    setState(() {
                      _isLoading = true;
                    });
                    _login(correo,contrasena);
                  }
                },
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
                style:
                OutlinedButton.styleFrom(
                    backgroundColor:  Color.fromRGBO(25,104,68, 1),
                    primary: Colors.white,
                    surfaceTintColor:  Color.fromRGBO(25,104,68, 1),
                    shadowColor:  Color.fromRGBO(25,104,68, 1),
                    // backgroundColor:  Color.fromRGBO(25,104,68, 1),
                    padding: EdgeInsets.all(13),
                    side: BorderSide(color:  Color.fromRGBO(25,104,68, 1),width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, SignupScreenStudent.routeName);
                },
              ),
              // Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
            ],
          ),
        ),
      ),
    );
  }

}

