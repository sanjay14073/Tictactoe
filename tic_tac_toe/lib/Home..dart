import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(child: MaterialButton(onPressed: (){Navigator.pushNamed(context, '/create');},child: Text("Create Room",style: TextStyle(fontSize: 20.0)),minWidth:double.infinity,elevation: 5.0,color: Colors.blue[600],),decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),height: 40.0,),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(child: MaterialButton(onPressed: (){Navigator.pushNamed(context, '/join');},child:Text("Join Room",style: TextStyle(fontSize: 20.0),),minWidth: double.infinity,elevation: 5.0,color: Colors.blue[600],),decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),height: 40.0,),
            ),
          ],
        ),
      ),
    );
  }
}
