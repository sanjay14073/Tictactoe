
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:tic_tac_toe/roomdataprovider.dart';
import 'package:tic_tac_toe/socketclient.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/gamemethods.dart';
class Socketmethods{
  //Game Dailog box Widget
  void showGameDialog(BuildContext context, String text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  GameMethods().clearBoard(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Play Again',
                ),
              ),
            ],
          );
        });
  }

  final _socketclient=client.instance?.socket!;
  //emits here
  //if you want to convert to BLOC_state managemnts this is helpful
  Socket get socketClient => _socketclient!;
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketclient!.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }
  void joinRoom(String nickname,String roomId){
    if(nickname.isNotEmpty&&roomId.isNotEmpty){
      _socketclient!.emit('joinRoom',{
        'nickname':nickname,
        'roomId':roomId,
      });
    }
  }
  //Listiners here
  void createRoomSucess(BuildContext context){

    _socketclient!.on("createRoomSucess", (room) =>{
      Provider.of<RoomdataProvider>(context,listen: false).updateRoomData(room),
      Navigator.pushNamed(context,'/play')
    });
  }

  void joinRoomSuccess(BuildContext context){
    _socketclient!.on("joinRoomSuccess",(room)=>{
      Provider.of<RoomdataProvider>(context,listen: false).updateRoomData(room),
      Navigator.pushNamed(context,'/play')
    });
  }

  void errorOccurred(BuildContext context){
    _socketclient!.on("errorOccurred", (data) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(data,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,))
    });
  }

  //To update Players
  void updatePlayersStateListener(BuildContext context) {
    _socketclient!.on('updatePlayers', (playerData) {
      Provider.of<RoomdataProvider>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomdataProvider>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }
  //To update Rooms

  void updateRoomListener(BuildContext context) {
    _socketclient!.on('updateRoom', (data) {
      Provider.of<RoomdataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  //Gesture Detetor tapGrid
  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketclient!.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }
  void tappedListener(BuildContext context) {
    _socketclient!.on('tapped', (data) {
      RoomdataProvider roomDataProvider =
      Provider.of<RoomdataProvider>(context, listen: false);
      roomDataProvider.updateDisplayElements(
        data['index'],
        data['choice'],
      );
      roomDataProvider.updateRoomData(data['room']);
      // check winnner
      GameMethods().checkWinner(context, _socketclient!);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    print("i was called");
    _socketclient!.on('pointIncrease', (playerData) {
      var roomDataProvider =
      Provider.of<RoomdataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    print("i end game was called\n");
    _socketclient!.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
      Navigator.pushNamed(context,'/');
    });
  }
}