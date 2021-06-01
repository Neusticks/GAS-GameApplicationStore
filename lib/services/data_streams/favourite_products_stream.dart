
import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';

class FavouriteProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final favProductsFuture = UserDatabaseHelper().usersFavouriteProductsList;
    favProductsFuture.then((favProducts) {
      addData(favProducts.cast<String>());
    }).catchError((e) {
      addError(e);
    });
  }
}
