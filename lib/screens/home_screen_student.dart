import 'package:app/screens/access_code.dart';
import 'package:app/screens/crud_content/detail_content_student.dart';
import 'package:app/screens/getting_started.dart';
import 'package:flutter/material.dart';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/fab_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import './details_screen.dart';
import 'crud_content/Authentication/login_student_screen.dart';
// import './ExpandableFab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreenStudent extends StatefulWidget {

  static const route = '/HomeScreen-Student';

  // final String nombre;
  final String id;
  final String email;
  final String nombre;

// Receiving Email using Constructor.
  HomeScreenStudent(
      {required this.id, required this.email, required this.nombre});

  // HomeScreen({this.username});
  // final String username;

  _HomeScreenStudentState createState() => _HomeScreenStudentState();
  }



  class _HomeScreenStudentState extends State<HomeScreenStudent> {
  late List data= [];
  Future<String> _getData() async {
  var datos= {"id_profesor_fk": 1};
  final response = await http.post(
  Uri.http("192.168.56.1", "/PPI_ANDROID/crud/gets/getCategoria.php"), body:json.encode(datos));


  // data = json.decode(response.body);
  this.setState(() {
  data = json.decode(response.body);
  });
  // print(data[1]["nombre"]);

  return "Success!";
  }

  @override
  void initState() {
  super.initState();
  this._getData();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Home page'),
  ),
  drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
  body: new ListView.builder(
  itemCount: data ==null ? 0 :data.length,
  itemBuilder: (BuildContext context,int index){
  return new GestureDetector(
  onTap: (){
  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailContentStudent(id: data[index]['id_categoria'],email: widget.email,nombre: widget.nombre,categoria: data[index]['nombre'],descripcion:data[index]['descripcion'] ,)));
  },
  child: Card(
  child:Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
  ListTile(
  leading: Icon(Icons.album),
  title: Text('Categoria: '+data[index]['nombre'],
  style: TextStyle(fontWeight: FontWeight.bold),),
  subtitle: Text('Descripcion: '+data[index]['descripcion']),
  ),

  ]),
  // EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
  // color: Colors.white,
  // elevation: 5.0,
  // child: Center(
  //     child: Text('id: '+data[index]['id_categoria']+'\nCategoria: '+data[index]['nombre']+'\nDescripcion: '+data[index]['descripcion'])
  // ),
  ),
  );

  },
  ),
  floatingActionButton: FloatingActionButton(
  onPressed: (){

  },
  child: Icon(Icons.add),
  ),
  );
  }
  }

