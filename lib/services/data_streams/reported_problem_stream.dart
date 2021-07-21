import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';

class ReportedProblemStream extends DataStream<List<String>>{
  @override
  void reload(){
    final reportList = ReportDatabaseHelper().allProblemReport;
    reportList.then((report){
      addData(report);
    }).catchError((e) {
      addError(e);
    });
  }
}