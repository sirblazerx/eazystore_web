import 'package:eazystore/profile/profileForm.dart';
import 'package:eazystore/profile/profile_list.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
            title: Text('Your Profile'),
            backgroundColor: Colors.pinkAccent,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileForm()),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile')),
            ]),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileList()


        ),
      ),
    );
  }
}
