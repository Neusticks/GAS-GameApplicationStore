import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/screens/CategoryProduct/category_product_screen.dart';
import 'package:gas_gameappstore/screens/Home/components/product_type_box.dart';
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
import 'product_section.dart';
import 'special_offers.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class Body extends StatefulWidget {
   @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FavouriteProductsStream favouriteProductsStream =
      FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();
  final productCategories = <Map>[
    <String, dynamic>{
      ICON_KEY: "assets/icons/coins.svg",
      TITLE_KEY: "InGame Currency",
      PRODUCT_TYPE_KEY: ProductType.InGameCurrency,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/games.svg",
      TITLE_KEY: "Gaming Accessories",
      PRODUCT_TYPE_KEY: ProductType.GamingAccessories,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Electronics.svg",
      TITLE_KEY: "Electronics",
      PRODUCT_TYPE_KEY: ProductType.Electronics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/lightsaber.svg",
      TITLE_KEY: "Game Cosmetics",
      PRODUCT_TYPE_KEY: ProductType.GameCosmetics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Others",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];

  void initState(){
    super.initState();
    favouriteProductsStream.init();
    allProductsStream.init();
  }

  @override
  Widget build(BuildContext context) {

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
                SizedBox(height: getProportionScreenWidth(5)),
                NewsBanner(),
                SizedBox(height: getProportionScreenHeight(5)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: [
                        ...List.generate(
                          productCategories.length,
                              (index) {
                            return ProductTypeBox(
                              icon: productCategories[index][ICON_KEY],
                              title: productCategories[index][TITLE_KEY],
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryProductsScreen(
                                          productType: productCategories[index]
                                          [PRODUCT_TYPE_KEY],
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getProportionScreenHeight(10)),

                // Categories(),
                // RoundedButton(
                //     text: "Add Product",
                //     press: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => EditProductScreen(),
                //           ));
                //     }),
                // SizedBox(height: SizeConfig.screenHeight * 0.03),
                // SpecialOffers(),
                SizedBox(height: getProportionScreenWidth(20)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.5,
                  child: ProductSection(
                    sectionTitle: "Products You Like",
                    productsStreamController: favouriteProductsStream,
                    emptyListMessage: "Add Product to Favourites",
                    onProductCardTapped: onProductCardTapped,
                  ),
                ),
                SizedBox(height: getProportionScreenHeight(20)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  child: ProductSection(
                    sectionTitle: "Explore All Products",
                    productsStreamController: allProductsStream,
                    emptyListMessage: "There is No Product in the Stores",
                    onProductCardTapped: onProductCardTapped,
                  ),
                ),
                SizedBox(height: getProportionScreenHeight(80)),
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