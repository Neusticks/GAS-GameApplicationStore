import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';

class ReportedUserStream extends DataStream<List<String>>{
  @override
  void reload(){
    final reportList = ReportDatabaseHelper().allUserReport;
    reportList.then((report){
      addData(report);
    }).catchError((e) {
      addError(e);
    });
  }
}