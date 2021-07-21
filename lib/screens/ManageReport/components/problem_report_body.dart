
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/models/ReportedProblem.dart';
import 'package:gas_gameappstore/screens/ManagePilotRequest/components/request_pilot_short_detail_card.dart';
import 'package:gas_gameappstore/screens/ManageReport/components/problem_report_short_detail_card.dart';
import 'package:gas_gameappstore/screens/PilotRequestDetails/pilot_request_details_screen.dart';
import 'package:gas_gameappstore/screens/ReportProblemDetail/report_problem_detail_screen.dart';
import 'package:gas_gameappstore/services/data_streams/reported_problem_stream.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProblemReportBody extends StatefulWidget{
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<ProblemReportBody>{
  final ReportedProblemStream problemStream = ReportedProblemStream();
  List problem;

  @override
  void initState() {
    super.initState();
    problemStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    problemStream.dispose();
  }

  Future<void> refreshPage() {
    problemStream.reload();
    return Future<void>.value();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: Center(
                      child: buildProblemList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildProblemList() {
    return StreamBuilder<List<String>>(
      stream: problemStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> reportId = snapshot.data;

          return Column(
            children: [
              SizedBox(height: getProportionScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: reportId.length,
                  itemBuilder: (context, index) {
                    if (index >= reportId.length) {
                      return SizedBox(height: getProportionScreenHeight(80));
                    }
                    return buildReportCard(
                        context, reportId[index], index);
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildReports(String reportId, int index) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 10,
        top: 10,
        right: 10,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<ReportedProblem>(
        future: ReportDatabaseHelper().getReportProblemWithId(reportId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ReportedProblem report = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: ProblemReportShortDetail(
                    reportId: report.id,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportProblemDetailScreen(reportId : reportId),),);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildReportCard(
      BuildContext context, String reportId, int index) {
    return Container(
      key: Key(reportId),
      child: buildReports(reportId, index),
    );
  }
}