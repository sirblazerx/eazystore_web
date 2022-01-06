import 'package:eazystore/Auth/forgotpass.dart';
import 'package:eazystore/Custom/loading.dart';
import 'package:eazystore/Custom/template.dart';
import 'package:eazystore/Services/authservice.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  String error = '';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // text field state

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);

    return loading
        ? Loading()
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.white70,
                  // appBar: AppBar(
                  //   backgroundColor: Colors.pinkAccent[400],
                  //   elevation: 0.0,
                  //   title: Text('Sign In'),
                  //   centerTitle: true,
                  // ),
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50.0),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 20.0),
                                    Image.asset('lib/Assets/giflogo.gif'),
                                    SizedBox(height: 20.0),
                                    TextFormField(
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'Email'),
                                        validator: (val) => val.isEmpty
                                            ? 'Enter your email'
                                            : null,
                                        onChanged: (val) {
                                          setState(() => email = val);
                                        }),
                                    SizedBox(height: 20.0),
                                    TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'Password'),
                                      obscureText: true,
                                      validator: (val) => val.length < 6
                                          ? 'Enter a password 6 Characters or longer'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                    ),
                                    SizedBox(height: 20.0),

                                    //Anon Sign IN

                                    // ElevatedButton(
                                    //     style: ButtonStyle(
                                    //         backgroundColor:
                                    //             MaterialStateProperty.all<
                                    //                 Color>(Colors.red)),
                                    //     onPressed: () async {
                                    //       dynamic anresult =
                                    //           await _auth.signAnon();
                                    //       if (anresult == null) {
                                    //         print('Login Failures');
                                    //       } else {}
                                    //     },
                                    //     child: Text('Guest Sign In')),

                                    RaisedButton(
                                        color: Colors.amberAccent[400],
                                        child: Text(
                                          'Log In',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic result =
                                                await _auth.signInWithEmail(
                                                    email, password);

                                            if (result == null) {
                                              setState(() {
                                                error = 'Invalid Credentials';
                                                loading = false;
                                              });
                                            }
                                          }
                                        }),
                                    SizedBox(height: 10.0),
                                    Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14.0),
                                    ),
                                    SizedBox(height: 10.0),
                                    RichText(
                                      text: TextSpan(
                                          style: defaultStyle,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' Forgot Password ',
                                              style: linkStyle,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ForgotPassword()));
                                                },
                                            )
                                          ]),
                                    ),
                                    SizedBox(height: 20.0),
                                    RichText(
                                      text: TextSpan(
                                          style: defaultStyle,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    'Dont have an account ? '),
                                            TextSpan(
                                              text: ' Sign up now !',
                                              style: linkStyle,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.toggleView();
                                                },
                                            )
                                          ]),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                  )),
            ),
          );
  }
}
