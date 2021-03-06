import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';

//Primary == 0xFFFF7643
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const greyColor = Color(0xffE8E8E8);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const double screenPadding = 10;

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter Your Email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kGenderNullError = "Please Enter Your Gender";
const String kUserNameNullError = "Please Enter User Name";
const String kPassNullError = "Please Enter your Password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your Name";
const String kPhoneNumberNullError = "Please Enter your Phone Number";
const String kAddressNullError = "Please Enter your address";
const String FIELD_REQUIRED_MSG = "This field is required";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}