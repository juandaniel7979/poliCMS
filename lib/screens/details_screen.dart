import 'package:app/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home_screen.dart';


class DetailsScreen extends StatelessWidget{
static const route = '/details-screen';

  // final String nombre;
    final String email;
    final String name;

  // Receiving Email using Constructor.
DetailsScreen({required this.email,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details page'),
      ),
      // drawer: MainDrawer(id:widget.id,email: email,name: name),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Estamos en la pantalla de detalles',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            FloatingActionButton(
                child: Icon(Icons.arrow_back),
                onPressed:(){
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}