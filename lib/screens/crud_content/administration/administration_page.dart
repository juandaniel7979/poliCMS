import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/search_widget.dart';
import 'package:app/api/teacher_api.dart';
import 'package:app/model/teacher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Listteachers extends StatefulWidget{
  static const routeName = '/teacher-without-verify';

  final String email;
  final String nombre;
  final String id;

  Listteachers({required this.email,required this.nombre,required this.id});

  _ListteachersState createState() => _ListteachersState();
}

class _ListteachersState extends State<Listteachers> {

  late List<Teacher> teachers =[];
  String query = '';
  Timer? debouncer;
  String url = "";
  final UrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final teachers = await TeacherApi.getTeacher(query);
    setState(() {
      this.teachers=teachers;
    });
  }

  Future _ApproveTeacher( id_profesor) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    var datos= {"id_profesor":id_profesor};
    final response = await http.put(
        Uri.parse("http://192.168.56.1:3002/api/user/aprobar"),
        body:json.encode(datos),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);
  }

  Future _RejectTeacher( id_profesor) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    var datos= {"id_profesor":id_profesor};
    final response = await http.put(
        Uri.parse("http://192.168.56.1:3002/api/user/rechazar"),
        body:json.encode(datos),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(25,104,68, 1),
        title: Text('Administrar usuarios'),
      ),
      drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
      body: Column(
          children: [
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: teachers ==null ? 0 :teachers.length,
                itemBuilder: (BuildContext context,int index){
                  return new GestureDetector(
                    onTap: (){
                      
                    },
                    child: Card(
                      child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.album),
                              title: Text('Nombre: '+teachers[index].nombre,
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text('correo: '+teachers[index].correo),
                            ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('APROBAR'),
                          onPressed: () {
                            _ApproveTeacher(teachers[index].id);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>Listteachers(email: widget.email, nombre: widget.nombre, id: widget.id)));
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('Rechazar',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  title: const Text('Eliminar'),
                                  content: const Text('Está seguro que desea eliminar este elemento?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      // onPressed: () => Navigator.pop(context, 'OK'),
                                      onPressed: () {
                                        _RejectTeacher(teachers[index].id);
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=>Listteachers(email: widget.email, nombre: widget.nombre, id: widget.id)));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                            // showAlertDialog(context,data[index]['id_subcategoria']
                            // );
                            // },
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ),


                          ]),
                    ),
                  );

                },
              ),
            ),
          ]
      ),
      floatingActionButton: SpeedDial(
        backgroundColor:  Color.fromRGBO(25,104,68, 1),
        animatedIcon: AnimatedIcons.menu_close,
        children: [

          SpeedDialChild(
              onTap: (){
              },
              child: Icon(Icons.add),
              label: 'Agregar Subtematica'
          )
        ],

      ),
    );
  }




  Widget buildSearch()=>SearchWidget(
      text: query,
      onChanged: searchTeacher,
      hintText: 'Nombre o correo del profesor');

  void searchTeacher(String query)async =>debounce(() async {
    final teachers = await TeacherApi.getTeacher(query);

    if(!mounted)return;
    setState(() {
      this.query =query;
      this.teachers = teachers;
    });
  });






}


