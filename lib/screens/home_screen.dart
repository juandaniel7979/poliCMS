import 'dart:io';
import 'package:app/Widgets/main_drawer.dart';
import 'package:app/screens/crud_content/adds/add_category.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late List data = [];
  Future<List> _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url='https://poli-cms.herokuapp.com/api/categoria/categorias?id=${widget.id}';
    // print(url);
    var token= sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(url),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
    );
    var res = jsonDecode(response.body);
    this.setState(() {
      data = res['categoria'];
    });

    return res['categoria'];
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
      drawer: MainDrawer(id:widget.id,email: widget.email, nombre: widget.nombre),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListSubcategories(
                            id: widget.id,
                            id_categoria:data[index]['_id'],

                            email: widget.email,
                            nombre: widget.nombre,
                            categoria: data[index]['nombre'],
                            descripcion: data[index]['descripcion'],
                          )));
            },
            child: Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(
                    'Categoria: ' + data[index]['nombre'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Descripcion: ' + data[index]['descripcion']),
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
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.green,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              onTap: () {
                openDialog();
              },
              child: Icon(Icons.copy),
              label: 'Copiar'),
          SpeedDialChild(
              onTap: () async{
               // await LaunchApp.openApp(
               //      androidPackageName: 'com.google.android.apps.docs',
               //      // iosUrlScheme: 'pulsesecure://',
               //      openStore: true,
               //      // appStoreLink:
               //      // 'itms-apps://https://drive.google.com/drive/folders/1WPsk7EmYGzCUAz1lQ6n1qidvUYIPBKuD?usp=sharing',
               //      // openStore: false
               //  );
                await openBrowseURL( url: 'https://drive.google.com/drive/folders/1WPsk7EmYGzCUAz1lQ6n1qidvUYIPBKuD?usp=sharing');
               //  String dt = "drive";
               //  bool isInstalled = await DeviceApps.isAppInstalled('com.google.android.gms.drive');
               //  if (isInstalled != false)
               //  {
               //    AndroidIntent intent = AndroidIntent(
               //        action: 'action_view',
               //        data: dt
               //    );
               //    await intent.launch();
               //  }
               //  else
               //  {
               //    String url = dt;
               //    if (await canLaunchUrl(Uri.parse(url)))
               //      await launch(url);
               //    else
               //      throw 'Could not launch $url';
               //  }
              },
              child: Icon(Icons.drive_eta_outlined),
              label: 'Copiar'),
          SpeedDialChild(
              onTap: () {},
              child: Icon(Icons.upload),
              label: 'Subir contenido'),
          SpeedDialChild(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCategory(id: widget.id,nombre: widget.nombre,email: widget.email)));
              },
              child: Icon(Icons.add),
              label: 'Add category')
        ],
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
