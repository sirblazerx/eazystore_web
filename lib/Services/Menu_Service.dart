import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Models/Menu.dart';

class MenuService {
  final String mid;

  MenuService({this.mid});

  //collection ref

  final CollectionReference menu =
      FirebaseFirestore.instance.collection('Menu');

// Update/Create Data to Collection

  // User Data

  Future updateMenuData({String Name, double Price, String Desc,
      String Img, String Category, String StoreId}) async {
    return await menu.doc(mid).set({
      'Name': Name,
      'Price': Price,
      'Desc': Desc,
      'Img': Img,
      'Category': Category,
      'StoreId': StoreId,
    });
  }

  Future addMenu(String Name, double Price, String Desc,
      String Img, String Category, String StoreId) async {
    return await menu.doc().set({
      'Name': Name,
      'Price': Price,
      'Desc': Desc,
      'Img': Img,
      'Category': Category,
      'StoreId': StoreId,
    });
  }

  Future deleteMenu() async {
    return await menu.doc(mid).delete();
  }

  Future updateProfilePic(String profilepic) async {
    return await menu.doc(mid).update({
      'profilepic': profilepic,
    });
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

  Menu _profile(DocumentSnapshot snapshot) {
    return Menu(
      MenuId: snapshot['MenuId'],
      Name: snapshot['Name'],
      Price: snapshot['Price'],
      Desc: snapshot['Desc'],
      Img: snapshot['Img'],
      Category: snapshot['Category'],
      StoreId: snapshot['StoreId'],
    );
  }

  //Stream

  // get user data stream
  Stream<Menu> get userData {
    return menu.doc(mid).snapshots().map(_profile);
  }
}
