import 'package:flutter/material.dart';

var myDefaultBackground = Colors.white;
late double? myDefaultFontSize;
class MyAppBar extends StatelessWidget{
  final title;
  const MyAppBar({super.key,this.title});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      title: Text(title),
    );
  }
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlue,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  // hintText: hintText, //'Enter your email',
  hintStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const kToolBarHeight = 36;
