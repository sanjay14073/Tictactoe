import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/roomdataprovider.dart';
import 'package:tic_tac_toe/waiting.dart';
import 'package:tic_tac_toe/socketmethods.dart';
import 'board.dart';
class Play extends StatefulWidget {
  const Play({Key? key}) : super(key: key);

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  Socketmethods m=Socketmethods();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m.updateRoomListener(context);
    m.updatePlayersStateListener(context);
    m.pointIncreaseListener(context);
    m.endGameListener(context);
  }
  @override
  Widget build(BuildContext context) {
    RoomdataProvider roomdataProvider=Provider.of<RoomdataProvider>(context);
    return roomdataProvider.roomData['isJoin']?Waiting():Board();
  }
}
