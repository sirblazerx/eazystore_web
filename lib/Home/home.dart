import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Auth/sign_in.dart';
import 'package:eazystore/Custom/customlist.dart';
import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Models/Store.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/QR%20Scanner/Qr.dart';
import 'package:eazystore/Services/StoreService.dart';
import 'package:eazystore/Services/UserDB.dart';
import 'package:eazystore/Services/authservice.dart';
import 'package:eazystore/Store/event/StorePageList.dart';
import 'package:eazystore/Store/event/manageStore.dart';
import 'package:eazystore/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cart/flutter_cart.dart';

var cart = FlutterCart();

class HomePage extends StatelessWidget {
  @override
  final AuthService _auth = AuthService();

  String _meh;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);
    final store = Provider.of<Store>(context);

    cart.deleteAllCart();

    // FirebaseFirestore.instance
    //     .collection('Store')
    //     .where('Uid', isEqualTo: user.uid)
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     _meh = doc['StoreId'];
    //   });
    // });

    // print(store.StoreId);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Eazystore'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                _goToCart(context);
              },
            )
          ],
        ),
        drawer: Drawer(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DocumentSnapshot _data = snapshot.data;

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        // decoration: BoxDecoration(color: Colors.white),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('Hello , ' + _data['name'])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Manage Store'),
                          leading: Icon(Icons.store),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ManageStore()));
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('QR'),
                          leading: Icon(Icons.store),
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => Qr()));
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Profile'),
                          leading: Icon(Icons.store),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile()));
                          },
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Logout'),
                        leading: Icon(Icons.logout, color: Colors.red),
                        onTap: () async {
                          await _auth.signOut();
                        },
                      ),
                      Divider(),
                    ],
                  );
                }
                return Loading();
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Our Menus',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ),
              Divider(),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Menu')
                      .where('StoreId', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Loading();
                    }

                    return Expanded(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.vertical,
                          //physics: NeverScrollableScrollPhysics(),
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
                                                  Icon(Icons.fastfood)),
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
                                                    "Add",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  onPressed: () {
                                                    cart.addToCart(
                                                        productId: stores.id,
                                                        unitPrice:
                                                            stores['Price'],
                                                        productName:
                                                            stores['Name']);

                                                    // print(cart
                                                    //     .getCartItemCount());
                                                    //MenuService(mid: stores.id).deleteMenu();
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
          ),
        ),
      ),
    );
  }

  void _goToCart(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
  }
}

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true, // <- added
                primary: false,
                itemCount: cart.getCartItemCount(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.fastfood, size: 30),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: new IconButton(
                            icon: new Icon(Icons.remove),
                            onPressed: () {
                              cart.decrementItemFromCart(index);
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: new IconButton(
                            icon: new Icon(Icons.add),
                            onPressed: () {
                              cart.incrementItemToCart(index);
                              setState(() {});
                            },
                          ),
                        ),
                        VerticalDivider(),
                        Icon(Icons.delete),
                      ],
                    ),
                    title: Text(cart.cartItem[index].productName),
                    subtitle: Text(cart.cartItem[index].quantity.toString() +
                        " - RM " +
                        (cart.cartItem[index].unitPrice *
                                cart.cartItem[index].quantity)
                            .toStringAsFixed(2)),
                  );
                  //return new Text(cart.cartItem[index].unitPrice.toString());
                }),
          ),
          Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Total :",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text("RM " + cart.getTotalAmount().toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent[700])),
                    onPressed: () {
                      _confirmCart(context);
                    },
                    icon: Icon(Icons.payment),
                    label: Text('Confirm Order')),
                Container(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void _confirmCart(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartC()));
}

class CartC extends StatefulWidget {
  @override
  _CartCState createState() => _CartCState();
}

class _CartCState extends State<CartC> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirmed Order')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true, // <- added
                primary: false,
                itemCount: cart.getCartItemCount(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.fastfood, size: 30),
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // Container(
                    //     //   margin: EdgeInsets.only(right: 10),
                    //     //   child: new IconButton(
                    //     //     icon: new Icon(Icons.remove),
                    //     //     onPressed: () {
                    //     //       cart.decrementItemFromCart(index);
                    //     //       setState(() {});
                    //     //     },
                    //     //   ),
                    //     // ),
                    //     // Container(
                    //     //   margin: EdgeInsets.only(right: 10),
                    //     //   child: new IconButton(
                    //     //     icon: new Icon(Icons.add),
                    //     //     onPressed: () {
                    //     //       cart.incrementItemToCart(index);
                    //     //       setState(() {});
                    //     //     },
                    //     //   ),
                    //     // ),
                    //     VerticalDivider(),
                    //     Icon(Icons.delete),
                    //   ],
                    // ),
                    title: Text(cart.cartItem[index].productName),
                    subtitle: Text(cart.cartItem[index].quantity.toString() +
                        " - RM " +
                        (cart.cartItem[index].unitPrice *
                                cart.cartItem[index].quantity)
                            .toStringAsFixed(2)),
                  );
                  //return new Text(cart.cartItem[index].unitPrice.toString());
                }),
          ),
          Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Total :",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text("RM " + cart.getTotalAmount().toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                // ElevatedButton.icon(
                //     style: ButtonStyle(
                //         backgroundColor:
                //             MaterialStateProperty.all(Colors.greenAccent)),
                //     onPressed: () {},
                //     icon: Icon(Icons.payment),
                //     label: Text('Confirm Order')),
                Text('Thanks For Your Purchase !'),
                Container(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
