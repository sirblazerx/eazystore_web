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

class EditMenu extends StatefulWidget {
  final String menuid;
  final String img;

  const EditMenu({Key key, this.menuid, this.img}) : super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState(this.img);
}

class _EditMenuState extends State<EditMenu> {
  _EditMenuState(String _tempimg) {
    this.img = _tempimg;
  }

  final _fkey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String _curname;
  String _desc;
  double _price;
  String _category;
  String img;
  String _curimg;
  Stream _stream;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('Menu')
        .doc(widget.menuid)
        .snapshots();

    super.initState();
  }

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _curimg = img;
    final user = Provider.of<UserM>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit  Store'),
            centerTitle: true,
            backgroundColor: Colors.pinkAccent,
          ),
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              children: [
                Form(
                    key: _fkey,
                    child: StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Loading();
                          }

                          //  Store don = snapshot.data;

                          DocumentSnapshot don = snapshot.data;

                          return Column(
                            children: [
                              SizedBox(height: 20.0),
                              (img != null)
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    constraints:
                                    BoxConstraints(maxHeight: 290),
                                    child: Image.network(img)),
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
                                  RaisedButton.icon(
                                      icon: Icon(Icons.person_add),
                                      label: Text('Image'),
                                      onPressed: () {
                                        print('Bfore upload ' +
                                            _curimg.toString());

                                        uploadImage();

                                        print('After upload ' +
                                            _curimg.toString());
                                      }),
                                ],
                              ),
                              Text('Please fill in the credentials'),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: TextFormField(
                                  initialValue:
                                    don['Name'] ?? Text('null'),
                                  validator: (val) =>
                                  val.isEmpty ? 'Enter Menu Name' : null,
                                  onChanged: (val) =>
                                      setState(() => _curname = val),
                                  style: style,
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: TextFormField(
                                  initialValue: don['Desc'] ?? Text('null'),
                                  minLines: 3,
                                  maxLines: 3,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter Desc'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _desc = val),
                                  style: style,
                                  decoration: InputDecoration(
                                      labelText: "Desc",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: TextFormField(
                                  initialValue: don['Price'].toString() ?? Text('null'),
                                  validator: (val) => val.isEmpty
                                      ? 'Enter Price'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _price = double.parse(val)),
                                  style: style,
                                  decoration: InputDecoration(
                                      labelText: "Price",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                child: DropdownButtonFormField(
                                  value: don['Category'],
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
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RaisedButton.icon(
                                  onPressed: () async {
                                  if (_fkey.currentState.validate()) {
                                    await MenuService(
                                        mid: widget.menuid)
                                        .updateMenuData(
                                          Name: _curname ?? don['Name'],
                                          Price: _price ?? don['Price'],
                                          Desc: _desc ?? don['Desc'],
                                          Img: _curimg ?? don['Img'],
                                          Category: _category ?? don['Category'],
                                          StoreId: user.uid);
                                    Navigator.pop(context);
                                  }
                                  },
                                  icon: Icon(Icons.save_alt),
                                  label: Text('Save'),
                                  color: Colors.lightGreenAccent,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }))
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

        print(downloadUrl);

        // Setstate

        setState(() {
          img = downloadUrl;
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
