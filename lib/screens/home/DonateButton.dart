import 'dart:async';

import 'package:bowie/services/auth.dart';
import 'package:bowie/services/square.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonateButton extends StatefulWidget {
  @override
  _DonateButtonState createState() => _DonateButtonState();
}

class _DonateButtonState extends State<DonateButton> {
  Widget _state;

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
      _state = Icon(
        Icons.card_giftcard,
        size: 100,
        color: Theme.of(context).primaryColorDark,
      );
    }

    // it's hacky, but if it's not a icon (ie its a circular progress indicator)
    // then we know we're already in progress and we shouldn't start again
    var runtimeTypeName = _state.toString();
    bool _shouldDisable = !runtimeTypeName.contains("Icon");

    return RaisedButton(
      onPressed: _shouldDisable ? null : () async {


        final _auth = AuthService();
        final _curUser = await _auth.getUser();
        if (_curUser.isAnonymous) {
          UnimplementedError(); //todo
        } else {
          setState(() {
            _state = SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                strokeWidth: 10,
              ),
            );
          });

          final _square = SquareService();
          setState(() {
            _square.pay(true).then((value) {
              if (value == true) {
                _state = Icon(
                  Icons.done,
                  size: 100,
                  color: Theme.of(context).primaryColorDark,
                );
              } else {
                if (value == false) {
                  _state = Icon(
                    Icons.card_giftcard,
                    size: 100,
                    color: Theme.of(context).primaryColorDark,
                  );
                }
              }
              return null;
            }).catchError((error) {
              _showErrorDialog(Text("Unable to contact the servers."),
                  child: Text(
                      "Your device may be offline. If the problem persists, please contact technical support."));
              setState(() {
                _state = Icon(
                  Icons.error_outline,
                  size: 100,
                  color: Theme.of(context).primaryColorDark,
                );
              });
              return null;
            }, test: (e) => e is TimeoutException).catchError((error) {
              setState(() {
                _state = Icon(
                  Icons.error_outline,
                  size: 100,
                  color: Theme.of(context).primaryColorDark,
                );
              });

              _showErrorDialog(Text(error.toString()));

              return null;
            }).whenComplete(() {
              return Future.delayed(Duration(seconds: 6)).then((value) {
                setState(() {

                  // it's hacky, but if it's not a icon (ie its a circular progress indicator)
                  // then don't reset it
                  var runtimeTypeName = _state.toString();
                  if(!runtimeTypeName.contains("Icon")){
                    return null;
                  }

                  _state = Icon(
                    Icons.card_giftcard,
                    size: 100,
                    color: Theme.of(context).primaryColorDark,
                  );
                });
                return null;
              });
            });
          });
        }
      },
      child: SizedBox(
        height: 130,
        width: 100,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: _state,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100)
      ),
      color: Colors.white,
      disabledColor: Colors.white,
    );
  }

  Future<void> _showErrorDialog(Widget title, {Widget child, List<Widget> actions}) async {
    if (actions == null) {
      actions = <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ];
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: child,
          ),
          actions: actions,
        );
      },
    );
  }
}