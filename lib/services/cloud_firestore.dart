import 'package:bowie/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  static final FirebaseApp _app = FirebaseApp.instance;
  static final Firestore _firestore = Firestore(app: _app);
  static final AuthService _auth = AuthService();

  Future<bool> hasCof() async {
    final DocumentReference _userDocRef = await documentRef();
    final _userDoc = await _userDocRef.get();
    final _userDocData = _userDoc.data;

    if (_userDocData == null) {
      return false;
    }

    return _userDocData["has_cof"] ?? false;
  }

  Future<DocumentReference> documentRef() async {
    final _user = await _auth.getUser();
    final _userId = _user.uid;
    final _userDocRef = _firestore.collection("users").document(_userId);
    return _userDocRef;
  }

  Future<void> saveSettings(Map value, String field) async {
    final DocumentReference _userDocRef = await documentRef();
    return await _userDocRef.setData({"settings.$field": value}, merge: true);
  }

  Future<Map> getSettings(String field) async {
    final DocumentReference _userDocRef = await documentRef();
    final DocumentSnapshot _userDoc = await _userDocRef.get();
    if (_userDoc.data == null) {
      return Map();
    }
    final _userDocSettings = _userDoc.data["settings.$field"];
    return _userDocSettings ?? Map();
  }

  Stream<Map> getSettingsStream(String field) async* {
    final DocumentReference _userDocRef = await documentRef();
    yield* _userDocRef.snapshots().map<Map>((DocumentSnapshot data) {
      if (data.data == null) {
        return Map();
      }
      final _userDocSettings = data.data["settings.$field"];
      return _userDocSettings ?? Map();
    });
  }

  Future<List> getCards() async {
    final DocumentReference _userDocRef = await documentRef();
    final _userDoc = await _userDocRef.get();
    print(_userDoc.data);
    if (_userDoc.data == null) {
      return List();
    }
    final _userDocCards = _userDoc.data["cards"];
    return _userDocCards ?? List();
  }

  Future<List> getHistory() async {
    final DocumentReference _userDocRef = await documentRef();
    final _userDoc = await _userDocRef.get();
    print(_userDoc.data);
    if (_userDoc.data == null) {
      return List();
    }
    final _userDocCards = _userDoc.data["history"];
    return _userDocCards ?? List();
  }
}
