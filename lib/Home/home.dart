import 'dart:developer';
import 'dart:math';

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
import 'package:ticketview/ticketview.dart';


var cart = FlutterCart();
List<DocumentSnapshot> FoodList;
List<DocumentSnapshot> DrinksList;
List<DocumentSnapshot> DessertsList;

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
          title: Text('Eazystore User'),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Qr()));
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
                })),
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
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> items = snapshot.data.docs;
                      FoodList = items.where((i) => i["Category"] == "Foods").toList();
                      DrinksList = items.where((i) => i["Category"] == "Drinks").toList();
                      DessertsList = items.where((i) => i["Category"] == "Desserts").toList();
                    }
                    /*if (snapshot.data == null) {
                      return Loading();
                    }
                    else
                    {
                      List<DocumentSnapshot> items = snapshot.data.documents;
                      List FoodList = items.where((i) => i["stores"] == "Foods").toList();
                      List DrinksList = items.where((i) => i["stores"] == "Drinks").toList();
                      List DessertsList = items.where((i) => i["stores"] == "Desserts").toList();

                    }*/

                    return Expanded(
                      child : DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          appBar: new TabBar(
                            labelColor: Colors.black,
                            indicatorColor: Theme.of(context).primaryColor,
                            tabs: [
                              Tab(icon: Icon(Icons.local_dining)),
                              Tab(icon: Icon(Icons.emoji_food_beverage)),
                              Tab(icon: Icon(Icons.icecream)),
                            ],
                          ),
                          body: TabBarView(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: FoodList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot item = FoodList.elementAt(index);
                                  return MenuTile(item : item);
                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: DrinksList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot item = DrinksList.elementAt(index);
                                  return MenuTile(item : item);

                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: DessertsList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot item = DessertsList.elementAt(index);
                                  return MenuTile(item : item);

                                },
                              ),
                            ],
                          ),
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
                      ConfirmOrderDialog(context);
                      //_confirmCart(context);
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
//carts navigation
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

//display menu by list
class MenuTile extends StatelessWidget{

  MenuTile({Key key, this.item}) : super(key: key);
  final DocumentSnapshot item;

  @override
  Widget build(BuildContext context) {

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
                "RM " + item['Price'].toString(),
                description: item['Desc'],
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
                          item['Img']) ??
                          Icon(Icons.fastfood)),
                ),
                title: item['Name'],
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
                                productId: item.id,
                                unitPrice:
                                item['Price'],
                                productName:
                                item['Name']);

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
  }
}

//confirm order dialog
Future<void> ConfirmOrderDialog(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  String tableNumber;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
              children: <Widget>[
                Icon(Icons.payment),
                Text(" Confirm order"),
              ]
          ),
          content: TextField(
            onChanged: (val) {
                tableNumber = val;
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Please enter your table no."),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.green))
            ),
            TextButton(
              onPressed: () {
                Random random = new Random();
                if(tableNumber == null)
                  tableNumber = random.nextInt(20).toString();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Receipt(tableNumber: tableNumber,)));

              },
              child: const Text('Confirm', style: TextStyle(color: Colors.green))
            ),
          ],
        );
      });
}

class Receipt extends StatelessWidget{
  final String tableNumber;

  Receipt({Key key, this.tableNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    return Scaffold(
      appBar: AppBar(title: Text('Order Confirmation')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TicketView(
              backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              backgroundColor: Colors.grey,
              contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 15),
              drawArc: false,
              triangleAxis: Axis.vertical,
              borderRadius: 6,
              drawDivider: true,
              dividerColor: Colors.white,
              dividerStrokeWidth: 0,
              trianglePos: .5,
              drawShadow: true,
              drawBorder: true,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Order #'+random.nextInt(100000).toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Expanded(child: Container()),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: getCurrentDate(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Table No: '+ tableNumber.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),

                              ListView.builder(
                                  shrinkWrap: true, // <- added
                                  primary: false,
                                  itemExtent: 25,
                                  itemCount: cart.getCartItemCount(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      trailing: Text(cart.cartItem[index].quantity.toString() +
                                          " - RM " +
                                          (cart.cartItem[index].unitPrice *
                                              cart.cartItem[index].quantity)
                                              .toStringAsFixed(2)),
                                      title: Text(cart.cartItem[index].productName),
                                    );
                                    //return new Text(cart.cartItem[index].unitPrice.toString());
                                  }),
                              SizedBox(height: 35),
                            ],
                          ),
                        ),
                      ),


                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        SizedBox(height: 15),

                        Text("Thank you for your purchase, please show the receipt at counter to proceed with your payment.",
                          textAlign: TextAlign.center,),
                        SizedBox(height: 20),


                      ],
                    )
                    ,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

getCurrentDate() {
  var date = DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

  return formattedDate;
}