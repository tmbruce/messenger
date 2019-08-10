import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; //COLORS
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import '../datasource/cloud_db.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../screens/login.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var img;
  var user;
  String _error;
  File image;
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  CupertinoSuggestionsBoxController _suggestionsBoxController =
      CupertinoSuggestionsBoxController();
  TextEditingController _typeAheadController = TextEditingController();

  var busy = false;
  var locations = [];
  var result = [];

  void getLocations() async {
    var locationsList =
        await Firestore.instance.collection('location').getDocuments();
    for (var _ in locationsList.documents) {
      for (var __ in _.data['location']) {
        locations.add(__);
      }
    }
    locations.sort();
  }

  void searchLocations(String searchText) {
    result.clear();
    for (var _ in locations) {
      if (_.toString().toLowerCase().contains(searchText.toLowerCase())) {
        print(searchController.text);
        result.add(_);
      }
    }
    print(result);
  }

  FutureOr<List<dynamic>> searchLoc(String searchText) {
    result.clear();
    for (var _ in locations) {
      if (_.toString().toLowerCase().contains((searchText.toLowerCase()))) {
        result.add((_));
      }
    }
    return result;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    jobTitleController.dispose();
    searchController.dispose();
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getLocations();
    super.initState();
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
      navigationBar: CupertinoNavigationBar(
        middle: Text('Messenger'),
      ),
      child: ModalProgressHUD(
        inAsyncCall: busy,
        progressIndicator: CupertinoActivityIndicator(
          radius: 15,
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              showAlert(),
              (image == null)
                  ? GestureDetector(
                      onTap: () async {
                        final file = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxHeight: 500,
                            maxWidth: 500);
                        setState(() {
                          image = file;
                        });
                      },
                      child: Icon(CupertinoIcons.profile_circled,
                          size: 80.0, color: (Colors.grey)),
                    )
                  : GestureDetector(
                      onTap: () async {
                        final file = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxHeight: 500,
                            maxWidth: 500);
                        setState(() {
                          image = file;
                        });
                      },
                      child: ClipOval(
                        child: Image.file(
                          image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.profile_circled,
                      color: (Colors.black), size: 30.0),
                  Flexible(
                    child: CupertinoTextField(
                      controller: nameController,
                      placeholder: 'Name',
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.mail, color: (Colors.black), size: 30.0),
                  Flexible(
                    child: CupertinoTextField(
                      controller: emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.padlock,
                      color: (Colors.black), size: 30.0),
                  Flexible(
                    child: CupertinoTextField(
                      controller: passController,
                      placeholder: 'Password',
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.info, color: (Colors.black), size: 30.0),
                  Flexible(
                    child: CupertinoTextField(
                      controller: jobTitleController,
                      placeholder: 'Job Title',
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.location,
                      color: (Colors.black), size: 30.0),
                  Flexible(
                    child: CupertinoTypeAheadField(
                      getImmediateSuggestions: false,
                      suggestionsBoxController: _suggestionsBoxController,
                      textFieldConfiguration: CupertinoTextFieldConfiguration(
                        placeholder: 'Location',
                        maxLines: null,
                        controller: _typeAheadController,
                      ),
                      suggestionsCallback: (pattern) {
                        return searchLoc(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        _typeAheadController.text = suggestion;
                      },
                    ),
                  ),
                ],
              ),
              CupertinoButton(
                child: Text('Submit'),
                onPressed: () async {
                  setState(() {
                    busy = true;
                  });
// TODO rewrite this crappy login method.
                  if(nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passController.text.isEmpty ||
                  jobTitleController.text.isEmpty ||
                  _typeAheadController.text.isEmpty) {
                    setState(() {
                      _error = 'Please complete all fields.';
                      busy = false;
                    });
                  }

                  else {
                    try {
                      if(image != null){
                      img =
                      await CloudDB.sendPicture(image, emailController.text);
                        }
                      user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text);
                    } catch (e) {
                      setState(() {
                        _error = e.message;
                        busy = false;
                        emailController.clear();
                        passController.clear();
                      });
                    } finally {
                      if (_error == null) {
                        Firestore.instance.collection('user').add({
                          'email': emailController.text,
                          'imageURL': img,
                          'location': _typeAheadController.text,
                          'status': null,
                          'userName': nameController.text
                        });
                      }
                    }

                    if (user != null) {
                      setState(() {
                        nameController.clear();
                        emailController.clear();
                        passController.clear();
                        jobTitleController.clear();
                        _typeAheadController.clear();
                        busy = false;
                      });
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
