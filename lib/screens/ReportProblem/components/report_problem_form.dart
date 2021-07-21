import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/models/ReportedProblem.dart';
import 'package:gas_gameappstore/models/ReportedUser.dart';
import 'package:gas_gameappstore/screens/PilotService/provider_models/game_details.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ReportProblemForm extends StatefulWidget {
  final ReportedProblem report;
  const ReportProblemForm({
    Key key,
    this.report,
  }) : super(key: key);

  @override
  _ReportProblemFormState createState() => _ReportProblemFormState();
}

class _ReportProblemFormState extends State<ReportProblemForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userNameReportedController = TextEditingController();
  final TextEditingController reportedDescriptionController = TextEditingController();
  ReportedProblem report = ReportedProblem();

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionScreenHeight(30)),
          buildUserNameField(),
          SizedBox(height: getProportionScreenHeight(30)),
          buildReportDescField(),
          SizedBox(height: getProportionScreenHeight(30)),
          DefaultButton(
            text: "Report Problem",
            press: () {
              saveReportButtonCallback(context);
            },
          ),
        ],
      ),
    );

    return form;
  }

  Widget buildUserNameField() {
    return TextFormField(
      controller: userNameReportedController,
      decoration: InputDecoration(
        hintText: "Enter Your Username",
        labelText: "Your Username",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (userNameReportedController.text.isEmpty) {
          return "Username cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildReportDescField() {
    return TextFormField(
      controller: reportedDescriptionController,
      minLines: 1,
      maxLines: 7,
      decoration: InputDecoration(
        hintText: "Enter what you want to report",
        labelText: "Report Description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.announcement),
      ),
      validator: (value) {
        if (reportedDescriptionController.text.isEmpty) {
          return "Report Description cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveReportButtonCallback(BuildContext context) async{
    String reportId;
    String snackbarMessage;
    try{
      final dateTime = DateTime.now();
      final formatedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      report.userName = userNameReportedController.text;
      report.problemDescription = reportedDescriptionController.text;
      report.reportedDate = formatedDateTime;
      final reportUploadFuture =  ReportDatabaseHelper().addProblemReport(report);
      reportUploadFuture.then((value){
        reportId = value;
      });
      await showDialog(context: context, builder: (context){
        return FutureProgressDialog(
          reportUploadFuture,
          message: Text("Making Problem Report"),
        );
      },
      );
      if(reportId != null){
        snackbarMessage = "Problem Report Successfully Made";
      }else{
        throw "Error in making Problem Report";
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
