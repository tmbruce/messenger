import 'package:flutter/cupertino.dart';
import 'screens/threadScreen.dart';

void main() => runApp(Messenger());

class Messenger extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return CupertinoApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ThreadScreen(),
      },
    );
  }
}