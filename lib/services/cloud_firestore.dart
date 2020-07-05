import 'package:bowie/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  static final FirebaseApp _app = FirebaseApp.instance;
  final Firestore _firestore = Firestore(app: _app);
  final AuthService _auth = AuthService();


  Future<bool> hasCof() async {
    final _user = await _auth.getUser();
    final _userId = _user.uid;
    final _userDoc =
        await _firestore.collection("users").document(_userId).get();
    final _userDocData = _userDoc.data;

    if (_userDocData == null) {
      return false;
    }

    return _userDocData["has_cof"];
  }
}
