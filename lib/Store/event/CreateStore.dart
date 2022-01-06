// ignore: file_names
// ignore: file_names
import 'dart:io';

import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Services/StoreService.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddStory extends StatefulWidget {
  @override
  _AddStoryState createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  CollectionReference story = FirebaseFirestore.instance.collection('storys');

  InAppWebViewController webView;

  final _fkey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String _curtitle;
  String _curdescri;
  String _name;
  String _curdate;
  String _curimg;
  String _fb;
  String _yt;
  String _acctype;
  String _userid;
  String _curcountry;
  String _url;

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
                    key: _fkey,
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        (_curimg != '')
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
                                val.isEmpty ? 'Enter Store Name' : null,
                            onChanged: (val) => setState(() => _curtitle = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Store Name",
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
                                val.isEmpty ? 'Enter Store Location' : null,
                            onChanged: (val) =>
                                setState(() => _curdescri = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Location",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user.uid)
                                .snapshots(),

                            // DatabaseService(uid: user.uid).userData,

                            builder: (context, snapshot) {
                              DocumentSnapshot userData = snapshot.data;

                              return RaisedButton.icon(
                                  onPressed: () async {
                                    var nsid = Uuid().v4();

                                    if (_fkey.currentState.validate()) {
                                      await StoreService(sid: nsid)
                                          .updateStoreData(
                                        StoreId: nsid,
                                        Uid: user.uid,
                                        StoreLocation: _curdescri,
                                        StoreName: _curtitle,
                                        Img: _curimg ?? '',
                                        Owner: userData['name'],
                                      );

                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.save_alt),
                                  label: Text('Save'));
                            })
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

  // Widget mediapicker() {
  //   if (_curimg != null) {
  //   } else if (_yt != null) {
  //     String vid;

  //     // Convert Video to ID
  //     vid = YoutubePlayer.convertUrlToId(_yt);

  //     var _controller = YoutubePlayerController(
  //       initialVideoId: (vid == null) ? vid = 'Null' : vid,
  //       flags: YoutubePlayerFlags(
  //         autoPlay: false,
  //         mute: false,
  //       ),
  //     );

  //     return YoutubePlayer(
  //       controller: _controller,
  //       showVideoProgressIndicator: true,
  //     );
  //   } else if (_fb != null) {

  //     var url = _fb;

  //     return Container(
  //       height: 290,
  //       child: InAppWebView(
  //         initialFile: url,
  //         initialOptions: InAppWebViewGroupOptions(
  //           crossPlatform: InAppWebViewOptions(
  //               preferredContentMode: UserPreferredContentMode.MOBILE),
  //         ),
  //         onWebViewCreated: (InAppWebViewController controller) {
  //           webView = controller;
  //         },
  //         onLoadStart: (InAppWebViewController controller, String url) {},
  //         onLoadStop: (InAppWebViewController controller, String url) async {},

  //       ),

  //     );
  //   } else {
  //     return Placeholder(
  //       fallbackHeight: 200.0,
  //       fallbackWidth: double.infinity,
  //     );
  //   }
  // }
}
