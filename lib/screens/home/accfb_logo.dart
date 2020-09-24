import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showErrorDialog(Widget title,
        {Widget child, List<Widget> actions}) async {
      if (actions == null) {
        actions = <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ];
      }

      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: SingleChildScrollView(
              child: child,
            ),
            actions: actions,
          );
        },
      );
    }

    _launchURL() async {
      const url = 'https://accfb.org';

      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e, st) {
        Crashlytics.instance.recordError(e, st);
        _showErrorDialog(Text("Something went wrong."),
            child: Text("That's all we know. Error code 9673."));
      }
    }



    return GestureDetector(
      onTap: _launchURL,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 60),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(//todo local image
                "https://www.accfb.org/wp-content/uploads/2017/07/ACCFB_Logo_Header_RGB_506x122.png"),
          ),
        ),
      ),
    );

  }



}
