

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/screens/StoreInformation/store_information.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

import '../../../size_config.dart';

class ChangeStoreAddressForm extends StatefulWidget {
  const ChangeStoreAddressForm({
    Key key,
  }) : super(key: key);

  @override
  _ChangeStoreAddressFormState createState() => _ChangeStoreAddressFormState();
}

class _ChangeStoreAddressFormState extends State<ChangeStoreAddressForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newStoreAddressController =
      TextEditingController();

  final TextEditingController currentStoreAddressController =
      TextEditingController();

  @override
  void dispose() {
    newStoreAddressController.dispose();
    currentStoreAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentStoreAddressField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewStoreAddressField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Change Store Address",
            press: () {
              final uploadFuture = changeStoreAddressButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    uploadFuture,
                    message: Text("Updating Store Address"),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
    return form;
  }

  Widget buildNewStoreAddressField() {
    return TextFormField(
      controller: newStoreAddressController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter New Store Address",
        labelText: "New Store Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newStoreAddressController.text.isEmpty) {
          return "Store Address cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentStoreAddressField() {
    return StreamBuilder<QueryDocumentSnapshot>(
      stream: StoreDatabaseHelper().currentUserStoreDataStream,
      builder: (context, snapshot) {
        String storeAddress;
        if (snapshot.hasData && snapshot.data != null){
          Map<String, dynamic> docFields = snapshot.data.data();
          storeAddress = docFields["storeAddress"].toString();
        }
        final textField = TextFormField(
          controller: currentStoreAddressController,
          decoration: InputDecoration(
            hintText: "No Store Address available",
            labelText: "Current Store Address",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person),
          ),
          readOnly: true,
        );
        if (storeAddress != null)
          currentStoreAddressController.text = storeAddress;
        return textField;
      },
    );
  }

  Future<void> changeStoreAddressButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      currentStoreAddressController.text = newStoreAddressController.text;
      String uid = AuthentificationService().currentUser.uid;
      final storeId = await StoreDatabaseHelper().getStoreId();
      final storeDocSnapshot = FirebaseFirestore.instance.collection('stores').doc(storeId);
      await storeDocSnapshot.update({"storeAddress" : newStoreAddressController.text});
      print("Store Address updated to ${newStoreAddressController.text} ...");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Store Address updated")));
      Navigator.pop(context);
    }
  }
}
