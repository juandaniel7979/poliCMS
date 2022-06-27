import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/main.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// String id='';
// String name='';
// String email='';


class ListContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
class ListContent extends StatefulWidget{
  static const route = '/list-content';

  final String id;
  final String id_subcategoria;
  final String email;
  final String name;
  final String subcategoria;
  final String descripcion;

  ListContent({required this.id,required this.id_subcategoria, required this.email,required this.name,required this.subcategoria,required this.descripcion});

  _ListContentState createState() => _ListContentState();
}

quill.QuillController _controller = quill.QuillController.basic();

class _ListContentState extends State<ListContent> {
  late List data= [];
  late List descripcion= [];
  // late Map<String,dynamic> descripcion2='';

  String MyJson = '';

  void _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var url='https://poli-cms.herokuapp.com/api/contenido/contenidos?id=${widget.id_subcategoria}';
    var url='https://poli-cms.herokuapp.com/api/contenido/contenido';
    // print(url);
    var token= sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(url),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
    );
    var res = jsonDecode(response.body);
    // print(res);
    this.setState(() {
      data = res['contenido'];
      descripcion= res['contenido']['descripcion_2'];
      // MyJson= jsonEncode(res['contenido']['descripcion_2']);
      // descripcion2 = map(res['contenido']['descripcion_2']);
      // res['contenido']['descripcion_2'].toString();
      // descripcion=jsonDecode(descripcion2);
      // MyJson =jsonDecode(res['contenido']['descripcion_2']);
    });

    // print(res['contenido']['descripcion_2'].toString());
    // print(res['contenido']['descripcion_2'][0]);
    // print('el tamano de la lista es: ${descripcion.length}');


    // return res['contenido']['descripcion_2'];

  }

  void getDescripcionesQuill(){
    List<Widget> quillPlantilla = [];

    for (var i = 0; i < descripcion.length; i++) {

    }
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
        title: Text(widget.subcategoria +'list'),
      ),
      drawer: MainDrawer(id:widget.id,email:widget.email,name: widget.name),
      body:new ListView.builder(
        itemCount: data ==null ? 0 :data.length,
        itemBuilder: (BuildContext context,int index){
          return new Column(
              children: [
                Expanded(
                    child:Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.lightBlueAccent,
                              //   offset:const Offset(5.0, 5.0),
                              //   blurRadius:10.0,
                              //   spreadRadius:2.0
                              // ),
                              BoxShadow(
                                color: Colors.white,
                                offset:const Offset(-5.5, 0.0,),
                                blurRadius:0.0,
                                spreadRadius:0.0,
                              ),
                            ]
                        ),
                        child: quill.QuillEditor.basic(controller: _controller = quill.QuillController(document: quill.Document.fromDelta(jsonDecode(jsonEncode(data[index]['descripcion_2']))), selection: TextSelection.collapsed(offset: 0)), readOnly: false),
                      ),
                    )
                ),
              ]
          );

        },
      ),


      floatingActionButton: SpeedDial(
        backgroundColor: Colors.green,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              onTap: (){
                _getData();
              },
              child: Icon(Icons.video_collection),
              label: 'Copiar'
          ),
          SpeedDialChild(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContent(id:widget.id,id_subcategoria:widget.id_subcategoria)));
              },
              child: Icon(Icons.upload),
              label: 'Añadir contenido'
          ),
        ],

      ),
    );
  }
}



