import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final String? uid;

  FirebaseFirestoreService({this.uid});

  //reference for database
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //adding data to database
  Future addUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  //get data from database
  Future<String> getUserName() async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    return documentSnapshot['fullName'];
  }

  Future<String> getUserEmail() async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    return documentSnapshot['email'];
  }

  Future<String> getUserProfilePic() async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    return documentSnapshot['profilePic'];
  }
}
