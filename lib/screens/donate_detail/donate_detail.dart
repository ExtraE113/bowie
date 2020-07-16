import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:bowie/services/square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'donate_amount_chips.dart';

import 'optional_info.dart';

//todo save
//todo validate
//todo if it's not [firstTime] edit the text (esp subtitles)

class DonateDetail extends StatelessWidget {
  final bool firstTime;

  DonateDetail({@required this.firstTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donation Settings")),
      body: DonateInfoForm(firstTime: firstTime),
    );
  }
}

class DonateInfoForm extends StatefulWidget {
  final bool firstTime;

  @override
  DonateInfoFormState createState() {
    return DonateInfoFormState();
  }

  DonateInfoForm({@required this.firstTime});
}

class DonateInfoFormState extends State<DonateInfoForm> {
  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    widget.firstTime
                        ? "Please set up some donation information."
                        : "Donation information",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle: Text(widget.firstTime
                    ? "You'll only have to do this once and you can edit it at any time."
                    : "You can edit this at any time."),
              ),
              DonationAmountFormField(),
              TributeInformationFormField(),
              PersonalInformationFormField(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListTile(
                  title: widget.firstTime
                      ? RaisedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Processing Data')));
                              _save();
                              final _square = SquareService();
                              final bool saved = await _square.save();
                              if (saved == true) {
                                print("should notify listeners");
                                Provider.of<LoginAction>(context, listen: false)
                                    .doneOnBoarding = true;
                                print("here");
                                Navigator.of(context).pushReplacementNamed('/');
                              }
                            }
                          },
                          child: Text('Next'),
                        )
                      : RaisedButton(
                          child: Text('Save'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _save();
                              //fully just lying to the user, but it feels better
                              Future.delayed(Duration(seconds: 1)).then((_) {
                                Navigator.of(context).pop();
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Processing..."),
                              ));
                            }
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    try {
      _formKey.currentState.save();
    } catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Something went wrong."),
            content: SingleChildScrollView(
              child: Text(
                  "If the problem persists, please contact technical support."),
            ),
          );
        },
      );
    }
  }
}
