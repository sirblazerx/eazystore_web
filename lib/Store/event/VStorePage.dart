import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VStorePage extends StatefulWidget {
  final String projectid;

  VStorePage({Key key, @required this.projectid}) : super(key: key);

  @override
  _VStorePageState createState() => _VStorePageState();
}

class _VStorePageState extends State<VStorePage> {
  InAppWebViewController webView;

  CollectionReference projects =
      FirebaseFirestore.instance.collection('vprojects');

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Project Limit Reached '),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please withdraw or complete project before joining'),
                  Text('Thank you for your cooperation'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final user = Provider.of<UserM>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: projects.doc(widget.projectid).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }

              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              var meh = snapshot.data['dateproject'];

              var now = DateTime.fromMillisecondsSinceEpoch(meh.seconds * 1000);

              String date = DateFormat('dd/MM/yyyy').format(now);

              Widget mediaGetter() {
                if (snapshot.data['img'] != null) {
                  return Image.network(snapshot.data['img']);
                } else {
                  return Icon(Icons.person);
                }
              }

              return Scaffold(
                body: ListView(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          mediaGetter(),
                          ListTile(
                            title: Text(
                              snapshot.data['title'],
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              snapshot.data['descri'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              snapshot.data['locationname'],
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              date,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              snapshot.data['name'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
