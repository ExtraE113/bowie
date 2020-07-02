import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future<FirebaseUser> getUser() async{
    return await _auth.currentUser();
  }

  Future<String> getIdToken() async {
    final user = await getUser();
    final token = (await user.getIdToken()).token;
    return token;
  }


  // sign in with email and passwd
  Future registerWithEmailAndPassword(String email, String password) async {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future signInAnnon() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    return user;
  }


  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}