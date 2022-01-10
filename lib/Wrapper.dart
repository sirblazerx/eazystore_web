import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Auth/authenticate.dart';
import 'package:eazystore/Home/home.dart';
import 'package:eazystore/Home/homeGuest.dart';
import 'package:eazystore/Models/Store.dart';
import 'package:eazystore/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  bool exist = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);
    final store = Provider.of<Store>(context);

    Future<bool> checkExist() async {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get()
            .then((doc) {
          exist = doc.exists;
        });
        return exist;
      } catch (e) {
        // If any error
        return false;
      }
    }

    Widget getScreen() {
      if (exist == true) {
        print('User exist');
        return HomePage();
      } else {
        print("User Doesnt Exist");
        return HomePageGuest();
      }
    }

    if (user == null) {
      return Authenticate();
    } else {
      checkExist();
      return getScreen();
    }
  }
}
