import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:gas_gameappstore/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:gas_gameappstore/models/Store.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:gas_gameappstore/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:gas_gameappstore/services/local_files_access/local_files_access_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CreateStoreForm extends StatefulWidget {
  final Store store;
  const CreateStoreForm({
    this.store,
    Key key,
  }) : super(key: key);

  @override
  _CreateStoreFormState createState() => _CreateStoreFormState();
}

class _CreateStoreFormState extends State<CreateStoreForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController storeNameController = TextEditingController();

  final TextEditingController storeAddressController = TextEditingController();

  final TextEditingController storeSellerNameController =
      TextEditingController();

  final TextEditingController storeDescriptionController =
      TextEditingController();

  Store store;

  @override
  void dispose() {
    storeNameController.dispose();
    storeSellerNameController.dispose();
    storeAddressController.dispose();
    storeDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
    child: Column(
      children: [
        Text(
          "Create Store",
          style: headingStyle,
        ),
        // SizedBox(height: getProportionScreenHeight(10)),
        // buildStoreNameField(),
        // SizedBox(height: getProportionScreenHeight(20)),
        // buildStoreSellerNameField(),
        // SizedBox(height: getProportionScreenHeight(20)),
        // buildStoreAddressField(),
        // SizedBox(height: getProportionScreenHeight(30)),
        // buildStoreDescriptionField(),
        SizedBox(height: getProportionScreenHeight(20)),
        buildBasicDetailsTile(context),
        SizedBox(height: getProportionScreenHeight(30)),
        DefaultButton(
          text: "Create New Store",
          press: () {
            // final uploadFuture = 
            createStoreButtonCallback();
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return FutureProgressDialog(
            //       uploadFuture,
            //       message: Text("Creating Store"),
            //     );
            //   },
            // );
          },
        ),
      ],
    )
    );

    return form;
  }

  Widget buildStoreNameField() {
    return TextFormField(
      controller: storeNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter New Store Name",
        labelText: "Store Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (storeNameController.text.isEmpty) {
          return "Store Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStoreSellerNameField() {
    return TextFormField(
      controller: storeSellerNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Seller Name",
        labelText: "Seller Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (storeSellerNameController.text.isEmpty) {
          return "Seller Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  Widget buildBasicDetailsTile(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildStoreNameField(),
          SizedBox(height: getProportionScreenHeight(20)),
          buildStoreSellerNameField(),
          SizedBox(height: getProportionScreenHeight(20)),
          buildStoreDescriptionField(),
          SizedBox(height: getProportionScreenHeight(20)),
          buildStoreAddressField(),
          SizedBox(height: getProportionScreenHeight(20)),
        ],
      ),
    );
  }

  // Widget buildStoreSellerNameField() {
  //   return StreamBuilder<User>(
  //     stream: AuthentificationService().userChanges,
  //     builder: (context, snapshot) {
  //       String displayName;
  //       if (snapshot.hasData && snapshot.data != null)
  //         displayName = snapshot.data.displayName;
  //       final textField = TextFormField(
  //         controller: currentDisplayNameController,
  //         decoration: InputDecoration(
  //           hintText: "No Display Name available",
  //           labelText: "Current Store name",
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           suffixIcon: Icon(Icons.person),
  //         ),
  //         readOnly: true,
  //       );
  //       if (displayName != null)
  //         currentDisplayNameController.text = displayName;
  //       return textField;
  //     },
  //   );
  // }

  Widget buildStoreAddressField() {
    return TextFormField(
      maxLines: 5,
      controller: storeAddressController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Store Address",
        labelText: "Store Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (storeAddressController.text.isEmpty) {
          return "Store Address cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStoreDescriptionField() {
    return TextFormField(
      maxLines: 4,
      controller: storeDescriptionController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Store Description",
        labelText: "Store Description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (storeDescriptionController.text.isEmpty) {
          return "Store Description cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  // Future<void> changeDisplayNameButtonCallback() async {
  //   if (_formKey.currentState.validate()) {
  //     _formKey.currentState.save();
  //     await AuthentificationService()
  //         .updateCurrentUserDisplayName(newDisplayNameController.text);
  //     String uid = AuthentificationService().currentUser.uid;
  //     final userDocSnapshot =
  //         FirebaseFirestore.instance.collection('users').doc(uid);
  //     await userDocSnapshot.update({"userName": newDisplayNameController.text});
  //     print("Display Name updated to ${newDisplayNameController.text} ...");
  //   }
  // }

  // Widget buildUploadImagesTile(BuildContext context) {
  //   return ChangeNotifierProvider(
  //     create: (context) => ChosenImage(),
  //     child: SafeArea(
  //       child: Consumer<ChosenImage>(
  //         builder: (context, bodyState, child) {
  //           return Column(
  //             children: [
  //               Text(
  //                 "Upload Store Image",
  //               ),
  //               SizedBox(height: getProportionScreenHeight(40)),
  //               GestureDetector(
  //                 onTap: () {
  //                   getImageFromUser(context, bodyState);
  //                 },
  //               ),
  //               SizedBox(height: getProportionScreenHeight(80)),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget buildUploadImagesTile(BuildContext context) {
  //   return ExpansionTile(
  //     title: Text(
  //       "Upload Images",
  //       style: Theme.of(context).textTheme.headline6,
  //     ),
  //     leading: Icon(Icons.image),
  //     childrenPadding:
  //         EdgeInsets.symmetric(vertical: getProportionScreenHeight(20)),
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: IconButton(
  //             icon: Icon(
  //               Icons.add_a_photo,
  //             ),
  //             color: kTextColor,
  //             onPressed: () {
  //               addImageButtonCallback();
  //             }),
  //       ),
  //       Consumer<ChosenImage>(
  //         builder: (context, store, child) {
  //           return Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         getImageFromUser(context,store);
  //                       },
  //                   ),
  //             ]);}
  //               )
  //             ],
  //           );
  // }

  // void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
  //   String path;
  //   String snackbarMessage;
  //   try {
  //     path = await choseImageFromLocalFiles(context);
  //     if (path == null) {
  //       throw LocalImagePickingUnknownReasonFailureException();
  //     }
  //   } on LocalFileHandlingException catch (e) {
  //     Logger().i("LocalFileHandlingException: $e");
  //     snackbarMessage = e.toString();
  //   } catch (e) {
  //     Logger().i("LocalFileHandlingException: $e");
  //     snackbarMessage = e.toString();
  //   } finally {
  //     if (snackbarMessage != null) {
  //       Logger().i(snackbarMessage);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(snackbarMessage),
  //         ),
  //       );
  //     }
  //   }
  //   if (path == null) {
  //     return;
  //   }
  //   bodyState.setChosenImage = File(path);
  //   uploadImageToFirestorage(context, bodyState);
  // }

  // Future<void> uploadImageToFirestorage(
  //     BuildContext context, ChosenImage bodyState) async {
  //   bool uploadStoreDisplayPictureStatus = false;
  //   String snackbarMessage;
  //   try {
  //     final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
  //         bodyState.chosenImage,
  //         StoreDatabaseHelper().getPathForCurrentUserStoreDisplayPicture());

  //     uploadStoreDisplayPictureStatus =
  //         await StoreDatabaseHelper().uploadStoreDisplayPicture(downloadUrl);
  //     if (uploadStoreDisplayPictureStatus == true) {
  //       snackbarMessage = "Store Picture updated successfully";
  //     } else {
  //       throw "Coulnd't update Store picture due to unknown reason";
  //     }
  //   } on FirebaseException catch (e) {
  //     Logger().w("Firebase Exception: $e");
  //     snackbarMessage = "Something went wrong";
  //   } catch (e) {
  //     Logger().w("Unknown Exception: $e");
  //     snackbarMessage = "Something went wrong";
  //   } finally {
  //     Logger().i(snackbarMessage);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(snackbarMessage),
  //       ),
  //     );
  //   }
  // }

  Future<void> createStoreButtonCallback() async {
    String snackbarMessage;
    String storeId;
    try {
      final storeUploadFuture = 
          StoreDatabaseHelper().createUserStore(storeId, storeNameController.text, storeSellerNameController.text, storeAddressController.text, storeDescriptionController.text);
      storeUploadFuture.then((value) {
        storeId = value;
        UserDatabaseHelper().updateUserStoreId(storeId);
      });
      snackbarMessage = "Store Created";
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = e.toString();
    } finally {
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
      Navigator.pop(context);
    }
  }
  // Future<void> addImageButtonCallback({int index}) async {
  //   String path;
  //   String snackbarMessage;
  //   try {
  //     path = await choseImageFromLocalFiles(context);
  //     if (path == null) {
  //       throw LocalImagePickingUnknownReasonFailureException();
  //     }
  //   } on LocalFileHandlingException catch (e) {
  //     Logger().i("Local File Handling Exception: $e");
  //     snackbarMessage = e.toString();
  //   } catch (e) {
  //     Logger().i("Unknown Exception: $e");
  //     snackbarMessage = e.toString();
  //   } finally {
  //     if (snackbarMessage != null) {
  //       Logger().i(snackbarMessage);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(snackbarMessage),
  //         ),
  //       );
  //     }
  //   }
  //   if (path == null) {
  //     return;
  //   }
  // }

}
