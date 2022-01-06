import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Models/User.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection ref

  final CollectionReference user =
      FirebaseFirestore.instance.collection('Users');

// Update/Create Data to Collection

  // User Data

  Future updateUserData(String name, String acctype, String contact,
      String profilepic, String userid) async {
    return await user.doc(uid).set({
      'name': name,
      'acctype': acctype,
      'contact': contact,
      'profilepic': profilepic,
      'userid': userid,
    });
  }

  Future updateProfilePic(String profilepic) async {
    return await user.doc(uid).update({
      'profilepic': profilepic,
    });
  }

  // UserData from snapshot

  // UserData _profile(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   return UserData(
  //     uid: uid,
  //     acctype: snapshot.data()['acctype'],
  //     name: snapshot.data()['name'],
  //     contact: snapshot.data()['contact'],
  //     profilepic: snapshot.data()['profilepic'],
  //   );
  // }

  UserData _profile(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      acctype: snapshot['acctype'],
      name: snapshot['name'],
      contact: snapshot['contact'],
      profilepic: snapshot['profilepic'],
    );
  }

  //Stream

  // get user data stream
  Stream<UserData> get userData {
    return user.doc(uid).snapshots().map(_profile);
  }
}
