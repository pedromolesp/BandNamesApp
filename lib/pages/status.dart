import 'package:band_names_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit(event)
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.emit("emitir-mensaje",
              {"nombre": "Flutter", "mensaje": "Hola desde Flutter"});
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
