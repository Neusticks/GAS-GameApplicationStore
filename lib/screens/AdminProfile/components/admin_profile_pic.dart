import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_gameappstore/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:gas_gameappstore/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:gas_gameappstore/screens/AdminProfile/provider_models/body_models.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:gas_gameappstore/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:gas_gameappstore/services/local_files_access/local_files_access_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';
import '../../../constants.dart';

class AdminProfilePic extends StatelessWidget {
  const AdminProfilePic({
    Key key,
    this.bodyState,
  }) : super(key: key);
  final ChosenImage bodyState;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionScreenWidth(screenPadding)),
            child: SizedBox(
              width: 175,
              height: 160,
              child: Consumer<ChosenImage>(
                builder: (context, bodyState, child) {
                  return Stack(
                    children: [
                      SizedBox(height: getProportionScreenHeight(0)),
                      GestureDetector(
                        child: buildDisplayPictureAvatar(context, bodyState),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: SizedBox(
                          height: 55,
                          width: 55,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(color: Colors.white),
                            ),
                            color: Color(0xFFF5F6F9),
                            onPressed: () {
                              getImageFromUser(context, bodyState);
                            },
                            child: SvgPicture.asset(
                                "assets/icons/Camera Icon.svg"),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        ImageProvider backImage;
        if (bodyState.chosenImage != null) {
          backImage = MemoryImage(bodyState.chosenImage.readAsBytesSync());
        } else if (snapshot.hasData && snapshot.data != null) {
          final String url =
              snapshot.data.data()[UserDatabaseHelper.USER_PROFILE_PICTURE_KEY];
          if (url != null) backImage = NetworkImage(url);
        }
        return CircleAvatar(
          radius: SizeConfig.screenWidth * 0.24,
          backgroundColor: kTextColor.withOpacity(0.5),
          backgroundImage: backImage ?? null,
        );
      },
    );
  }

  void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    String path;
    String snackbarMessage;
    try {
      path = await choseImageFromLocalFiles(context);
      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
    } on LocalFileHandlingException catch (e) {
      Logger().i("LocalFileHandlingException: $e");
      snackbarMessage = e.toString();
    } catch (e) {
      Logger().i("LocalFileHandlingException: $e");
      snackbarMessage = e.toString();
    } finally {
      if (snackbarMessage != null) {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
    if (path == null) {
      return;
    }
    bodyState.setChosenImage = File(path);
    uploadImageToFirestorage(context, bodyState);
  }

  Widget buildUserProfilePicture(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 1,
      ),
      child: FutureBuilder(
        future: UserDatabaseHelper().displayPictureForCurrentUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
          } else if (snapshot.data == null) {
            return CircleAvatar(
              backgroundImage: AssetImage("assets/images/profileimage.png"),
            );
          }
          return CircleAvatar(
            backgroundColor: kTextColor,
          );
        },
      ),
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage bodyState) async {
    bool uploadDisplayPictureStatus = false;
    String snackbarMessage;
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          bodyState.chosenImage,
          UserDatabaseHelper().getPathForCurrentUserDisplayPicture());

      uploadDisplayPictureStatus = await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(downloadUrl);
      if (uploadDisplayPictureStatus == true) {
        snackbarMessage = "Display Picture updated successfully";
      } else {
        throw "Coulnd't update display picture due to unknown reason";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
    } finally {
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
  }
}
