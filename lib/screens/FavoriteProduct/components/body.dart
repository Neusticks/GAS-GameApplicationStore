import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/screens/ProductDetails/product_details_screen.dart';
import 'package:gas_gameappstore/services/data_streams/favourite_products_stream.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'FavProductShortDetailCard.dart';

class Body extends StatefulWidget{
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body>{
  final FavouriteProductsStream favouriteProductsStream = FavouriteProductsStream();
  List<bool> checked = [true];

  @override
  void initState(){
    super.initState();
    favouriteProductsStream.init();
  }

  @override
  void dispose(){
    super.dispose();
    favouriteProductsStream.dispose();
  }

  Future<void> refreshPage(){
    favouriteProductsStream.reload();
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionScreenHeight(10)),
                  Text(
                    "Your Favorite Product",
                    style: headingStyle,
                  ),
                  SizedBox(height: getProportionScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: Center(
                      child: buildFavoriteProductItemsList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFavoriteProductItemsList(){
    return StreamBuilder<List<String>>(
      stream: favouriteProductsStream.stream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<String> itemsFavProduct = snapshot.data;

          if (itemsFavProduct.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "You have no favorite product!",
              ),
            );
          }

          return Column(
            children: [
              SizedBox(height: getProportionScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: itemsFavProduct.length,
                  itemBuilder: (context, index) {
                    if (index >= itemsFavProduct.length) {
                      return SizedBox(height: getProportionScreenHeight(80));
                    }
                    return buildFavoriteProductItemDismissible(
                        context, itemsFavProduct[index], index);
                  },
                ),
              ),
            ],
          );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(snapshot.hasError){
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildFavoriteProductItemDismissible(BuildContext context, String favProductItemId, int index){
    return Dismissible(
      key: Key(favProductItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: buildFavoriteProductItem(favProductItemId, index),
      onDismissed: (direction) {},
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFavoriteProductItem(String favProductItemId, int index){
    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.85)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(favProductItemId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: FavProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }
}