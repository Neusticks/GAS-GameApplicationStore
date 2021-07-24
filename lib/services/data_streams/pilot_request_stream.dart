import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';

class PilotRequestStream extends DataStream<List<String>> {
  @override
  void reload() {
    final requestList = PilotDatabaseHelper().notFinishRequestList;
    requestList.then((pilot) {
      addData(pilot);
    }).catchError((e) {
      addError(e);
    });
  }
}