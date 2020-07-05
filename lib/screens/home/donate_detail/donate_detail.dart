import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonateDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donation Settings")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
          child: Column(
            children: [
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
              SizedBox(height: 8),
              ListTile(
                  title: Text("Default donation amount:"),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Each dollar you donate lets us provide \$7 worth of groceries."),
                      SizedBox(height: 3),
                      DonationAmountChip(),
                    ],
                  )),
              Tribute()
            ],
          ),
        ),
      ),
    );
  }
}

class Tribute extends StatefulWidget {
  @override
  _TributeState createState() => _TributeState();
}

class _TributeState extends State<Tribute> {
  bool _tribute = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Tribute information"),
      children: [
        CheckboxListTile(
          value: _tribute,
          onChanged: (bool value) {
            setState(() {
              _tribute = value;
            });
          },
          title: Text("Donate as a tribute"),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}

class DonationAmountChip extends StatefulWidget {
  const DonationAmountChip({
    Key key,
  }) : super(key: key);

  @override
  _DonationAmountChipState createState() => _DonationAmountChipState();
}

class _DonationAmountChipState extends State<DonationAmountChip> {
  final int _numChips = 5;

  int _selected = 3;
  int _otherAmount = -1;

  String _centsToDollarsRepresentation(int cents) {
    int _dollars = (cents / 100).truncate();
    int _onlyCents = cents - (_dollars * 100);

    String _centsString = _onlyCents.toString();

    if (_centsString.length == 1 && _onlyCents == 0) {
      _centsString += "0";
    } else if (_centsString.length == 1) {
      _centsString = "0" + _centsString;
    }

    if (_onlyCents == 0) {
      return "$_dollars";
    } else {
      return "$_dollars.$_centsString";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0,
      children: [
        for (int i = 0; i < _numChips; i++)
          ChoiceChip(
            label: Text('\$${i == 0 ? 1 : i * 5}'),
            selected: i == _selected,
            labelStyle:
                Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black, fontSize: 16),
            onSelected: (bool isSelected) {
              setState(() {
                if (isSelected) {
                  _selected = i;
                }
              });
            },
            pressElevation: 0,
          ),
        ChoiceChip(
          label: Text(_otherAmount != -1
              ? 'Other: \$${_centsToDollarsRepresentation(_otherAmount)}'
              : 'Other'),
          selected: _selected == _numChips,
          labelStyle:
              Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black, fontSize: 16),
          onSelected: (bool isSelected) async {
            if (isSelected) {
              int amount = await _showOtherAmountDialog(context);
              if (amount == -1) {
                return;
              }
              setState(() {
                _selected = _numChips;
                _otherAmount = amount;
              });
            }
          },
          pressElevation: 0,
        ),
      ],
    );
  }
}

Future<int> _showOtherAmountDialog(BuildContext context) async {
  return showDialog<int>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Enter Amount"),
        content: SingleChildScrollView(
          child: _OtherAmountForm(),
        ),
      );
    },
  );
}

class _OtherAmountForm extends StatefulWidget {
  @override
  _OtherAmountFormState createState() {
    return _OtherAmountFormState();
  }
}

class _OtherAmountFormState extends State<_OtherAmountForm> {
  final _formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(icon: Icon(Icons.attach_money)),
            keyboardType: TextInputType.number,
            autofocus: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }

              double valueAsDouble = double.tryParse(value);

              if (valueAsDouble == null) {
                return 'Please enter a number';
              }

              if (valueAsDouble <= 0) {
                return 'Please enter a positive number';
              }

              return null;
            },
            controller: _textEditingController,
          ),
          Center(
            child: Wrap(
              spacing: 32.0,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Navigator.of(context)
                            .pop((double.tryParse(_textEditingController.text) * 100).round());
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop(-1);
                    },
                    child: Text('Cancel'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
