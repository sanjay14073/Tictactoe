import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/Colors.dart';
import 'package:tic_tac_toe/roomdataprovider.dart';
import 'package:tic_tac_toe/socketmethods.dart';
class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Socketmethods m=Socketmethods();
  void tapped(int index, RoomdataProvider roomDataProvider) {
    m.tapGrid(
      index,
      roomDataProvider.roomData['_id'],
      roomDataProvider.displayElements,
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m.tappedListener(context);
    m.updateRoomListener(context);
    m.updatePlayersStateListener(context);

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RoomdataProvider roomdataProvider=Provider.of<RoomdataProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:bgColor,
        body:Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    roomdataProvider.player1.nickname,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    roomdataProvider.player1.points.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    roomdataProvider.player2.nickname,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    roomdataProvider.player2.points.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          ),


            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.7,
                maxWidth: 500,
              ),
              child: AbsorbPointer(
                absorbing: roomdataProvider.roomData['turn']['socketID'] !=
                    m.socketClient.id,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => tapped(index, roomdataProvider),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),
                        child: Center(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              roomdataProvider.displayElements[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 100,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 40,
                                      color:
                                      roomdataProvider.displayElements[index] == 'O'
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
