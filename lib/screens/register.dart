import 'package:flutter/cupertino.dart';

class RegisterScreen extends StatefulWidget{
  static String id = 'RegisterScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}