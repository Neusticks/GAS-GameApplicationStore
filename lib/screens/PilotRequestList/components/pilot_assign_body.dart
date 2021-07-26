
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';

import 'package:gas_gameappstore/screens/PilotRequestListDetails/pilot_request_details_screen.dart';
import 'package:gas_gameappstore/services/data_streams/assign_request_stream.dart';

import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'assign_pilot_short_detail_card.dart';

class AssignBody extends StatefulWidget{
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<AssignBody>{
  final AssignPilotRequestStream assignPilotRequestStream = AssignPilotRequestStream();
  List assignpilots;

  @override
  void initState() {
    super.initState();
    assignPilotRequestStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    assignPilotRequestStream.dispose();
  }

  Future<void> refreshPage() {
    assignPilotRequestStream.reload();
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
                      child: buildRequestList(),
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
  Widget buildRequestList() {
    return StreamBuilder<List<String>>(
      stream: assignPilotRequestStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> assignId = snapshot.data;

          return Column(
            children: [
              SizedBox(height: getProportionScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: assignId.length,
                  itemBuilder: (context, index) {
                    if (index >= assignId.length) {
                      return SizedBox(height: getProportionScreenHeight(80));
                    }
                    return buildPilotCard(
                        context,  assignId[index], index);
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

  Widget buildUsers(String requestId, int index) {
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
      child: FutureBuilder<PilotRequest>(
        future: PilotDatabaseHelper().getRequestWithID(requestId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PilotRequest pilot = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: AssignPilotShortDetailCard(
                    requestId: pilot.id,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PilotRequestDetailsScreen(requestId: requestId),),);
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

  Widget buildPilotCard(
      BuildContext context, String requestId, int index) {
    return Container(
      key: Key(requestId),
      child: buildUsers(requestId, index),
    );
  }
}