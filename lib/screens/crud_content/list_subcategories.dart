import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/Widgets/search_widget.dart';
import 'package:app/api/subcategory_api.dart';
import 'package:app/screens/crud_content/List_content.dart';
import 'package:app/screens/crud_content/adds/add_subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:app/screens/crud_content/edits/edit_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import '../../model/subcategory.dart';

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



class ListSubcategories extends StatefulWidget{
  static const route = '/Detail-subcategory';

  final String id;
  final String id_categoria;
  final String email;
  final String nombre;
  final String categoria;
  final String descripcion;

  ListSubcategories({required this.id,required this.id_categoria, required this.email,required this.nombre,required this.categoria,required this.descripcion});

  _ListSubcategoriesState createState() => _ListSubcategoriesState();
}

class _ListSubcategoriesState extends State<ListSubcategories> {
  var rol;

  late List<Subcategory> subcategories =[];
  String query = '';
  Timer? debouncer;
  String url = "";
  final _keyForm = GlobalKey<FormState>();
  final UrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.init();
    this.getUrl();
  }
  
  void getUrl()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");

    final response = await http.get(Uri.parse("https://poli-cms.herokuapp.com/api/categoria/url?id=${widget.id_categoria}"),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      'auth-token': '${token}'});
    final res = jsonDecode(response.body);
    print(res['url']);
    setState(() {
      url = res['url'];
    });
    print(response.body);
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
    print(widget.id);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    rol = sharedPreferences.getString('rol');
    final subcategories = await SubcategoryApi.getSubcategory(query,widget.id_categoria);
    setState(() {
      this.subcategories=subcategories;
    });
  }

  Future AddUrl(String url)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    final response = await http.put(Uri.parse("https://poli-cms.herokuapp.com/api/categoria/url"),
      body: jsonEncode({'url': url,'id_categoria':widget.id_categoria}),
      headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'},
    );

    print(response.body);
    if(response.statusCode==200){
      print('Se ha actualizado con exito');
    }else{
      print('No se ha logrado actualizar');
    }

  }

  Future _DeleteElement( id_categoria) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token= sharedPreferences.getString("token");
    var datos= {"id":id_categoria};
    final response = await http.put(
        Uri.parse("https://poli-cms.herokuapp.com/api/subcategoria/borrar"),
        body:json.encode(datos),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'});
    print(response.body);

    // print(data[1]["nombre"]);

  }


  @override
  Widget build(BuildContext context) {
    if(rol=="profesor" || rol=="administrador"){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25,104,68, 1),
          title: Text(widget.categoria),
        ),
        drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
        body: Column(
            children: [
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  itemCount: subcategories ==null ? 0 :subcategories.length,
                  itemBuilder: (BuildContext context,int index){
                    return new GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => ListContent(
                              id:widget.id,
                              id_subcategoria:subcategories[index].id,
                              email: widget.email,
                              nombre: widget.nombre,
                              subcategoria: subcategories[index].nombre,
                              descripcion:subcategories[index].descripcion,
                            )
                            ));
                      },
                      child: Card(
                        child:Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.album),
                                title: Text('Subcategoria: '+subcategories[index].nombre,
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text('Descripcion: '+subcategories[index].descripcion),
                              ),
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) => subcategories[index].id_profesor==widget.id,
                                widgetBuilder: (BuildContext context) => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('EDIT'),
                                      onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>EditSubcategory(id: widget.id,
                                          id_categoria:subcategories[index].id_categoria,
                                          id_subcategoria:subcategories[index].id,
                                          email: widget.email,
                                          nombre: widget.nombre,
                                          categoria: subcategories[index].nombre,
                                          descripcion: subcategories[index].descripcion,)));
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      child: const Text('DELETE',
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

                                                    _DeleteElement(subcategories[index].id);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion,id_categoria: subcategories[index].id_categoria,))
                                                    );
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
                                fallbackBuilder: (BuildContext context) => Text(''),
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
                child: Conditional.single(
                  context: context,
                  conditionBuilder: (BuildContext context) => url=="",
                  widgetBuilder: (BuildContext context) => Icon(Icons.folder),
                  fallbackBuilder: (BuildContext context) => Icon(Icons.launch),
                ),
                onLongPress: (){openDialog();},
                label: url==""? "Añadir enlace de drive":"Redirigir a drive",
                onTap:() async{
                  if(url==""){
                    openDialog();
                  }else{
                    await openBrowseURL( url: 'https://drive.google.com/drive/folders/1WPsk7EmYGzCUAz1lQ6n1qidvUYIPBKuD?usp=sharing');
                  }
                }
            ),
            SpeedDialChild(
                onTap: (){
                  Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => AddSubcategory(id:widget.id))
                      MaterialPageRoute(builder: (context) => AddSubcategory(id:widget.id,id_categoria:widget.id_categoria,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion))
                  );
                },
                child: Icon(Icons.add),
                label: 'Añadir subcategoria'
            )
          ],

        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25,104,68, 1),
          title: Text(widget.categoria),
        ),
        drawer: MainDrawer(id:widget.id,email:widget.email,nombre: widget.nombre),
        body: Column(
            children: [
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  itemCount: subcategories ==null ? 0 :subcategories.length,
                  itemBuilder: (BuildContext context,int index){
                    return new GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => ListContent(
                              id:widget.id,
                              id_subcategoria:subcategories[index].id,
                              email: widget.email,
                              nombre: widget.nombre,
                              subcategoria: subcategories[index].nombre,
                              descripcion:subcategories[index].descripcion,
                            )
                            ));
                      },
                      child: Card(
                        child:Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.album),
                                title: Text('Subcategoria: '+subcategories[index].nombre,
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text('Descripcion: '+subcategories[index].descripcion),
                              ),
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) => subcategories[index].id_profesor==widget.id,
                                widgetBuilder: (BuildContext context) => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('EDIT'),
                                      onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>EditSubcategory(id: widget.id,
                                          id_categoria:subcategories[index].id_categoria,
                                          id_subcategoria:subcategories[index].id,
                                          email: widget.email,
                                          nombre: widget.nombre,
                                          categoria: subcategories[index].nombre,
                                          descripcion: subcategories[index].descripcion,)));
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      child: const Text('DELETE',
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

                                                    _DeleteElement(subcategories[index].id);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ListSubcategories(id:widget.id,email: widget.email,nombre: widget.nombre,categoria: widget.categoria,descripcion:widget.descripcion,id_categoria: subcategories[index].id_categoria,))
                                                    );
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
                                fallbackBuilder: (BuildContext context) => Text(''),
                              ),


                            ]),
                      ),
                    );

                  },
                ),
              ),
            ]
        ),
      );
    }
  }




  Widget buildSearch()=>SearchWidget(
      text: query,
      onChanged: searchSubcategory,
      hintText: 'Titulo de la subcategoria');

  void searchSubcategory(String query)async =>debounce(() async {
   final subcategorias = await SubcategoryApi.getSubcategory(query,widget.id_categoria);

   if(!mounted)return;
    setState(() {
      this.query =query;
      this.subcategories = subcategorias;
    });
  });

  Future openBrowseURL({required String url,})async{
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url),);
    }
  }
  Future openDialog() => showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      title: Text('Agregar repositorio de drive'),
      content: Form(
        key: _keyForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (valor){
                RegExp regExp = new RegExp(r'(http|https):\/\/drive.google.com\/drive\/folders\/[^?]*\?usp=sharing');
                if(valor!.isEmpty){
                  return 'Este campo no puede estar vacío';
                }else if (!regExp.hasMatch(valor)){
                  return "Ingresa una url valida";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Ingresa la url del drive"
              ),
              controller: UrlController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child:Text('Cancel')),
        TextButton(
            onPressed: ()async {
              if(_keyForm.currentState!.validate()){
                await AddUrl(UrlController.text);
                getUrl();
                Navigator.pop(context);
              }
              else{
                print("validacion erronea");
              }
            },
            child:Text('SUBMIT'))
      ],
    ),
  );



}


