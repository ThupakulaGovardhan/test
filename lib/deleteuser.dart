import 'package:flutter/material.dart';
import 'package:flutter_application_5/colors.dart';
import 'package:flutter_application_5/indexpage.dart';


showMessage(BuildContext context,String contentMessage) {


    Widget yesButton = ElevatedButton(
      child: Text("OK",style: TextStyle(color: primary)),
      onPressed:  () {
        Navigator.pop(context);
        
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        IndexPage()), (Route<dynamic> route) => false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(contentMessage),
      actions: [
        yesButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }