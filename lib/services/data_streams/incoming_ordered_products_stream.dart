import 'package:gas_gameappstore/services/data_streams/data_stream.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

class IncomingOrderedProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final incomingOrderedProductsFuture = StoreDatabaseHelper().incomingOrderedProduct;
    incomingOrderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}