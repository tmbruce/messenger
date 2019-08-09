import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; //COLORS
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File image;
  TextEditingController nameController = TextEditingController();
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

  void imageFromGallery() async {
    final file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      //image = file;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
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
                      placeholder: 'Email',
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.info, color: (Colors.black), size: 30.0),
                  Flexible(
                    child: CupertinoTextField(
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
            ],
          ),
        ),
      ),
    );
  }
}
