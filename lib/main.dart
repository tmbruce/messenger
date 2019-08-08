import 'package:flutter/cupertino.dart';
import 'screens/threadScreen.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() => runApp(Messenger());

class Messenger extends StatelessWidget{



  @override
  Widget build(BuildContext context){
    return CupertinoApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => LoginScreen(),
        ThreadScreen.id: (context) => ThreadScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
      },
    );
  }
}