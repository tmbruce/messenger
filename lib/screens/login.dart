import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../screens/threadScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../screens/register.dart';


class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _error;
  String _email;
  String _password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _auth = FirebaseAuth.instance;
  var busy = false;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.lightBlueAccent,
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                CupertinoIcons.info,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _error = null;
                });
              },
              child: Icon(
                CupertinoIcons.clear_circled,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ModalProgressHUD(
        inAsyncCall: busy,
        progressIndicator: CupertinoActivityIndicator(radius: 15),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              showAlert(),
              CupertinoTextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                placeholder: 'Email Address',
                onChanged: (value) {
                  _email = value;
                },
              ),
              CupertinoTextField(
                controller: passwordController,
                obscureText: true,
                placeholder: 'Password',
                onChanged: (value) {
                  _password = value;
                },
              ),
              CupertinoButton(
                child: Text('Sign in'),
                onPressed: () async {
                  setState(() {
                    busy = true;
                  });
                  try {
                    var user = await _auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    if (user != null) {
                      Navigator.pushReplacementNamed(context, ThreadScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      _error = e.message;
                      busy = false;
                      emailController.clear();
                      passwordController.clear();
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Not yet registered?'),
                  CupertinoButton(
                    child: Text('Register'),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
