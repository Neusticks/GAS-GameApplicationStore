import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';

class StoreOrderedStream extends DataStream<List<String>> {
  @override
  void reload() {
    final storeOrderedFuture = UserDatabaseHelper().orderedProductListForSeller;
    storeOrderedFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}