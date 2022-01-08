import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Auth/authenticate.dart';
import 'package:eazystore/Home/home.dart';
import 'package:eazystore/Home/homeGuest.dart';
import 'package:eazystore/Models/Store.dart';
import 'package:eazystore/Models/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);
    final store = Provider.of<Store>(context);

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    if (user == null) {
      return Authenticate();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data.exists) {
          return HomePage();
        }
        return HomePageGuest();
      },
    );

    // DocumentSnapshot  meh = FirebaseFirestore.instance.collection('Users').doc(user.uid).get() as DocumentSnapshot<Object>;

    //  Widget _getStatus() {

    //     };

    //     if (user == null) {
    //       return Authenticate();
    //     } else {
    //       return _getStatus();
    //     }

    //     //will return Home or Authenticate based on user
    //   }
  }
}
