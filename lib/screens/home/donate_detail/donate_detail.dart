import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'donate_amount_chips.dart';
import 'package:bowie/screens/home/donate_detail/optional_info.dart';

//todo finish
//todo save

class DonateDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donation Settings")),
      body: DonateInfoForm(),
    );
  }
}

class DonateInfoForm extends StatefulWidget {
  @override
  DonateInfoFormState createState() {
    return DonateInfoFormState();
  }
}

class DonateInfoFormState extends State<DonateInfoForm> {
  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        //todo disable overscroll when it's not needed
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    "Please set up some donation information.",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle: Text("You'll only have to do this once and you can edit it at any time."),
              ),
              DonationAmountFormField(),
              TributeInformation(
                title: "Tribute information",
                checkBoxText: "Donate as a tribute",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListTile(
                  title: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
