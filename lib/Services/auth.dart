import 'package:firebase_auth/firebase_auth.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/models/user.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a user object based on FirebaseUser
  Users? _userFromUser(User? user){
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromUser);
  }

  Future getUser() async {
    User? user = _auth.currentUser;
    return _userFromUser(user);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      return _userFromUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email + password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      global.uid = user!.uid;
      return _userFromUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerUserWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      global.uid = user!.uid;
      //create a new doc for the user with this uid
      await DatabaseService(uid: user.uid).updateUserData(email.split("@")[0], email);
      return _userFromUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}