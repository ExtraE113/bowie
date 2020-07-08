import 'package:flutter/material.dart';

//todo validate
class TributeInformation extends StatelessWidget {
  final String title;
  final String checkBoxText;
  final bool sayOptional;

  TributeInformation({
    Key key,
    @required this.title,
    @required this.checkBoxText,
    this.sayOptional = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: TributeInformationData(),
      builder: (FormFieldState<TributeInformationData> field) {
        final _fnameController = TextEditingController(text: field.value.fname);
        _fnameController.addListener(() {
          field.value.fname = _fnameController.text;
        });
        final _lnameController = TextEditingController(text: field.value.lname);
        _lnameController.addListener(() {
          field.value.lname = _lnameController.text;
        });
        return ExpansionTile(
          title: Text("$title ${sayOptional ? "(optional)" : ""}"),
          children: [
            CheckboxListTile(
              value: field.value.checked,
              title: Text(checkBoxText),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool value) {
                field.value.checked = value;
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
                    enabled: field.value.checked,
                    decoration: InputDecoration(hintText: "Honoree First Name"),
                    controller: _fnameController,
                  ),
                  TextField(
                    enabled: field.value.checked,
                    decoration: InputDecoration(hintText: "Honoree Last Name", errorText: "Test"),
                    controller: _lnameController,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class TributeInformationData {
  bool checked = false;
  String fname = "";
  String lname = "";
}
