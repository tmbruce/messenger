import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ThreadScreen extends StatefulWidget{
  static String id = 'ThreadScreen';
  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen>{

  var user = [];
  void getUsers() async {
    var userLoc = await Firestore.instance.collection('user').getDocuments();
    for(var us in userLoc.documents){
      var userID = us.documentID;
      user.add(userID);
    }
    user.sort();
    String threadID = '';
    for(var i = 0; i< user.length; i++){
      threadID = threadID+user[i];
    }
    print(threadID);
  }
  void getMessages() async {
    var threadID = await Firestore.instance.collection('messages').where('users', arrayContains: 'travis@pyrolabs.io')
        .where('delivered', isEqualTo: false).getDocuments();
    for(var thd in threadID.documents){
      print(thd.data);
    }
  }
  
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Messages'),
            trailing: GestureDetector(onTap: (){
              getUsers();
            },
            child: Icon(CupertinoIcons.create),
            ),
          ),
        ],
      ),
    );
  }
}