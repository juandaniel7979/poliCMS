
import 'package:app/main.dart';
import 'package:app/screens/crud_content/administration/administration_page.dart';
import 'package:app/screens/explore.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/my_categories.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/details_screen.dart';
import '../screens/getting_started.dart';


class MainDrawer extends StatefulWidget{

  final String email;
  final String nombre;
  final String id;

  MainDrawer({required this.id,required this.email,required this.nombre});

  _MainDrawerState createState() => _MainDrawerState();
}

// Receiving Email using Constructor.

class _MainDrawerState extends State<MainDrawer> {
  var rol;
  Future GetRol()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final rol =await sharedPreferences.getString('rol');
    print(rol);

    setState(() {
      this.rol=rol;
    });
  }

  @override
  void initState() {
    super.initState();
    GetRol();
  }

  @override
  Widget build(BuildContext context) {
    if(rol=="administrador"){
      return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 30,
              ),
              color:  Color.fromRGBO(25,104,68, 1),
              child: Center(
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   width: 100,
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //   // color: Colors.white,
                    //     shape: BoxShape.circle,
                    //     image:DecorationImage(
                    //       image: NetworkImage(
                    //         'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                    //       ) ,
                    //       fit: BoxFit.fill,
                    //
                    //
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(widget.nombre,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text(widget.email,
                      style: TextStyle(
                        color: Colors.white,
                      ),

                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Explorar',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Explorer(id:widget.id,email:widget.email,nombre:widget.nombre))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Verificar usuarios',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Listteachers(id:widget.id,email:widget.email,nombre:widget.nombre))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.all_inbox_sharp),
              title: Text('Mis tematicas',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCategories(id:widget.id,email:widget.email,nombre:widget.nombre))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Cerrar Sesion',
                style: TextStyle(fontSize: 18,
                ),
              ),
              onTap: ()async{
                // Navigator.of(context).popAndPushNamed(GettingStarted.routeName);
                SharedPreferences sharedPreferences;
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                // sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => GettingStarted()), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      );
    }else if(rol=="profesor"){
      return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 30,
              ),
              color:  Color.fromRGBO(25,104,68, 1),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(widget.nombre,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text(widget.email,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Explorar',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Explorer(id:widget.id,email:widget.email,nombre:widget.nombre))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.all_inbox_sharp),
              title: Text('Mis tematicas',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCategories(id:widget.id,email:widget.email,nombre:widget.nombre))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Cerrar Sesion',
                style: TextStyle(fontSize: 18,
                ),
              ),
              onTap: ()async{
                // Navigator.of(context).popAndPushNamed(GettingStarted.routeName);
                SharedPreferences sharedPreferences;
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                // sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => GettingStarted()), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      );
    }else{
      return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 30,
              ),
              color:  Color.fromRGBO(25,104,68, 1),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(widget.nombre,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text(widget.email,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Explorar',
                style: TextStyle(fontSize: 18
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Explorer(id:widget.id,email:widget.email,nombre:widget.nombre))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Cerrar Sesion',
                style: TextStyle(fontSize: 18,
                ),
              ),
              onTap: ()async{
                // Navigator.of(context).popAndPushNamed(GettingStarted.routeName);
                SharedPreferences sharedPreferences;
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                // sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => GettingStarted()), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      );
    }
    
  }
}

