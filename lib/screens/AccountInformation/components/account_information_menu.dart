import 'package:flutter/material.dart';

class AccountInformationMenu extends StatelessWidget {
  const AccountInformationMenu({
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
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        // onPressed: press,
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon,
            //   color: kPrimaryColor,
            //   width: 22,
            // ),
            SizedBox(width: 20),
            Expanded(child: Text(text, style: TextStyle(fontSize: 20))),
            // Icon(Icons.arrow_forward_ios),
            TextButton(
              onPressed: press, 
              child: Text('Ubah', style: TextStyle(color: Colors.orange, fontSize: 20))),
          ],
        ),
      ),
    );
  }
}