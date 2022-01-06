import 'package:eazystore/Auth/authenticate.dart';
import 'package:eazystore/Home/home.dart';
import 'package:eazystore/Models/Store.dart';
import 'package:eazystore/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);
    final store = Provider.of<Store>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
    //will return Home or Authenticate based on user
  }
}
