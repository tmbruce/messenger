import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudDB {

  static Future<String> sendPicture(data, email) async {
    var fileName = data.hashCode.toString() + email.hashCode.toString();
    try {

      final StorageReference storageReference =
      FirebaseStorage().ref().child('ProfileImages/' + fileName);
      StorageUploadTask uploadTask = storageReference.putFile(data);
      await uploadTask.onComplete;
    }
    catch (e){
      // TODO Error Handling method
    }
    return fileName;
  }

  static Future <void> registerNewUser(String userName, String email, String password,
      String jobTitle, String location, String image) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Firestore.instance.collection('user').add({
        'email' : email,
        'imageURL' : image,
        'location' : location,
        'status' : null,
        'userName' : userName
      });
    }
    catch (e){
      // TODO Error handling method
    }
  }


}
