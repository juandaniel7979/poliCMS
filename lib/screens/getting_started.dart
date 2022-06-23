import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/crud_content/authentication/login_teacher_screen.dart';
import 'package:flutter/material.dart';


class GettingStarted extends StatelessWidget{
static const routeName = '/Getting-start';

@override
Widget build(BuildContext context) {
return Scaffold(
      backgroundColor: Colors.white,
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
              primary: Colors.green,
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
                primary: Colors.green,
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