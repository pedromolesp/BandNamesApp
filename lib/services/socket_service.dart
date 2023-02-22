import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Offline, Connecting, Online }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;
  SocketService() {
    this.initConfig();
  }

  void initConfig() {
    this._socket = IO.io('http://192.168.0.104:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.on("active-bands", (payload) {
      print(payload);
    });

    this._socket.on("nuevo-mensaje", (payload) {
      print('Nuevo mensaje $payload');
      print('Nombre' + payload['nombre']);
      print('Mnesaje' + payload['mensaje']);
      print(payload.containsKey('mensaje2')
          ? payload['mensaje2']
          : "No hay mensaje2");
    });
  }
}
