import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Custom/customlist.dart';
import 'package:eazystore/Custom/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    // CollectionReference projects = FirebaseFirestore.instance.collection('vprojects');//.orderBy('datecreate',descending: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stores'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Store").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            return Card(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot projects = snapshot.data.documents[index];

                  Widget mediaGetter() {
                    if (projects['img'] != null) {
                      return Image.network(projects['img']);
                    } else {
                      return Image.asset('lib/Assets/logo.jpeg');
                    }
                  }

                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         VEvent(projectid: projects.id)));
                      },
                      child: CustomListTile(
                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => VDonation(donationid: donate.id)));
                        // },
                        user: projects['name'],
                        description: projects['descri'],
                        thumbnail: Container(
                          decoration: const BoxDecoration(color: Colors.blue),
                          child: Container(
                              constraints: BoxConstraints(
                                  minHeight: 100,
                                  minWidth: 100,
                                  maxWidth: 200,
                                  maxHeight: 160),
                              child: mediaGetter()),
                        ),
                        title: projects['title'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
