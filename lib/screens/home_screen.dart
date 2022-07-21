import 'dart:convert';
import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// String id='';
// String nombre='';
// String email='';
class HomeScreen extends StatefulWidget {
  static const route = '/HomeScreen-teacher';

  final String id;
  final String email;
  final String nombre;

  HomeScreen({required this.id, required this.email, required this.nombre});

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
String id="";
String nombre="";
String correo="";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var  token = sharedPreferences.getString('token');
    var url='http://192.168.56.1:3002/api/user/profesor';
    final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'auth-token': '${token}'
        }
    );
    var res = jsonDecode(response.body);
    print(response.body);
    print(res['id']);
    print(res.toString());
    setState(() {
      id=res['id'];
      nombre=res['nombre'];
      correo=res['email'];
    });



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      // drawer: MainDrawer(id:widget.id,email: widget.email, nombre: widget.nombre),
      drawer: MainDrawer(id:id,email: correo, nombre: nombre),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/images/searching.png",
              // "assets/images/enroll.png",
              // height: 180,
            ),
            // SizedBox(
            //   height: 45,
            // ),
            Center(
              child: Text('Empieza a explorar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22,),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: OutlinedButton(
                child: Text(
                  'Explorar',
                  style: TextStyle(
                      fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold
                  ),
                ),
                style:
                OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Explorer(id:widget.id,email: widget.email,nombre: widget.nombre))
                  );
                }
              ),
            ),
            SizedBox(
              height: 25,
            ),
            
          ],
        ),
      ),
    );
  }

  Future openBrowseURL({required String url,})async{
    if(await canLaunchUrl(Uri.parse(url))){
        await launchUrl(Uri.parse(url),);
    }
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: Text('Agregar categoria'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Ingresa el nombre de la categoria"
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
