import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Home/home.dart';
import 'package:eazystore/Services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';

var cart = FlutterCart();
List<DocumentSnapshot> FoodList;
List<DocumentSnapshot> DrinksList;
List<DocumentSnapshot> DessertsList;

class MenuPage extends StatelessWidget {
  MenuPage(this.uid);

  final String uid;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    cart.deleteAllCart();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Menu Page'),
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
                      .where('StoreId', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> items = snapshot.data.docs;
                      FoodList =
                          items.where((i) => i["Category"] == "Foods").toList();
                      DrinksList = items
                          .where((i) => i["Category"] == "Drinks")
                          .toList();
                      DessertsList = items
                          .where((i) => i["Category"] == "Desserts")
                          .toList();
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
                      child: DefaultTabController(
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
                                  DocumentSnapshot item =
                                      FoodList.elementAt(index);
                                  return MenuTile(item: item);
                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: DrinksList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot item =
                                      DrinksList.elementAt(index);
                                  return MenuTile(item: item);
                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: DessertsList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot item =
                                      DessertsList.elementAt(index);
                                  return MenuTile(item: item);
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
}

void _goToCart(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
}
