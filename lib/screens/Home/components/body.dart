import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/SearchResult/search_result_screen.dart';
import 'package:gas_gameappstore/services/data_streams/all_products_stream.dart';
import 'package:gas_gameappstore/services/data_streams/favourite_products_stream.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/screens/ProductDetails/product_details_screen.dart';
import 'package:logger/logger.dart';
import 'categories.dart';
import 'home_header.dart';
import 'news_banner.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {
   @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FavouriteProductsStream favouriteProductsStream =
      FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();

  void initState(){
    super.initState();
    favouriteProductsStream.init();
    allProductsStream.init();
  }

  @override
  Widget build(BuildContext context) {
    var favouriteProductsStream;

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionScreenHeight(20)),
                HomeHeader(
                  onSearchSubmitted: (value) async{
                    final query = value.toString();
                    if (query.length <= 0) return;
                    List<String> searchedProductsId;
                    try{
                      searchedProductsId = await ProductDatabaseHelper().searchInProducts(query.toLowerCase());
                      if (searchedProductsId != null){
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultScreen(searchQuery: query, searchResultProductsId: searchedProductsId, searchIn: "All Products",
                        ),
                        ),
                        );
                        await refreshPage();
                      }else {
                        throw "Couldn't Perform Search due to some unknown reason";
                      }
                    }catch (e){
                      final error = e.toString();
                      Logger().e(error);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$error"),
                      ),
                      );
                    }
                  },
                ),
                SizedBox(height: getProportionScreenWidth(10)),
                NewsBanner(),
                Categories(),
                // RoundedButton(
                //     text: "Add Product",
                //     press: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => EditProductScreen(),
                //           ));
                //     }),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SpecialOffers(),
                SizedBox(height: getProportionScreenWidth(30)),
                // PopularProducts(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  child: PopularProducts(
                    sectionTitle: "Products You Like",
                    productsStreamController: allProductsStream,
                    emptyListMessage: "Add Product to Favourites",
                    onProductCardTapped: onProductCardTapped,
                  ),
                )
          ],

        ),
      ),
    );
  }

  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }
}