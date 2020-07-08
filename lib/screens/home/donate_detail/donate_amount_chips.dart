import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonationAmountFormField extends FormField<DonationAmountData> {
  DonationAmountFormField()
      : super(
          validator: (value) => value.selected.length > 0
              ? null
              : "Please select up to three default donation amounts.",
          initialValue: DonationAmountData(),
          builder: (FormFieldState<DonationAmountData> field) {
            return Column(
              children: [
                ListTile(
                  title: Text("Default donation amount"),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Each dollar you donate helps us provide \$7 worth of groceries."),
                      SizedBox(height: 3),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4.0,
                        children: [
                          for (int i = 0; i < field.value.chips.length; i++)
                            Builder(
                              builder: (BuildContext context) => ChoiceChip(
                                label: Text('${field.value.chips[i].displayString()}'),
                                selected: field.value.isSelected(i),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.black, fontSize: 16),
                                onSelected: (bool isSelected) {
                                  field.value.selectedToggle(i, isSelected);
                                  field.didChange(field.value);
                                },
                                pressElevation: 0,
                              ),
                            ),
                          Builder(
                            builder: (BuildContext context) => ChoiceChip(
                              label: Text('Other'),
                              selected: false,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.black, fontSize: 16),
                              onSelected: (bool isSelected) async {
                                int amount = await _showOtherAmountDialog(context);
                                if (amount > 0) {
                                  field.value.chips.add(_ChipData(amount, isOther: true));
                                  field.value.selectedToggle(field.value.selected.length, true);
                                  field.didChange(field.value);
                                }
                              },
                              pressElevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                field.hasError
                    ? Builder(
                        builder: (BuildContext context) => Text(
                              field.errorText,
                              style: TextStyle(color: Theme.of(context).errorColor),
                            ))
                    : Container(),
              ],
            );
          },
        );
}

class DonationAmountData {
  _SelectedQueue _selected;
  List<_ChipData> chips = List.from(
      [_ChipData(100), _ChipData(500), _ChipData(1000), _ChipData(1500), _ChipData(2000)],
      growable: true);

  List<int> get selected {
    var _out = List<int>.from([], growable: true);
    _selected.forEach((element) {
      _out.add(chips[element].cents);
    });
    return _out;
  }

  DonationAmountData([int selected]) {
    this._selected = selected == null ? _SelectedQueue() : selected;
  }

  ///Toggles a [Chip] from selected to deselected
  ///Takes [index] index to add, and [isSelected] for weather to add or remove element.
  ///Returns [bool] based on weather the operation was successful.
  bool selectedToggle(int index, bool isSelected) {
    if (isSelected) {
      _selected.add(index);
      return true;
    } else {
      return _selected.remove(index);
    }
  }

  bool isSelected(int index) {
    return _selected.contains(index);
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

class _ChipData {
  int cents;
  bool isOther;

  _ChipData(int cents, {bool isOther = false}) {
    this.cents = cents;
    this.isOther = isOther;
  }

  @override
  String toString() {
    return _centsToDollarsRepresentation(cents);
  }

  String displayString() {
    return "${isOther ? "Other: " : ""}${toString()}";
  }

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
      return "\$$_dollars";
    } else {
      return "\$$_dollars.$_centsString";
    }
  }
}

class _SelectedQueue<E> extends ListQueue<E> {
  final int maxSize;

  _SelectedQueue([this.maxSize = 3]);

  @override
  void add(E value) {
    super.add(value);
    if (this.length > maxSize) {
      removeFirst();
    }
  }
}
