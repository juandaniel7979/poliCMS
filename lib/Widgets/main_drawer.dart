
import 'package:app/main.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../screens/details_screen.dart';
import '../screens/getting_started.dart';


class MainDrawer extends StatelessWidget{

  final String email;
  final String name;
  final String id;

// Receiving Email using Constructor.
  MainDrawer({required this.id,required this.email,required this.name});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 30,
            ),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:DecorationImage(
                        image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                        ),
                        fit: BoxFit.fill
                      ),
                    ),
                  ),
                  Text(name,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Text(email,
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
            title: Text('Home',
              style: TextStyle(fontSize: 18
              ),
            ),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(id:id,email :email,name: name))
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile',
              style: TextStyle(fontSize: 18
              ),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings',
              style: TextStyle(fontSize: 18
              ),
            ),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(DetailsScreen.route);
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('logout',
              style: TextStyle(fontSize: 18,
              ),
            ),
            onTap: (){
              // Navigator.of(context).popAndPushNamed(GettingStarted.routeName);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => GettingStarted()), (Route<dynamic> route) => false);
            },
          ),
          Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26))),
          ),
          ListTile(
            // leading: Icon(Icons.arrow_back),
            title: Text('Categorias',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
              ),
            ),
            onTap: null,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black26))),
          ),
          ListTile(
            // leading: Icon(Icons.arrow_back),
            title: Text('Tecnologia',
              style: TextStyle(fontSize: 18
              ),

            ),
            onTap: null,
          ),
          ListTile(
            // leading: Icon(Icons.arrow_back),
            title: Text('Tecnica',
              style: TextStyle(fontSize: 18
              ),

            ),
            onTap: null,
          ),
          ListTile(
            // leading: Icon(Icons.arrow_back),
            title: Text('Criterios de evaluacion TyT',
              style: TextStyle(fontSize: 18
              ),

            ),
            onTap: null,
          ),
          ListTile(
            // leading: Icon(Icons.arrow_back),
            title: Text('Otros documentos de apoyo',
              style: TextStyle(fontSize: 18
              ),

            ),
            onTap: null,
          ),
          ListTile(
            // leading: Icon(Icons.arrow_back),
            title: Text('Preguntas frecuentes',
              style: TextStyle(fontSize: 18
              ),
            ),
            onTap: null,
          ),


        ],
      ),
    );
  }
}

