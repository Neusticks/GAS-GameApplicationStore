import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';

class UsersStream extends DataStream<List<String>> {
  @override
  void reload() {
    final userList = UserDatabaseHelper().allUsersList;
    userList.then((user) {
      addData(user);
    }).catchError((e) {
      addError(e);
    });
  }
}