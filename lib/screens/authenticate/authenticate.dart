import 'package:flutter/material.dart';
import 'package:bowie/services/auth.dart';
import 'package:bowie/utils/scroll.dart';
import 'package:email_validator/email_validator.dart';

// er, *heavily inspired by* https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
// and by "The net Ninja"'s series on youtube

//todo have space below the secondary action button when the keyboard is up

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _passwd = '';

  bool _isLoginForm = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign in"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Builder(
            builder: (BuildContext context) {
              return Form(
                key: _formKey,
                child: ScrollConfiguration(
                  behavior: NoOverScrollGlow(),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      showEmailInput(),
                      showPasswordInput(),
                      showPrimaryButton(context),
                      SizedBox(height: 20),
                      showSecondaryButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          return !EmailValidator.validate(value.trim())
              ? 'Must be a valid email address'
              : null;
        },
        onChanged: (value) => _email = value,
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        // todo implement better password strength-- zxcvbn port?
        validator: (value) =>
            value.length < 6 ? 'Password must be at least 6 characters' : null,
        onChanged: (value) => _passwd = value,
      ),
    );
  }

  Widget showPrimaryButton(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () async {

              if (_formKey.currentState.validate()) {
                setState(() {
                  _hasError = false;
                });

                //dismiss keyboard
                FocusScope.of(context).unfocus();

                //then, 500 ms later, show Processing...
                Future.delayed(const Duration(milliseconds: 250), () {
                  if (!_hasError) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Processing..."),
                    ));
                  }
                });


                //meanwhile,
                try {
                  if(_isLoginForm){
                    var result = await _authService
                        .signInWithEmailAndPassword(_email.trim() /*todo fixme*/, _passwd);
                  } else {
                    var result = await _authService
                        .registerWithEmailAndPassword(_email.trim() /*todo fixme*/, _passwd);
                  }
                } catch (e) {
                  setState(() {
                    _hasError = true;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(e.message +
                          " Please check your input and try again.")));
                }
              }
            },
          ),
        ));
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  void toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
}
