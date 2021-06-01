import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';

class CartItemStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = UserDatabaseHelper().allCartItemsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}