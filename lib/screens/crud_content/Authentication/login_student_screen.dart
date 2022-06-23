import 'package:app/screens/home_screen.dart';
import 'package:app/screens/home_screen_student.dart';
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
  var msg = '';


  Future _login(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Map data = {
    //   'email': email,
    //   'password': pass
    // };
    String correo = emailController.text;
    String contrasena = passwordController.text;
    var jsonResponse = null;
    var url ="https://poli-cms.herokuapp.com/api/user/login-estudiante";

    var response = await http.post(Uri.parse(url), body: {'correo': correo, 'contrasena' : contrasena});
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response body ${jsonResponse['data']['user']['_id']}');
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['data']['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeScreen(id:jsonResponse['data']['user']['_id'],email: jsonResponse['data']['user']['correo'],name: jsonResponse['data']['user']['nombre']+' '+jsonResponse['data']['user']['nombre_2']+' '+jsonResponse['data']['user']['apellido']+' '+jsonResponse['data']['user']['apellido_2'] )), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child:Text('Iniciar Sesion'),
        ),
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: Form(
          key: _keyForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Image.network(
              //   'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
              //   height: 180,
              // ),
              Image.asset("assets/images/login.png",
                height: 180
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
                controller: emailController,
                validator: (email)=> email != null && !EmailValidator.validate(email)
                    ?'Ingresa un email válido'
                    :null,
                style: TextStyle(fontSize: 18, color: Colors.black54),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
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
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 18, color: Colors.black54),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Contrasena',
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
              FlatButton(
                child: Text(
                  'Iniciar Sesion',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(15),
                textColor: Colors.white,
                onPressed: () {
                  if(_keyForm.currentState!.validate()){
                    print("validacion exitosa");
                    String correo = emailController.text;
                    String contrasena = passwordController.text;
                    setState(() {
                      _isLoading = true;
                    });
                    _login(correo,contrasena);
                  }else{
                    print("validacion fallida");
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(15),
                textColor: Colors.white,
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

