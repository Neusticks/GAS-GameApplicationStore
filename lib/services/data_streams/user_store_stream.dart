import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

class UsersStoreStream extends DataStream<List<String>> {
  @override
  void reload() {
    final usersStoreFuture = StoreDatabaseHelper().userStoreWithId;
    usersStoreFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
