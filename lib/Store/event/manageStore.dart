import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Custom/customlist.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Store/event/EditStore.dart';
import 'package:eazystore/Store/event/VStoryEdit.dart';
import 'package:eazystore/Store/event/CreateStore.dart';
import 'package:eazystore/Services/Menu_Service.dart';
import 'package:eazystore/Menu/createMenu.dart';
import 'package:eazystore/Menu/EditMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:eazystore/Custom/loading.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ManageStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Stores Screen'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
      ),
      body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Store")
                    .where('Uid', isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return Text('null');

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemExtent: 106.0,
                    itemCount: snapshot?.data?.docs?.length ?? 0,
                    itemBuilder: (context, index) {
                      DocumentSnapshot _data = snapshot.data.docs[index];

                      // Declaration of FB,YT vids

                      Widget mediaGetter() {
                        if (_data['Img'] != '') {
                          return Image.network(_data['Img']);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Placeholder(),
                          );
                        }
                      }
                      // Get Video URL

                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VStoryEdit(
                                    storyid: _data.id,
                                  ),
                                ));
                          },
                          child: CustomListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditStore(
                                      storyid: snapshot.data.docs[index])));
                            },
                            user: _data['Owner'],
                            description: _data['StoreLocation'],
                            thumbnail: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              child: mediaGetter(),
                            ),
                            title: _data['StoreName'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    child: Text("Menu List",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))),
              ]),
              Divider(),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Menu')
                      .where("StoreId", isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Loading();
                    } else {}

                    return Expanded(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            DocumentSnapshot stores = snapshot.data.docs[index];

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: InkWell(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         VDonation(donationid: donate.id)));
                                  },
                                  child: Column(
                                    children: [
                                      CustomListTile(
                                        onTap: () {
                                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => VDonation(donationid: donate.id)));
                                        },
                                        user:
                                            "RM " + stores['Price'].toString(),
                                        description: stores['Desc'],
                                        thumbnail: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent),
                                          child: Container(
                                              constraints: BoxConstraints(
                                                  minHeight: 100,
                                                  minWidth: 100,
                                                  maxWidth: 150,
                                                  maxHeight: 160),
                                              child: Image.network(
                                                      stores['Img']) ??
                                                  (Icons.fastfood)),
                                        ),
                                        title: stores['Name'],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, bottom: 8),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Divider(),
                                                RaisedButton(
                                                  child: Text(
                                                    "Delete",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  onPressed: () {
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return new AlertDialog(
                                                        title: Text('Delete menu?'),
                                                        content: Text('This action cannot be undone. Please think carefully.'),
                                                        actions: [
                                                          FlatButton(
                                                            textColor: Colors.red,
                                                            onPressed: () {Navigator.pop(context);},
                                                            child: Text('CANCEL'),
                                                          ),
                                                          FlatButton(
                                                            textColor: Colors.red,
                                                            onPressed: () {
                                                              MenuService(mid: stores.id)
                                                                  .deleteMenu();
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text('ACCEPT'),
                                                          ),
                                                        ],
                                                      );
                                                    });

                                                    // Do something
                                                  },
                                                  color: Colors.red,
                                                  textColor: Colors.white,
                                                  padding: EdgeInsets.all(1.0),
                                                  splashColor: Colors.grey,
                                                ),
                                                VerticalDivider(),
                                                RaisedButton(
                                                  child: Text(
                                                    "Edit",
                                                    style:
                                                    TextStyle(fontSize: 14),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => EditMenu(
                                                            menuid: stores.id,
                                                            img: stores['Img'],)));
                                                    // Do something
                                                  },
                                                  color: Colors.blue,
                                                  textColor: Colors.white,
                                                  padding: EdgeInsets.all(1.0),
                                                  splashColor: Colors.grey,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            ],
          )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: isDialOpen,
        backgroundColor: Colors.redAccent,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        spacing: 15,
        spaceBetweenChildren: 15,
        closeManually: true,
        children: [
          SpeedDialChild(
              child: Icon(Icons.local_dining),
              label: 'Add Menu',
              onTap: (){
                isDialOpen.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMenu()),
                );
              }
          ),
          SpeedDialChild(
              child: Icon(Icons.store),
              label: 'Add Store',
              onTap: (){
                isDialOpen.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStore()),
                );

              }
          ),

        ],
      ),/*FloatingActionButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMenu()),
          );
        },
        child: Icon(Icons.add),
      ),*/
    );
  }
}
