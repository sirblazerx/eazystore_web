import 'dart:io';

import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Services/Menu_Service.dart';
import 'package:eazystore/Services/StoreService.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eazystore/Services/Menu_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddMenu extends StatefulWidget {
  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  CollectionReference story = FirebaseFirestore.instance.collection('Menu');
  final _formKey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String _curname;
  String _menuid;
  String _desc;
  String _curimg;
  double _price;
  String _category;
  String _storeid;

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Store'),
            centerTitle: true,
            backgroundColor: Colors.pinkAccent,
          ),
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        (_curimg != null)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    constraints: BoxConstraints(maxHeight: 290),
                                    child: Image.network(_curimg)),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Placeholder(
                                  fallbackHeight: 200.0,
                                  fallbackWidth: double.infinity,
                                ),
                              ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(flex: 1),
                            Spacer(
                              flex: 1,
                            ),
                            RaisedButton.icon(
                                icon: Icon(Icons.person_add),
                                label: Text('Image'),
                                onPressed: () {
                                  uploadImage();
                                }),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        Text('Please fill in the credentials'),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            initialValue: null,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Menu Name' : null,
                            onChanged: (val) => setState(() => _curname = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Menu Name",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            initialValue: null,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Menu Description' : null,
                            onChanged: (val) => setState(() => _desc = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Menu Description",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            initialValue: null,
                            minLines: 3,
                            maxLines: 5,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Menu Price' : null,
                            onChanged: (val) =>
                                setState(() => _price = double.parse(val)),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Menu Price",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          child: DropdownButtonFormField(
                            value: _category,
                            items: [
                              DropdownMenuItem(
                                child: Text("Foods"),
                                value: "Foods",
                              ),
                              DropdownMenuItem(
                                child: Text("Drinks"),
                                value: "Drinks",
                              ),
                              DropdownMenuItem(
                                child: Text("Desserts"),
                                value: "Desserts",
                              )
                            ],
                            onChanged: (val) {
                              setState(() {
                                _category = val;
                              });
                            },
                            hint: Text("Select category"),
                            disabledHint:Text("Disabled"),
                            isExpanded: true,
                            style: TextStyle(fontFamily: 'Montserrat', color:Colors.black, fontSize: 18),
                            validator: (value) => value == null ? 'Select Category' : null,

                          ),
                          /*TextFormField(
                            initialValue: null,
                            minLines: 3,
                            maxLines: 5,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Menu Category' : null,
                            onChanged: (val) => setState(() => _category = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Menu Category",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),*/
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Colors.green[400],
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                // log(_currentprofilepic);

                                /*await MenuService(mid: user.uid)
                                    .updateMenuData(Name, MenuId, Price, Desc, Img, Category, StoreId)Data(
                                  _currentname ?? userData['name'],
                                  userData['acctype'],
                                  _currentcontact ?? userData['contact'],
                                  _currentprofilepic ??
                                      userData['profilepic'],
                                  user.uid,
                                );*/
                                //print(_category);
                                await MenuService(mid: user.uid).addMenu(_curname, _price, _desc, _curimg, _category, user.uid);

                                Navigator.pop(context);
                              }
                            }),
                        SizedBox(height: 20.0),

                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateGetter() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd ').format(now);
    return formattedDate;
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

        //   log(downloadUrl);

        // Setstate

        setState(() {
          _curimg = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Please enable permission for photos and try again');
    }
  }
}
