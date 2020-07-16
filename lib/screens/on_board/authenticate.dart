import 'package:flutter/material.dart';
import 'package:bowie/services/auth.dart';
import 'package:bowie/utils/scroll.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

// er, *heavily inspired by* https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
// and by "The net Ninja"'s series on youtube

class LoginAction with ChangeNotifier {
  //are we logging in or creating an account
  //defaults to not logging in (ie creating)
  bool login = false;

  //also, we need to know if we're done on boarding
  bool _doneOnBoarding = true;

  bool get doneOnBoarding => _doneOnBoarding;

  set doneOnBoarding(bool doneOnBoarding) {
    _doneOnBoarding = doneOnBoarding;
    notifyListeners();
  }

  //are we logging in anonymously
  bool anon = false;

  void toggleLoginAction() {
    if (login) {
      login = false;
      doneOnBoarding = false;
    } else {
      login = true;
      doneOnBoarding = true;
    }
    notifyListeners();
  }

  void loginAnon() {
    anon = true;
    notifyListeners();
  }

  void reset() {
    anon = false;
    doneOnBoarding = true;
    login = true;
  }
}

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
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Consumer<LoginAction>(
            builder: (BuildContext context, LoginAction value, Widget child) {
              return value.login
                  ? Text("Sign in")
                  : Text("Start supporting the food bank");
            },
          ),
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
                      //SizedBox(height: 10),
                      //SkipButton(), todo: after init release we can do this, but not a priority.
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
        child: Consumer<LoginAction>(builder: (context, loginAction, child) {
          return RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Theme.of(context).primaryColor,
            child: Consumer<LoginAction>(
              builder: (BuildContext context, LoginAction loginAction,
                  Widget child) {
                return Text(loginAction.login ? 'Login' : 'Create Account',
                    style: TextStyle(fontSize: 20.0, color: Colors.white));
              },
            ),
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
                  if (loginAction.login) {
                    var result = await _authService.signInWithEmailAndPassword(
                        _email.trim() /*todo fixme*/, _passwd);
                    Navigator.of(context).pushReplacementNamed('/');
                  } else {
                    var result =
                        await _authService.registerWithEmailAndPassword(
                            _email.trim() /*todo fixme*/, _passwd);
                    Navigator.of(context).pushReplacementNamed('/donate-detail-first');
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
          );
        }),
      ),
    );
  }

  Widget showSecondaryButton() {
    return Consumer<LoginAction>(
      builder: (context, LoginAction loginAction, child) {
        return FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: loginAction.toggleLoginAction,
          child: Text(
            loginAction.login
                ? 'Create an account'
                : 'Have an account? Sign in',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
          ),
        );
      },
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return new FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: new Text('Skip for now',
            style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300)),
        onPressed: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Processing..."),
          ));
          Provider.of<LoginAction>(context, listen: false).loginAnon();
          _auth.signInAnnon();
        });
  }
}
