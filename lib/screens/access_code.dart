// import 'package:app/screens/getting_started.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:app/Widgets/main_drawer.dart';
// import 'package:app/Widgets/fab_button.dart';
// import './details_screen.dart';
// import './login_student_screen.dart';
// import './ExpandableFab.dart';

class AccessCode extends StatelessWidget{

  final String id;
  final String email;
  final String name;

// Receiving Email using Constructor.
  AccessCode({required this.id,required this.email,required this.name});

  static const routeName = '/access-code';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unirse a una clase'),
      ),
      // drawer: MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/images/enroll.png",
              height: 180,
            ),
            SizedBox(
              height: 45,
            ),
            Center(
              child: Text('Ingresa un codigo para acceder a las secciones',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22,),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              style: TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Codigo de acceso',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,
                  width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
                FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed:(){
                      Navigator.pop(context);
                    }),
            // RaisedButton(
            //     child: Text('Detalle s'),
            //     onPressed: (){
            //       Navigator.of(context).pushNamed(DetailsScreen.route);
            //     }
            // ),
            // RaisedButton(
            //     child: Text('Login'),
            //     onPressed: (){
            //       Navigator.of(context).pushNamed(LoginScreen.routeName);
            //     }
            // ),
          ],
        ),


      ),
      // floatingActionButton:  FloatingActionButton(
      //     child: Icon(Icons.arrow_back),
      //     onPressed:(){
      //       Navigator.pop(context);
      //     }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Navigator.pushReplacementNamed(context, routeName)
      //   },
      // )
    );
  }
}