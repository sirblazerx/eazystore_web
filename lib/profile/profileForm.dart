import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Custom/template.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Services/UserDB.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // profiles values

  String _currentname;
  String _currentcontact;
  String _currentprofilepic;
  String imgUrl;
  String _userid;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .snapshots(),

          // DatabaseService(uid: user.uid).userData,

          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot userData = snapshot.data;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: <Widget>[
                          SizedBox(height: 20.0),

                          Text(
                            'Update Your Profile',
                            style: TextStyle(fontSize: 30.0),
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          //  (userData.profilepic != null)  ? Image.network(userData.profilepic) : Placeholder(fallbackHeight:   200.0,fallbackWidth: double.infinity,),
                          (_currentprofilepic != null)
                              ? Image.network(_currentprofilepic)
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Placeholder(
                                    fallbackHeight: 200.0,
                                    fallbackWidth: double.infinity,
                                  ),
                                ),

                          SizedBox(
                            height: 20.0,
                          ),

                          RaisedButton(
                            child: Text('Upload Image'),
                            color: Colors.lightGreen,
                            onPressed: () {
                              uploadImage();
                              //  DatabaseService(uid: user.uid).updateProfilePic(_currentprofilepic);
                            },
                          ),

                          SizedBox(height: 10.0),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Name :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData['name'],
                                  decoration: textInputDecoration,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter Your  name' : null,
                                  onChanged: (val) =>
                                      setState(() => _currentname = val),
                                ),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Contact Number :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData['contact'],
                                  decoration: textInputDecoration,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter Contact Number'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentcontact = val),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 40.0),

                          RaisedButton(
                              color: Colors.green[400],
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  // log(_currentprofilepic);

                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                    _currentname ?? userData['name'],
                                    userData['acctype'],
                                    _currentcontact ?? userData['contact'],
                                    _currentprofilepic ??
                                        userData['profilepic'],
                                    user.uid,
                                  );

                                  Navigator.pop(context);
                                }
                              }),
                        ]),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }

  uploadImage() async {
    final _picker = ImagePicker();
    final _storage = FirebaseStorage.instance;

    PickedFile image;

    //Check Permission
    await Permission.photos.request();

    var permissionstatus = await Permission.photos.status;

    if (permissionstatus.isGranted) {
      //Select Image

      image = await _picker.getImage(source: ImageSource.gallery);

      var file = File(image.path);
      var name = basename(image.path);

      if (image != null) {
        //Upload to Firebase

        var snapshot = await _storage.ref().child(name).putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        //  log(downloadUrl);

        setState(() {
          _currentprofilepic = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Please enable permission for photos and try again');
    }
  }
}
