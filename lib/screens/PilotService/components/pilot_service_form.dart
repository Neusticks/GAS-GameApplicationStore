import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/screens/PilotService/provider_models/game_details.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PilotServiceForm extends StatefulWidget {
  final PilotRequest pilot;
  const PilotServiceForm({
    Key key,
    this.pilot,
  }) : super(key: key);

  @override
  _PilotServiceFormState createState() => _PilotServiceFormState();
}

class _PilotServiceFormState extends State<PilotServiceForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController gameIdController =
      TextEditingController();

  
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  PilotRequest pilot;

  @override
  void initState(){
    super.initState();
    if(widget.pilot == null){
      pilot = PilotRequest(null);
    }
  }
  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildEmailOrIdGameAccountField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildAccountOwner(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildUserPhone(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildChooseGame(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Request Game Pilot",
            press: () {
              savePilotRequestButtonCallback(context);
            },
          ),
        ],
      ),
    );

    return form;
  }

  Widget buildEmailOrIdGameAccountField() {
    return TextFormField(
      controller: gameIdController,
      decoration: InputDecoration(
        hintText: "Enter Game Account Email or ID",
        labelText: "Game Account Display Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (gameIdController.text.isEmpty) {
          return "Email or ID cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAccountOwner() {
    return TextFormField(
      controller: userNameController,
      decoration: InputDecoration(
        hintText: "Enter Account Owner Name",
        labelText: "Game Account Owner Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (userNameController.text.isEmpty) {
          return "Owner Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
   Widget buildUserPhone() {
    return TextFormField(
      controller: userPhoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter User Phone Number",
        labelText: "User Phone Number To Contact",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (userPhoneController.text.isEmpty) {
          return "Phone Number cannot be empty";
        }else if (userPhoneController.text.length != 10) {
          return "Only 10 digits allowed";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      child: Consumer<GameDetails>(
        builder: (context, gameName, child) {
          return DropdownButton(
            value: gameName.gameName,
            items: GameList.values
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
              gameName.gameName = value;
            },
            elevation: 0,
            underline: SizedBox(width: 0, height: 0),
          );
        },
      ),
    );
  }
  Future<void> savePilotRequestButtonCallback(BuildContext context) async{
    final gameDetails = Provider.of<GameDetails>(context, listen: false);
    if(gameDetails.gameName == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select Requested Game"),
          ),
      );
      return;
    }
    String requestId;
    String snackbarMessage;
    try{
      pilot.gameId = gameIdController.text;
      pilot.userName = userNameController.text;
      pilot.userPhone = userPhoneController.text;
      pilot.gameName = gameDetails.gameName;
      final pilotUploadFuture =  PilotDatabaseHelper().addPilotRequest(pilot);
      pilotUploadFuture.then((value){
        requestId = value;
      });
      await showDialog(context: context, builder: (context){
        return FutureProgressDialog(
          pilotUploadFuture,
          message: Text("Making Pilot Request"),
        );
      },
      );
      if(requestId != null){
        snackbarMessage = "Pilot Request Successfully Made";
      }else{
        throw "Error in making Pilot Request";
      }
    }on FirebaseException catch(e){
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    }catch (e){
      Logger().w("Unknown Exception: $e");
      snackbarMessage = e.toString();
    }finally{
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackbarMessage),),);
    }
    Navigator.pop(context);
  }
}
