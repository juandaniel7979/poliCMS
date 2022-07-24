import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/authentication/login_teacher_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GettingStarted extends StatefulWidget {
  static const routeName = '/Getting-start';

  _GettingStartedState createState() => _GettingStartedState();

}


  class _GettingStartedState extends State<GettingStarted> {
    var rol;


    @override
    void initState() {
      super.initState();
       // startPreferences();
      checkLoginStatus();
    }

    // void startPreferences() async {
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //   rol = await sharedPreferences.getString("rol");
    // }

    void checkLoginStatus() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      if(sharedPreferences.getString("token") != null && sharedPreferences.getString("rol")=="profesor" || sharedPreferences.getString("rol")=="estudiantei") {
        // Navigator.pushReplacementNamed(context, );
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
      // else if(sharedPreferences.getString("token") != null && sharedPreferences.getString("rol")=="profesor"){
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context)=>HomeScreen()));
      // }
    }

    @override
  Widget build(BuildContext context) {
  return Scaffold(
  // backgroundColor:  Color.fromRGBO(255, 203, 71, 1),
  backgroundColor:  Color.fromRGBO(0, 0, 0, 0),
  body: Container(
  padding: const EdgeInsets.all(15),
  color: Theme.of(context).primaryColor,
  width: double.infinity,
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
  Center(
  child: Text('Eres profesor o estudiante',
  style: TextStyle(
  fontSize: 26,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  SizedBox(
  height: 15,
  ),
  ElevatedButton(onPressed: (){
  Navigator.pushReplacementNamed(context, LoginScreenTeacher.routeName);
  },
  style: ElevatedButton.styleFrom(
  primary:  Color.fromRGBO(25,104,68, 1),
  padding: const EdgeInsets.all(15),
  ),
  child: Text('Profesor',
  style: TextStyle(fontSize: 22,color: Colors.white),),
  ),
  SizedBox(
  height: 15,
  ),
  ElevatedButton(onPressed: (){
  Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
  },
  style: ElevatedButton.styleFrom(
  primary:  Color.fromRGBO(25,104,68, 1),
  padding: const EdgeInsets.all(15),
  ),
  child: Text('Estudiante',
  style: TextStyle(fontSize: 22,color: Colors.white),),
  )

  ],
  ),


  ),
  );
  }
}