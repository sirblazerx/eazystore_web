import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Models/Menu.dart';
import 'package:eazystore/Models/Store.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

// Get Menu Data
  Stream<List<Menu>> getMenu() {
    return _db.collection('Menu').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Menu.fromJson(doc.data())).toList());
  }

// Upsert , Create if doesnt exist, update if exist

  var options = SetOptions(merge: true);

  Future<void> setMenu(Menu menu) {
    return _db.collection('Menu').doc(menu.MenuId).set(menu.toMap(), options);
  }

// Delete Data

  Future<void> removeMenu(String MenuId) {
    return _db.collection('Menu').doc(MenuId).delete();
  }

// Get Store Data
  Stream<List<Store>> getStore() {
    return _db.collection('Menu').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());
  }

// Upsert , Create if doesnt exist, update if exist

  Future<void> setStore(Store store) {
    return _db
        .collection('Store')
        .doc(store.StoreId)
        .set(store.toMap(), options);
  }

// Delete Data

  Future<void> removeStore(String StoreID) {
    return _db.collection('Store').doc(StoreID).delete();
  }
}
