import 'package:flutter/material.dart';

class OutlineButton1 extends StatelessWidget {
  final String title;
  final VoidCallback press;
  const OutlineButton1({required this.title, required this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: OutlinedButton(
          onPressed: press,
          child: Text(
            title,
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}
