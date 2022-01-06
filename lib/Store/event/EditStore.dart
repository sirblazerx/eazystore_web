import 'dart:io';
import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Models/Store.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Services/StoreService.dart';
import 'package:eazystore/Services/UserDB.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditStore extends StatefulWidget {
  final String storyid;
  final String img;

  const EditStore({Key key, this.storyid, this.img}) : super(key: key);

  @override
  _EditStoreState createState() => _EditStoreState(this.img);
}

class _EditStoreState extends State<EditStore> {
  _EditStoreState(String _tempimg) {
    this.meh = _tempimg;
  }

  final _fkey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  Stream _stream;
  String _curtitle;
  String _curdescri;
  String _name;
  String _curdate;
  String _curimg;
  String meh;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('Store')
        .doc(widget.storyid)
        .snapshots();

    super.initState();
  }

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
                              (meh != null)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          constraints:
                                              BoxConstraints(maxHeight: 290),
                                          child: Image.network(meh)),
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
                                      don['StoreName'] ?? Text('null'),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter title' : null,
                                  onChanged: (val) =>
                                      setState(() => _curtitle = val),
                                  style: style,
                                  decoration: InputDecoration(
                                      labelText: "Title",
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
                                  initialValue:
                                      don['StoreLocation'] ?? Text('null'),
                                  validator: (val) => val.isEmpty
                                      ? 'Enter Store Location'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _curdescri = val),
                                  style: style,
                                  decoration: InputDecoration(
                                      labelText: "Location",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StreamBuilder(
                                      stream: DatabaseService(uid: user.uid)
                                          .userData,
                                      builder: (context, snapshot) {
                                        UserData userData = snapshot.data;

                                        return RaisedButton.icon(
                                          onPressed: () async {
                                            if (_fkey.currentState.validate()) {
                                              await StoreService(
                                                      sid: widget.storyid)
                                                  .updateStoreData(
                                                      Owner: userData.name,
                                                      StoreLocation: _curdescri ??
                                                          don['StoreLocation'],
                                                      StoreName: _curtitle ??
                                                          don['StoreName'],
                                                      Uid: user.uid,
                                                      Img:
                                                          _curimg ?? don['Img'],
                                                      StoreId: widget.storyid);

                                              Navigator.pop(context);
                                            }
                                          },
                                          icon: Icon(Icons.save_alt),
                                          label: Text('Save'),
                                          color: Colors.lightGreenAccent,
                                        );
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        StoreService(sid: widget.storyid)
                                            .deleteStore();

                                        Navigator.pop(context);
                                      }),
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

  // DateGetter() {
  //   DateTime now = DateTime.now();
  //   String formattedDate = DateFormat('yyyy/MM/dd ').format(now);
  //   return formattedDate;
  // }

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
          meh = downloadUrl;
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
  //   if (widget.img != null) {
  //   } else if (widget.vid != null) {
  //     String vid;

  //     // Convert Video to ID
  //     vid = YoutubePlayer.convertUrlToId(widget.vid);

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
  //   } else if (widget.fb != null) {
  //     var url = widget.fb;

  //     return Container(
  //       height: 290,
  //       child: InAppWebView(
  //         initialUrl: url,
  //         initialOptions: InAppWebViewGroupOptions(
  //           crossPlatform: InAppWebViewOptions(
  //               debuggingEnabled: true,
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
