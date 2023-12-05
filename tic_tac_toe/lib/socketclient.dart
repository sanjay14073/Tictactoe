import 'package:socket_io_client/socket_io_client.dart' as io;
//singleton class pattern why this? to create only a single instance of the class multiple instances not supported
//TODO:tomorrow add create room try to complete project
class client{
  io.Socket?socket;
  static client? _instance;
  //private constructor
  client._internal(){
    socket=io.io('Your ip address ',<String,dynamic>{
      'transports':['websocket'],
      'autoConnect':false,
    });
    socket!.connect();
  }
  static client? get instance {
    _instance ??=client._internal();
    return _instance;
  }
}