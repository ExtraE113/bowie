//todo validate
//todo better loading
//todo DRY OUT
import 'package:bowie/services/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bowie/utils/consts.dart';

class TributeInformationFormField extends StatefulWidget {
  final String title = "Tribute information";

  final String checkBoxText = "Donate as a tribute";

  final bool sayOptional = true;

  @override
  _TributeInformationFormFieldState createState() => _TributeInformationFormFieldState();
}

class _TributeInformationFormFieldState extends State<TributeInformationFormField> {
  FirestoreService _firestore;
  Future<Map> _data;

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _data = _firestore.getSettings("tribute");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          return FormField(
            initialValue: snapshot.data,
            onSaved: (value) {
              final FirestoreService _firestore = FirestoreService();
              _firestore.saveSettings(value, "tribute");
            },
            builder: (FormFieldState<Map> field) {
              final _fnameController = TextEditingController(text: field.value["fname"]);
              _fnameController.addListener(() {
                field.value["fname"] = _fnameController.text;
              });
              final _lnameController = TextEditingController(text: field.value["lname"]);
              _lnameController.addListener(() {
                field.value["lname"] = _lnameController.text;
              });
              return ExpansionTile(
                title: Text("${widget.title} ${widget.sayOptional ? "(optional)" : ""}"),
                children: [
                  CheckboxListTile(
                    value: field.value["checked"] ?? false,
                    title: Text(widget.checkBoxText),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      field.value["checked"] = value;
                      field.didChange(field.value);
                    },
                  ),
                  ListTile(
                    leading: Column(
                      children: [
                        Spacer(),
                        Icon(Icons.person_add),
                        Spacer(),
                      ],
                    ),
                    title: Column(
                      children: [
                        TextField(
                          enabled: field.value["checked"],
                          decoration: InputDecoration(labelText: "Honoree First Name"),
                          controller: _fnameController,
                        ),
                        TextField(
                          enabled: field.value["checked"],
                          decoration: InputDecoration(labelText: "Honoree Last Name"),
                          controller: _lnameController,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

//Not sure how, but todo dry this out

class PersonalInformationFormField extends StatefulWidget {
  final String title = "Personal information";

  final bool sayOptional = true;

  @override
  _PersonalInformationFormFieldState createState() => _PersonalInformationFormFieldState();
}

class _PersonalInformationFormFieldState extends State<PersonalInformationFormField> {
  FirestoreService _firestore;
  Future<Map> _data;

  @override
  void initState() {
    super.initState();
    _firestore = FirestoreService();
    _data = _firestore.getSettings("personal");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          return FormField(
                    onSaved: (value) {
                      final FirestoreService _firestore = FirestoreService();
                      _firestore.saveSettings(value, "personal");
                    },
                    initialValue: snapshot.data,
                    builder: (FormFieldState<Map> field) {
                      final _fnameController = TextEditingController(text: field.value["fname"]);
                      _fnameController.addListener(() {
                        field.value["fname"] = _fnameController.text;
                      });
                      final _lnameController = TextEditingController(text: field.value["address"]);
                      _lnameController.addListener(() {
                        field.value["address"] = _lnameController.text;
                      });
                      final _addressController = TextEditingController(text: field.value["address"]);
                      _addressController.addListener(() {
                        field.value["address"] = _addressController.text;
                      });
                      return ExpansionTile(
                        title: Text("${widget.title} ${widget.sayOptional ? "(optional)" : ""}"),
                        children: [
                          ListTile(
                            leading: Column(
                              children: [
                                Spacer(),
                                Icon(Icons.person_add),
                                Spacer(),
                              ],
                            ),
                            title: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(labelText: "First Name"),
                                  controller: _fnameController,
                                ),
                                TextField(
                                  decoration: InputDecoration(labelText: "Last Name"),
                                  controller: _lnameController,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Column(
                              children: [
                                Spacer(),
                                Icon(Icons.home),
                                Spacer(),
                              ],
                            ),
                            title: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(labelText: "Address"),
                                  controller: _addressController,
                                ),
                                TextField(
                                  decoration: InputDecoration(labelText: "City"),
                                  controller: _addressController,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(labelText: "City"),
                                        controller: _addressController,
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: field.value["state"],
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      items: consts.stateslist.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String value) {
                                        field.value["state"] = value;
                                        field.didChange(field.value);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
