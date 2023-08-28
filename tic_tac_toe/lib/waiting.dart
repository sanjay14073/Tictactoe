import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/Colors.dart';
import 'package:tic_tac_toe/roomdataprovider.dart';
import 'package:flutter/services.dart';
class Waiting extends StatefulWidget {
  const Waiting({Key? key}) : super(key: key);

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  TextEditingController t1=TextEditingController();
  @override
  Widget build(BuildContext context) {
    RoomdataProvider roomdataProvider=Provider.of<RoomdataProvider>(context);
    t1.text=roomdataProvider.roomData['_id'];
    return Scaffold(
      backgroundColor:bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hey,Share this Code for users"),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              readOnly: true,
              controller: t1,
              decoration: InputDecoration(
                icon: IconButton(
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: t1.text)).then((_) =>{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied Room ID Sucessfully",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,))
                    });
                  },
                  icon: Icon(Icons.copy),
                )
              ),
            ),
          ),
          SizedBox(height: 20,),

        ],
      ),
    );
  }
}