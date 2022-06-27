import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/main.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
// String id='';
// String name='';
// String email='';


class DetailContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
class DetailContent extends StatefulWidget{
  static const route = '/Detail-Content';

  final String id;
  final String id_subcategoria;
  final String email;
  final String name;
  final String subcategoria;
  final String descripcion;

  DetailContent({required this.id,required this.id_subcategoria, required this.email,required this.name,required this.subcategoria,required this.descripcion});

  _DetailContentState createState() => _DetailContentState();
}

quill.QuillController _controller = quill.QuillController.basic();

class _DetailContentState extends State<DetailContent> {
  late List data= [];
  late List descripcion= [];
  String content='';
  // late Map<String,dynamic> descripcion2='';

  String MyJson = '';

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  Future <String> get getRoute async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future <File> get getFile async{
    final file= await getRoute;
    return File('${file}/archivo.txt');
  }

Future <String> readFile() async{
    try{
      final file = await getFile;
      String content = await file.readAsStringSync();
      return content;
    }catch(e){
        print(e);
        return '';
    }
  }

  Future<File> writeFile(String content) async{
    final file =  await getFile;
    return file.writeAsString(content);
  }


   Future<List> _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var url='https://poli-cms.herokuapp.com/api/contenido/contenidos?id=${widget.id_subcategoria}';
    // var url='https://poli-cms.herokuapp.com/api/contenido/contenidos/id=62a9548b6adf304f2aecb54b}';
    var url='http://192.168.1.1:3002/api/contenido/contenidos?id=62a9548b6adf304f2aecb54b';
    // print(url);
    var token= sharedPreferences.getString("token");
    List DataJson= [];

    try{
      final response = await http.get(
          Uri.parse(url),
          headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
      );
      var res = jsonDecode(response.body);
      final line = response.body.toString();
      // final regex = RegExp(r'_2":[^]]*]');
      final regex = RegExp(r'_2":[^]*]');
      final match = regex.firstMatch(line);
      final everything = match?.group(0);
      var extraccion = everything.toString().replaceAll('_2":',"");
      final result = await rootBundle.loadString('assets/file.json');

      final lista = jsonEncode(extraccion);
      var prueba;
      try{
         prueba = jsonDecode(extraccion);
      }catch(e){
        print('error ');
        print(e);
      }
      try{
        // final doc = quill.Document.fromJson((jsonDecode(DataJson.toString())));
        print('entro aqui');
        final doc = quill.Document.fromJson(jsonDecode(result));
        this.setState(() {
          _controller = quill.QuillController(
              document: doc, selection: const TextSelection.collapsed(offset: 0));
        });
      }catch(e){
        print('luego aqui');
        // final doc = quill.Document()..insert(0, 'Empty asset');
        // setState(() {
        //   _controller = quill.QuillController(
        //       document: doc, selection: const TextSelection.collapsed(offset: 0));
        // });
      }
      // this.setState(() {
      //   data = res['contenido'];
      //   descripcion= res['contenido']['descripcion_2'];
      // });

      // print( descripcion.runtimeType);

      return DataJson ;

    }catch (e){
      print(e);
    }
    return DataJson;





    // print(res['contenido']['descripcion_2'].toString());
    // print(res['contenido']['descripcion_2'][0]);
    // print('el tamano de la lista es: ${descripcion.length}');


    // return res['contenido']['descripcion_2'];

  }

  @override
  void initState() {
    super.initState();
    this._getData();
    
  }

  String Lista(List lista){
     if(lista==null){
       return 'Texto';
     }else{
       return 'Lleno';
     }

  }
  List<dynamic> ListaDatos(List<dynamic> lista){
     if(lista==null){
       return [];
     }else{
       return lista;
     }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subcategoria),
      ),
      drawer: MainDrawer(id:widget.id,email:widget.email,name: widget.name),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            //Barra de herramientas
            child: quill.QuillToolbar.basic(controller: _controller),
          ),
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
                  child: quill.QuillEditor.basic(controller: _controller, readOnly: false),
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: (){
                _controller.document.delete(0, _controller.document.length);
                print(jsonEncode(_controller.document.toDelta().toJson()));
                print(_controller.document.toPlainText());
              }, child:Text('Eliminar contenido',style:TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                style:
                OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
                // Text('Añadir contenido',textS)
              ),
              OutlinedButton(onPressed: (){
                var Myjson= jsonEncode(_controller.document.toDelta().toJson());
                print('el json');
                print(_controller.document.toDelta().toJson());
                print('en texto plano');
                print(_controller.document.toPlainText());
                // var jsonObj = json.
                print(Myjson);
              }, child:Text('Agregar contenido',style:TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                style:
                OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
                // Text('Añadir contenido',textS)
              ),
            ],
          ),

        ],
      ),
      // Column(
      //     children: [
      //       Expanded(
      //           child:Padding(
      //             padding: const EdgeInsets.all(7.0),
      //             child: Container(
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(5),
      //                     boxShadow: [
      //                       // BoxShadow(
      //                       //   color: Colors.lightBlueAccent,
      //                       //   offset:const Offset(5.0, 5.0),
      //                       //   blurRadius:10.0,
      //                       //   spreadRadius:2.0
      //                       // ),
      //                       BoxShadow(
      //                         color: Colors.white,
      //                         offset:const Offset(-5.5, 0.0,),
      //                         blurRadius:0.0,
      //                         spreadRadius:0.0,
      //                       ),
      //                     ]
      //                 ),
      //                 child:Text(descripcion[]['descripcion'])
      //               // quill.QuillEditor.basic(controller: _controller = quill.QuillController(document: quill.Document.fromJson(jsonDecode(jsonEncode(descripcion))), selection: TextSelection.collapsed(offset: 0)), readOnly: false),
      //             ),
      //           )
      //       ),
      //     ]
      // ),



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



