import 'dart:io';

import 'package:band_names_app/models/banda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
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
      _handleActiveBands(payload);
    });
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bandas = (payload as List).map((band) => Banda.fromMap(band)).toList();
    setState(() {});
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
      body: Column(
        children: [_buildGraph(), _buildList()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: aniadirNuevaBanda,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  _buildList() {
    return Expanded(
      child: ListView.builder(
          itemCount: bandas.length,
          itemBuilder: (context, i) => _bandaTile(bandas[i])),
    );
  }

  _bandaTile(Banda banda) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': banda.id}),
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
      key: UniqueKey(),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': banda.id}),
      ),
    );
  }

  aniadirNuevaBanda() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
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
        ),
      );
    }
  }

  void aniadirBandaALista(String nombre) {
    if (nombre.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('create-band', {'name': nombre});
    }
    Navigator.pop(context);
  }

  _buildGraph() {
    Map<String, double> dataMap = new Map();
    bandas.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.vote.toDouble());
    });
    final List<Color> colores = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!
    ];
    return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          colorList: colores,
          initialAngleInDegree: 0,
          ringStrokeWidth: 32,
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.left,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }
}
