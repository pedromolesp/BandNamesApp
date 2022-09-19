import 'package:band_names_app/models/banda.dart';
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
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bandas.length,
          itemBuilder: (context, i) => _bandaTile(bandas[i])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  ListTile _bandaTile(Banda banda) {
    return ListTile(
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
    );
  }
}
