

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/screens/StoreInformation/store_information.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

import '../../../size_config.dart';

class ChangeStoreNameForm extends StatefulWidget {
  const ChangeStoreNameForm({
    Key key,
  }) : super(key: key);

  @override
  _ChangeStoreNameFormState createState() => _ChangeStoreNameFormState();
}

class _ChangeStoreNameFormState extends State<ChangeStoreNameForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newStoreNameController =
      TextEditingController();

  final TextEditingController currentStoreNameController =
      TextEditingController();

  @override
  void dispose() {
    newStoreNameController.dispose();
    currentStoreNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentStoreNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewStoreNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Change Store Name",
            press: () {
              final uploadFuture = changeStoreNameButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    uploadFuture,
                    message: Text("Updating Store Name"),
                  );
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Store Name updated")));
              
            },
          
          ),
          
        ],
        
      ),
      
    );

    return form;
  }

  Widget buildNewStoreNameField() {
    return TextFormField(
      controller: newStoreNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter New Store Name",
        labelText: "New Store Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newStoreNameController.text.isEmpty) {
          return "Store Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentStoreNameField() {
    return StreamBuilder<QueryDocumentSnapshot>(
      stream: StoreDatabaseHelper().currentUserStoreDataStream,
      builder: (context, snapshot) {
        String storeName;
        if (snapshot.hasData && snapshot.data != null){
          Map<String, dynamic> docFields = snapshot.data.data();
          storeName = docFields["storeName"].toString();
        }
        final textField = TextFormField(
          controller: currentStoreNameController,
          decoration: InputDecoration(
            hintText: "No Store Name available",
            labelText: "Current Store Name",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person),
          ),
          readOnly: true,
        );
        if (storeName != null)
          currentStoreNameController.text = storeName;
        return textField;
      },
    );
  }

  Future<void> changeStoreNameButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      currentStoreNameController.text = newStoreNameController.text;
      String uid = AuthentificationService().currentUser.uid;
      final storeId = await StoreDatabaseHelper().getStoreId();
      print(storeId);
      final storeDocSnapshot = FirebaseFirestore.instance.collection('stores').doc(storeId);
      await storeDocSnapshot.update({"storeName" : newStoreNameController.text});
      print("Store Name updated to ${newStoreNameController.text} ...");
    }
  }
}
