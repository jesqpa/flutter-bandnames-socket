import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket
      _socket; /*= IO.io('http://192.168.0.100:3000', {
    'transports': ['websocket'],
    'autoConnect': true
  });*/

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://192.168.0.100:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje: ' + payload["mensaje"]);
      print('nuevo-mensaje: ' + payload["nombre"]);
      print('nuevo-mensaje: ' + payload["uid"]);
    });
  }
}
