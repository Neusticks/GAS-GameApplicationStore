

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/screens/StoreInformation/store_information.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

import '../../../size_config.dart';

class ChangeStoreDescForm extends StatefulWidget {
  const ChangeStoreDescForm({
    Key key,
  }) : super(key: key);

  @override
  _ChangeStoreDescFormState createState() => _ChangeStoreDescFormState();
}

class _ChangeStoreDescFormState extends State<ChangeStoreDescForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newStoreDescController =
      TextEditingController();

  final TextEditingController currentStoreDescController =
      TextEditingController();

  @override
  void dispose() {
    newStoreDescController.dispose();
    currentStoreDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentStoreDescField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewStoreDescField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Change Store Description",
            press: () {
              final uploadFuture = changeStoreDescButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    uploadFuture,
                    message: Text("Updating Store Description"),
                  );
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Store Description updated")));
              
            },
          
          ),
          
        ],
        
      ),
      
    );

    return form;
  }

  Widget buildNewStoreDescField() {
    return TextFormField(
      controller: newStoreDescController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter New Store Description",
        labelText: "New Store Description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newStoreDescController.text.isEmpty) {
          return "Store Description cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentStoreDescField() {
    return StreamBuilder<QueryDocumentSnapshot>(
      stream: StoreDatabaseHelper().currentUserStoreDataStream,
      builder: (context, snapshot) {
        String storeDesc;
        if (snapshot.hasData && snapshot.data != null){
          Map<String, dynamic> docFields = snapshot.data.data();
          storeDesc = docFields["storeDescription"].toString();
        }
        final textField = TextFormField(
          controller: currentStoreDescController,
          decoration: InputDecoration(
            hintText: "No Store Description available",
            labelText: "Current Store Description",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person),
          ),
          readOnly: true,
        );
        if (storeDesc != null)
          currentStoreDescController.text = storeDesc;
        return textField;
      },
    );
  }

  Future<void> changeStoreDescButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      currentStoreDescController.text = newStoreDescController.text;
      String uid = AuthentificationService().currentUser.uid;
      final storeId = await StoreDatabaseHelper().getStoreId();
      final storeDocSnapshot = FirebaseFirestore.instance.collection('stores').doc(storeId);
      await storeDocSnapshot.update({"storeDescription" : newStoreDescController.text});
      print("Store Description updated to ${newStoreDescController.text} ...");
    }
  }
}
