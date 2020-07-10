import 'dart:async';
import 'dart:convert';

import 'package:bowie/services/auth.dart';
import 'package:http/http.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class SquareService {
  final Completer _completer = new Completer<bool>();
  final _auth = AuthService();

  //<editor-fold desc="save">
  // start the process of saving.
  // Returns a Future<bool> that resolves to
  // true if the card was saved,
  // resolves to false if it was canceled,
  // or resolves to an error if something went wrong.
  // todo does this have unexpected behavior if a method that returns a future is called again before the first future resolves?
  Future<bool> save() {
    InAppPayments.setSquareApplicationId("sandbox-sq0idb-u0xVRfqSvIDBU-2qw__JEQ");
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _saveOnCardNonceRequestSuccess,
      onCardEntryCancel: _saveOnCardEntryCancel,
    );
    return _completer.future;
  }

  void _saveOnCardNonceRequestSuccess(CardDetails result) async {
    //todo wrap all this with a less specific error message (with code ideally)
    var token;
    try {
      token = await _auth.getIdToken();
    } on NoSuchMethodError catch (e) {
      print("tried to catch....?");
      InAppPayments.showCardNonceProcessingError(
          "Something has gone wrong, because it appears you are not signed in to any account. Please sign in and then try again.");
    }

    // set up POST request arguments
    String url = 'http://10.0.2.2:8080'; //todo remember to change for production!
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "nonce": "${result.nonce}", "token": "${await token}" }'; // make POST request
    Response response;
    try {
      response = await post(url, headers: headers, body: json).timeout(Duration(seconds: 30));
    } catch (e) {
      InAppPayments.showCardNonceProcessingError(
        //todo show same error as from homepage
          "Unable to contact the server. Please check your internet connection and try again, or contact support if the problem persists.");
    }
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    try {
      if (statusCode != 200) {
        //todo test
        throw Exception(response);
      }
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _saveOnCardEntryComplete,
      );
    } catch (e) {
      InAppPayments.showCardNonceProcessingError(
          jsonDecode(e.message.body)["errorMessage"]); //todo check if works
    }
  }

  void _saveOnCardEntryCancel() {
    _completer.complete(false);
  }

  void _saveOnCardEntryComplete() {
    _completer.complete(true);
  }

//</editor-fold>

  //<editor-fold desc="pay">
  // start the process of paying.
  // Returns a Future<bool> that resolves to
  // true if the payment worked,
  // false if a nonce was requested and canceled,
  // or resolves to an error if something went wrong.
  // todo does this have unexpected behavior if a method that returns a future is called again before the first future resolves?
  Future<bool> pay(bool isCof) {
    InAppPayments.setSquareApplicationId("sandbox-sq0idb-u0xVRfqSvIDBU-2qw__JEQ");
    if (!isCof) {
      throw UnimplementedError("payments without cof not yet implemented"); //todo
    } else {
      _tellServer();
    }
    return _completer.future;
  }

  void _tellServer() async {
    final _token = _auth.getIdToken();
    try {
      // set up POST request arguments
      String url = 'http://10.0.2.2:8081'; //todo remember to change for production!
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"token": "${await _token}" }'; // make POST request
      Response response =
          await post(url, headers: headers, body: json).timeout(Duration(seconds: 30));
      // check the status code for the result
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        //todo test
        throw Exception(response);
      }
      _completer.complete(true);
    } catch (e) {
      _completer.completeError(e); //todo test
    }
//</editor-fold>
  }
}
