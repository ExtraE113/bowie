//todo validate
import 'package:flutter/material.dart';

class TributeInformationFormField extends StatelessWidget {
  final String title = "Tribute information";
  final String checkBoxText =  "Donate as a tribute";
  final bool sayOptional =  true;

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
                    decoration: InputDecoration(labelText: "Honoree First Name"),
                    controller: _fnameController,
                  ),
                  TextField(
                    enabled: field.value.checked,
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
  }
}

class TributeInformationData {
  bool checked = false;
  String fname = "";
  String lname = "";
}

//Not sure how, but todo dry this out

class PersonalInformationFormField extends StatelessWidget {
  final String title = "Personal information";
  final bool sayOptional = true;

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: PersonalInformationData(),
      builder: (FormFieldState<PersonalInformationData> field) {
        final _fnameController = TextEditingController(text: field.value.fname);
        _fnameController.addListener(() {
          field.value.fname = _fnameController.text;
          field.didChange(field.value);
        });
        final _lnameController = TextEditingController(text: field.value.lname);
        _lnameController.addListener(() {
          field.value.lname = _lnameController.text;
          field.didChange(field.value);
        });
        final _addressController = TextEditingController(text: field.value.address);
        _lnameController.addListener(() {
          field.value.address = _addressController.text;
          field.didChange(field.value);
        });
        return ExpansionTile(
          title: Text("$title ${sayOptional ? "(optional)" : ""}"),
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
                        value: field.value.state,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        items: PersonalInformationData.stateslist
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          field.value.state = value;
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
  }
}

class PersonalInformationData {
  String fname = "";
  String lname = "";
  String title = "";
  String address = "";
  String city = "";
  String state = "California";
  static final stateslist = '''Alabama
Alaska
Arizona
Arkansas
California
Colorado
Connecticut
Delaware
Columbia
Florida
Georgia
Hawaii
Idaho
Illinois
Indiana
Iowa
Kansas
Kentucky
Louisiana
Maine
Maryland
Massachusetts 
Michigan
Minnesota
Mississippi
Missouri
Montana
Nebraska
Nevada
New Hampshire
New Jersey
New Mexico
New York
North Carolina
North Dakota
Ohio
Oklahoma
Oregon
Pennsylvania
Puerto Rico
Rhode Island
South Carolina
South Dakota
Tennessee
Texas
Utah
Vermont
Virginia
Washington
West Virginia
Wisconsin
Wyoming'''
      .split("\n");
  String country = "";
  String zip = "";
  String phone = "";
}
