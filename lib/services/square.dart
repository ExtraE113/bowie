import 'dart:convert';

import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/auth.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';


void pay() {
  InAppPayments.setSquareApplicationId("sandbox-sq0idb-u0xVRfqSvIDBU-2qw__JEQ");
  InAppPayments.startCardEntryFlow(
    onCardNonceRequestSuccess: _payOnCardNonceRequestSuccess,
    onCardEntryCancel: _payOnCardEntryCancel,
  );
}

//<editor-fold desc="pay callbacks">
void _payOnCardNonceRequestSuccess(CardDetails result) async {
  try {
    // set up POST request arguments
    String url = 'https://donate-app-accfb.herokuapp.com/chargeForCookie';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "nonce": "${result.nonce}" }'; // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      //todo test
      throw Exception(response);
    }
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _payOnCardEntryComplete,
    );
  } catch (e) {
    print("here");
    InAppPayments.showCardNonceProcessingError(
        jsonDecode(e.message.body)["errorMessage"]); //todo test
  }
}

void _payOnCardEntryCancel() {}

void _payOnCardEntryComplete() {
  // Success
}
//</editor-fold>

void save() {
  InAppPayments.setSquareApplicationId("sandbox-sq0idb-u0xVRfqSvIDBU-2qw__JEQ");
  InAppPayments.startCardEntryFlow(
    onCardNonceRequestSuccess: _saveOnCardNonceRequestSuccess,
    onCardEntryCancel: _saveOnCardEntryCancel,
  );
}

void _saveOnCardNonceRequestSuccess(CardDetails result) async {
  final _auth = AuthService();
  final token = _auth.getIdToken();
  try {
    // set up POST request arguments
    String url = 'http://10.0.2.2:8080'; //todo remember to change for production!
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "nonce": "${result.nonce}", "token": "${await token}" }'; // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      //todo test
      throw Exception(response);
    }
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _saveOnCardEntryComplete,
    );
  } catch (e) {
    print("here");
    InAppPayments.showCardNonceProcessingError(
        jsonDecode(e.message.body)["errorMessage"]); //todo test
  }
}

void _saveOnCardEntryCancel() {}

void _saveOnCardEntryComplete() {

}

