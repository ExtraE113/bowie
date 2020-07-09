import 'package:bowie/screens/on_board/thank_you.dart';
import 'package:bowie/services/square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'donate_amount_chips.dart';
import 'package:bowie/screens/home/donate_detail/optional_info.dart';

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
                    "Please set up some donation information.",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                subtitle: Text("You'll only have to do this once and you can edit it at any time."),
              ),
              DonationAmountFormField(),
              TributeInformationFormField(),
              PersonalInformationFormField(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListTile(
                  title: widget.firstTime ? RaisedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        //todo save to firebase
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                        final _square = SquareService();
                        final bool saved = await _square.save();
                        if (saved == true){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ThankYou()));
                        }
                      }

                    },
                    child: Text('Next'),
                  ) : RaisedButton(
                    child: Text('Save'),
                    onPressed: (){
                      //todo save to firebase
                      Navigator.of(context).pop();
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
}
