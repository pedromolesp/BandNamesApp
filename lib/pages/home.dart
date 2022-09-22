import 'dart:io';

import 'package:band_names_app/models/banda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Banda> bandas = [
    Banda(id: "1", nombre: "Linkin Park", votes: 5),
    Banda(id: "2", nombre: "Sum 41", votes: 2),
    Banda(id: "3", nombre: "Bon Jovi", votes: 2),
    Banda(id: "4", nombre: "Evanescence", votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Band names",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bandas.length,
          itemBuilder: (context, i) => _bandaTile(bandas[i])),
      floatingActionButton: FloatingActionButton(
        onPressed: aniadirNuevaBanda,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  _bandaTile(Banda banda) {
    return Dismissible(
      onDismissed: (d) {
        print('direction');
        //TODO: llamar borrado en server
        //siguiente seccion
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Borrar banda",
              style: TextStyle(color: Colors.white),
            )),
      ),
      key: Key(banda.id),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.nombre),
        trailing: Text(
          '${banda.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {},
      ),
    );
  }

  aniadirNuevaBanda() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Nombre de nueva banda"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  elevation: 5,
                  child: Text("Añadir"),
                  textColor: Colors.blue,
                  onPressed: () => aniadirBandaALista(textController.text))
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Nuevo nombre de banda'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Añadir"),
                onPressed: () => aniadirBandaALista(textController.text),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
    }
  }

  void aniadirBandaALista(String nombre) {
    if (nombre.length > 1) {
      this
          .bandas
          .add(Banda(id: DateTime.now().toString(), nombre: nombre, votes: 3));

      setState(() {});
    }
    Navigator.pop(context);
  }
}
