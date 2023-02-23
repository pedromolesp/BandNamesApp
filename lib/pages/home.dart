import 'dart:io';

import 'package:band_names_app/models/banda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Banda> bandas = [
    // Banda(id: "1", name: "Linkin Park", vote: 5),
    // Banda(id: "2", name: "Sum 41", vote: 2),
    // Banda(id: "3", name: "Bon Jovi", vote: 2),
    // Banda(id: "4", name: "Evanescence", vote: 4),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload) {
      this.bandas =
          (payload as List).map((band) => Banda.fromMap(band)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Band names",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
          )
        ],
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
          child: Text(banda.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.name),
        trailing: Text(
          '${banda.vote}',
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
          .add(Banda(id: DateTime.now().toString(), name: nombre, vote: 3));

      setState(() {});
    }
    Navigator.pop(context);
  }
}
