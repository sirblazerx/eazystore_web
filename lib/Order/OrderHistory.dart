import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazystore/Models/User.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Order')
              .orderBy("Time",descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Text('null');

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot orders = snapshot.data.docs[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: (){
                        ConfirmOrderDialog(context, orders['Details'], orders['Price'].toString(), getTime(orders['Time'].toString())+" "+getDate(orders['Time'].toString()));
                      },
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(orders.id),
                              subtitle: Text("RM "+orders['Price'].toString()),
                              trailing: Column(
                                children: [
                                  Text(getTime(orders['Time'].toString())),
                                  Text(getDate(orders['Time'].toString()))
                                ],
                              ),
                            ),

                          ]
                      ),
                    )
                  );

                },
              );


          })
    );
  }

  static String getDate(String timestamp)
  {
    // Printing the result
    var d = int.parse(timestamp.substring(18,28)+"000");
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(d);
    String result = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
    return result;
  }

  static String getTime(String timestamp)
  {
    // Printing the result
    var d = int.parse(timestamp.substring(18,28)+"000");
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(d);

    return DateFormat.jm().format(date);
  }

  Future<void> ConfirmOrderDialog(BuildContext context, String details, String price, String time) async {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
                children: <Widget>[
                  Icon(Icons.note),
                  Text(" Order details"),
                ]
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Order Time:"),
                  Text(time+"\n", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
                  Text("Items"),
                  Text("- "+details.replaceAll("\\n", "\n- "), style: TextStyle(
                      fontWeight: FontWeight.bold)),
                  Text("\nTotal:"),
                  Text("RM "+ price, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back', style: TextStyle(color: Colors.blue))
              ),

            ],
          );
        });
  }

}



