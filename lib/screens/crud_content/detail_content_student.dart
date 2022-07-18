import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/screens/crud_content/adds/add_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// String id='';
// String nombre='';
// String email='';


class DetailContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
class DetailContentStudent extends StatefulWidget{
  static const route = '/Detail-ContentStudent';

  final String id;
  final String email;
  final String nombre;
  final String categoria;
  final String descripcion;

  DetailContentStudent({required this.id,required this.email,required this.nombre,required this.categoria,required this.descripcion});

  _DetailContentStudentState createState() => _DetailContentStudentState();
}

class _DetailContentStudentState extends State<DetailContentStudent> {
  late List data= [];
  Future<String> _getData() async {
    var datos= {"id_categoria_fk":widget.id};
    final response = await http.post(
        Uri.http("192.168.56.1", "/PPI_ANDROID/crud/gets/getSubcategoria.php"), body:json.encode(datos));


    // data = json.decode(response.body);
    this.setState(() {
      data = json.decode(response.body);
    });
    print(data[1]["nombre"]);

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
        title: Text(widget.categoria),
      ),
      drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
      body:new ListView.builder(
        itemCount: data ==null ? 0 :data.length,
        itemBuilder: (BuildContext context,int index){
          return new GestureDetector(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailContent(id: data[index]['id_subcategoria'],email: widget.email,nombre: widget.nombre,categoria: data[index]['nombre'],descripcion:data[index]['descripcion'] ,)));
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: <Widget>[
                    //     TextButton(
                    //       child: const Text('EDIT'),
                    //       onPressed: () {/* ... */},
                    //     ),
                    //     const SizedBox(width: 8),
                    //     TextButton(
                    //       child: const Text('DELETE',
                    //       style: TextStyle(color: Colors.red),
                    //       ),
                    //       onPressed: () {/* ... */},
                    //     ),
                    //     const SizedBox(width: 8),
                    //   ],
                    // ),

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
      // floatingActionButton: SpeedDial(
      //   backgroundColor: Colors.green,
      //   animatedIcon: AnimatedIcons.menu_close,
      //   children: [
      //     SpeedDialChild(
      //         onTap: (){
      //           _getData();
      //         },
      //         child: Icon(Icons.video_collection),
      //         label: 'Copiar'
      //     ),
      //     SpeedDialChild(
      //         onTap: (){
      //           // pickAndUploadFile();
      //         },
      //         child: Icon(Icons.upload),
      //         label: 'Subir contenido'
      //     ),
      //     SpeedDialChild(
      //         onTap: (){
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => AddCategory(id:widget.id))
      //           );
      //         },
      //         child: Icon(Icons.add),
      //         label: 'Añadir subcategoria'
      //     )
      //   ],
      //
      // ),
    );
  }
}



