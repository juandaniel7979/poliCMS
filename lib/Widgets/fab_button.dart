import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Fab_button extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
        return SpeedDial(
      backgroundColor: Colors.green,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
          child: Icon(Icons.copy),
          label: 'Copiar'
        ),
        SpeedDialChild(
            child: Icon(Icons.upload),
            label: 'Subir contenido'
        ),
        SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Add category'
        )
      ],

    );

  }
}