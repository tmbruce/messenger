import 'package:flutter/cupertino.dart';

class ThreadScreen extends StatefulWidget{
  static String id = 'ThreadScreen';
  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen>{

  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Messages'),
            trailing: GestureDetector(onTap: (){
              //Create message
            },
            child: Icon(CupertinoIcons.create),
            ),
          ),
        ],
      ),
    );
  }
}