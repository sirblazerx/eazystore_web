import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Models/Order.dart';

class OrderService {
  final String mid;

  OrderService({this.mid});

  //collection ref

  final CollectionReference order =
  FirebaseFirestore.instance.collection('Order');

// Update/Create Data to Collection

  // User Data

  Future updateOrderData({double Price, String Details,
    String Category, String StoreId}) async {
    return await order.doc(mid).set({
      'Price': Price,
      'Details': Details,
      'Category': Category,
      'StoreId': StoreId,
    });
  }

  Future addOrder(double Price, String Details,
      String StoreId) async {
    return await order.doc().set({
      'Price': Price,
      'Details': Details,
      'Time': DateTime.now(),
      'StoreId': StoreId,
    });
  }

  Future deleteOrder() async {
    return await order.doc(mid).delete();
  }


  // UserData from snapshot

  // UserData _profile(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   return UserData(
  //     uid: uid,
  //     acctype: snapshot.data()['acctype'],
  //     name: snapshot.data()['name'],
  //     contact: snapshot.data()['contact'],
  //     profilepic: snapshot.data()['profilepic'],
  //   );
  // }

  Order _profile(DocumentSnapshot snapshot) {
    return Order(
      Details: snapshot['Details'],
      Price: snapshot['Price'],
      Time: snapshot['Time'],
      StoreId: snapshot['StoreId'],

    );
  }

  //Stream

  // get user data stream
  Stream<Order> get userData {
    return order.doc(mid).snapshots().map(_profile);
  }
}