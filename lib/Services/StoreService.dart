// ignore: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Models/Store.dart';

class StoreService {
  final String sid;

  //collection ref

  final CollectionReference story =
      FirebaseFirestore.instance.collection('Store');

  StoreService({this.sid});

// Update/Create Data to Collection

  // Store Update/Create Data

  Future updateStoreData(
      {String StoreName,
      String Img,
      String StoreLocation,
      String Uid,
      String StoreId,
      String Owner}) async {
    return await story.doc(sid).set({
      'StoreName': StoreName,
      'Img': Img,
      'StoreLocation': StoreLocation,
      'Uid': Uid,
      'StoreId': StoreId,
      'Owner': Owner,
    });
  }

  // Deleted Store from Firestore based on store id

  Future deleteStore() async {
    return await story.doc(sid).delete();
  }

  // Store data  from snapshot being mappep

  Store _store(DocumentSnapshot snapshot) {
    return Store(
      StoreId: sid,
      Uid: snapshot['Uid'],
      StoreLocation: snapshot['StoreLocation'],
      Img: snapshot['Img'],
      StoreName: snapshot['StoreName'],
      Owner: snapshot['Owner'],
    );
  }

  //Stream

  // get Store data stream and Mapped to Store Model

  Stream<Store> get storeData {
    return story.doc(sid).snapshots().map(_store);
  }
}
