import 'package:eazystore/Models/User.dart';
import 'package:eazystore/Services/UserDB.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //return user using custom models

  UserM _userModel(User user) {
    return user != null ? UserM(uid: user.uid) : null;
  }

  //auth change user stream

  Stream<UserM> get user {
    return _auth.userChanges().map(
        _userModel); // mapping user that get from stream to follow user model requirements
  }

  //sign in anonnymous

  Future signAnon() async {
    try {
      UserCredential anonresult = await _auth.signInAnonymously();
      User user = anonresult.user;
      return _userModel(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email n pass

  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userModel(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //reg with email n pass

  Future regEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // Create a new document for user with generated uid

      await DatabaseService(uid: user.uid)
          .updateUserData('New User', 'Client', '', null, user.uid);

      return _userModel(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
