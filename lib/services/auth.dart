import 'package:firebase_auth/firebase_auth.dart';
import 'package:text_me/model/user.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Condition ? True : False
  UserClass _userFromFirebaseUser(User user){
    return user != null ? UserClass(userId: user.uid):null;
  }
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result2 = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result2.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }
  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}