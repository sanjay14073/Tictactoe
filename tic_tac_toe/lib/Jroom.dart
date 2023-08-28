import 'package:flutter/material.dart';
import 'package:tic_tac_toe/socketmethods.dart';
class Jroom extends StatefulWidget {
  const Jroom({Key? key}) : super(key: key);

  @override
  State<Jroom> createState() => _JroomState();
}

class _JroomState extends State<Jroom> {
  TextEditingController t1=new TextEditingController();
  TextEditingController t2=new TextEditingController();
  Socketmethods m=Socketmethods();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m.joinRoomSuccess(context);
    m.errorOccurred(context);
    m.updatePlayersStateListener(context);
  }
  @override
  Widget build(BuildContext context) {
    final h=MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Join Room",style: TextStyle(fontSize:h/10,fontWeight: FontWeight.bold,),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(child: TextField(controller: t1,decoration: InputDecoration(hintText: "Enter Your User Name",icon: Icon(Icons.account_circle_rounded),border:InputBorder.none),),decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(5.0)),padding:EdgeInsets.all(5),),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(child: TextField(controller: t2,decoration: InputDecoration(hintText: "Enter the Room code",icon: Icon(Icons.code),border:InputBorder.none),),decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(5.0)),padding:EdgeInsets.all(5),),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(child: MaterialButton(onPressed: (){
              m.joinRoom(t1.text, t2.text);
            },child:Text("Join Room",style: TextStyle(fontSize: 20.0),),minWidth: double.infinity,elevation: 5.0,color: Colors.blue[600],),decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),height: 40.0,),
          ),
        ],
      ),
    ));
  }
}
