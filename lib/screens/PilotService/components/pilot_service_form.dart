import 'package:gas_gameappstore/components/default_button.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PilotServiceForm extends StatefulWidget {
  const PilotServiceForm({
    Key key,
  }) : super(key: key);

  @override
  _PilotServiceFormState createState() => _PilotServiceFormState();
}

class _PilotServiceFormState extends State<PilotServiceForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newDisplayNameController =
      TextEditingController();

  final TextEditingController currentDisplayNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildEmailOrIdGameAccountField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildGameAccountPassword(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildChooseGame(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Request Game Pilot",
            press: () {},
          ),
        ],
      ),
    );

    return form;
  }

  Widget buildEmailOrIdGameAccountField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter Game Account Email or ID",
        labelText: "Game Account Display Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newDisplayNameController.text.isEmpty) {
          return "Email cannot be empty";
        }
        return null;
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildGameAccountPassword() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter Game Account Password",
        labelText: "Game Account Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newDisplayNameController.text.isEmpty) {
          return "Password cannot be empty";
        }
        return null;
      },
    );
  }

  Widget buildChooseGame() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Consumer<ProductDetails>(
        builder: (context, productDetails, child) {
          return DropdownButton(
            value: productDetails.productType,
            items: ProductType.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      EnumToString.convertToString(e),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              "Choose Game",
            ),
            style: TextStyle(
              color: kTextColor,
              fontSize: 16,
            ),
            onChanged: (value) {
              productDetails.productType = value;
            },
            elevation: 0,
            underline: SizedBox(width: 0, height: 0),
          );
        },
      ),
    );
  }
}
