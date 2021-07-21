import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/ReportedUser.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';
import 'package:logger/logger.dart';
import '../../../size_config.dart';

class ReportUserForm extends StatefulWidget {
  final ReportedUser report;
  const ReportUserForm({
    Key key,
    this.report,
  }) : super(key: key);

  @override
  _ReportUserFormState createState() => _ReportUserFormState();
}

class _ReportUserFormState extends State<ReportUserForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userNameReportedController = TextEditingController();
  final TextEditingController reportedUserNameController = TextEditingController();
  final TextEditingController reportedDescriptionController = TextEditingController();
  ReportedUser report = ReportedUser();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    userNameReportedController.dispose();
    reportedDescriptionController.dispose();
    reportedUserNameController.dispose();
    super.dispose();
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
          buildReportedUserField(),
          SizedBox(height: getProportionScreenHeight(30)),
          buildReportDescField(),
          SizedBox(height: getProportionScreenHeight(30)),
          DefaultButton(
            text: "Report User",
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

  Widget buildReportedUserField() {
    return TextFormField(
      controller: reportedUserNameController,
      decoration: InputDecoration(
        hintText: "Enter Reported Username",
        labelText: "Username that you want to report",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (reportedUserNameController.text.isEmpty) {
          return "Reported Username cannot be empty";
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
      report.userName = userNameReportedController.text;
      report.reportedUser = reportedUserNameController.text;
      report.problemDescription = reportedDescriptionController.text;
      final dateTime = DateTime.now();
      final formatedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      report.reportedDate = formatedDateTime;
      final reportUploadFuture =  ReportDatabaseHelper().addUserReport(report);
      reportUploadFuture.then((value){
        reportId = value;
      });
      await showDialog(context: context, builder: (context){
        return FutureProgressDialog(
          reportUploadFuture,
          message: Text("Making User Report"),
        );
      },
      );
      if(reportId != null){
        snackbarMessage = "User Report Successfully Made";
      }else{
        throw "Error in making User Report";
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
