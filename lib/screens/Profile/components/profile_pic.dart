import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_gameappstore/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:gas_gameappstore/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:gas_gameappstore/services/local_files_access/local_files_access_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../provider_models/body_model.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  ChosenImage get bodyState => null;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/Profile Image.png"),
            ),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  color: Color(0xFFF5F6F9),
                  onPressed: () {
                    getImageFromUser(context, bodyState);
                  },
                  child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                ),
              ),
            )
          ],
        ),
      ),
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
  }
}
