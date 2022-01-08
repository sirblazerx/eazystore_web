import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Store/event/EditStore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VStoryEdit extends StatefulWidget {
  final String storyid;

  const VStoryEdit({Key key, this.storyid}) : super(key: key);

  @override
  _VStoryEditState createState() => _VStoryEditState();
}

class _VStoryEditState extends State<VStoryEdit> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Story'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Store')
                .doc(widget.storyid)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              DocumentSnapshot _data = snapshot.data;

              Widget mediaGetter() {
                if (_data['Img'] != '') {
                  return Image.network(_data['Img']);
                } else {
                  return Container();
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return Scaffold(
                body: ListView(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          mediaGetter(),
                          ListTile(
                            title: Text(_data['StoreName']),
                            subtitle: Text(
                              _data['StoreLocation'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _data['Owner'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditStore(
                                        storyid: widget.storyid,
                                        img: _data['Img'])));
                              })
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
