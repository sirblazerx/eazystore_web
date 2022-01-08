import 'package:eazystore/Home/home.dart';
import 'package:eazystore/Models/Store.dart';
import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Services/authservice.dart';
import 'package:eazystore/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Eazystore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<Store>.value(
      initialData: null,
      child: StreamProvider<UserM>.value(
        value: AuthService().user,
        child: GetMaterialApp(
          home: SafeArea(
            child:

                //HomePage()
                // Wrapper will be used once CRUD and other function is done
                Wrapper(),
          ),
        ),
      ),
    );
  }
}
