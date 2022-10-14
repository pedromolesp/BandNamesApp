import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Offline, Connecting, Online }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  get serverStatus => this._serverStatus;
  SocketService() {
    this.initConfig();
  }

  void initConfig() {
    IO.Socket socket = IO.io('http://192.168.15.242:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    socket.on("nuevo-mensaje", (payload) {
      print('Nuevo mensaje $payload');
      print('Nombre' + payload['nombre']);
      print('Mnesaje' + payload['mensaje']);
      print(payload.containsKey('mensaje2')
          ? payload['mensaje2']
          : "No hay mensaje2");
    });
  }
}
