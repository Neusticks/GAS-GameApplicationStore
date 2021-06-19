import 'package:flutter/material.dart';

class SpecificInformationMenu extends StatelessWidget {
  const SpecificInformationMenu({
    Key key,
    @required this.text,
    // @required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
          decoration: BoxDecoration
          (
            color: Color(0xFFF5F6F9),
            borderRadius: BorderRadius.only
            (
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(child: Text(text, style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }
}