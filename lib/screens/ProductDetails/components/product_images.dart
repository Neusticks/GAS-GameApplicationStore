// import 'package:flutter/material.dart';
// import 'package:gas_gameappstore/models/Product.dart';

// import '../../../constants.dart';
// import '../../../size_config.dart';

// class ProductImages extends StatefulWidget {
//   const ProductImages({
//     Key key,
//     @required this.product,
//   }) : super(key: key);

//   final Product product;

//   @override
//   _ProductImagesState createState() => _ProductImagesState();
// }

// class _ProductImagesState extends State<ProductImages> {
//   int selectedImage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: getProportionScreenWidth(238),
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Hero(
//               tag: widget.product.id.toString(),
//               child: Image.asset(widget.product.productImages[selectedImage]),
//             ),
//           ),
//         ),
//         // SizedBox(height: getProportionateScreenWidth(20)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ...List.generate(widget.product.productImages.length,
//                 (index) => buildSmallProductPreview(index)),
//           ],
//         )
//       ],
//     );
//   }

//   GestureDetector buildSmallProductPreview(int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedImage = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: defaultDuration,
//         margin: EdgeInsets.only(right: 15),
//         padding: EdgeInsets.all(8),
//         height: getProportionScreenWidth(48),
//         width: getProportionScreenWidth(48),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
//         ),
//         child: Image.asset(widget.product.productImages[index]),
//       ),
//     );
//   }
// }
import 'package:gas_gameappstore/screens/ProductDetails/provider_models/images_swiper.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatelessWidget {
  const ProductImages({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductImageSwiper(),
      child: Consumer<ProductImageSwiper>(
        builder: (context, productImagesSwiper, child) {
          return Column(
            children: [
              SwipeDetector(
                onSwipeLeft: () {
                  productImagesSwiper.currentImageIndex++;
                  productImagesSwiper.currentImageIndex %=
                      product.productImages.length;
                },
                onSwipeRight: () {
                  productImagesSwiper.currentImageIndex--;
                  productImagesSwiper.currentImageIndex +=
                      product.productImages.length;
                  productImagesSwiper.currentImageIndex %=
                      product.productImages.length;
                },
                child: PinchZoomImage(
                  image: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: SizedBox(
                      height: SizeConfig.screenHeight * 0.35,
                      width: SizeConfig.screenWidth * 0.75,
                      child: Image.network(
                        product.productImages[productImagesSwiper.currentImageIndex],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    product.productImages.length,
                    (index) =>
                        buildSmallPreview(productImagesSwiper, index: index),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSmallPreview(ProductImageSwiper productImagesSwiper,
      {@required int index}) {
    return GestureDetector(
      onTap: () {
        productImagesSwiper.currentImageIndex = index;
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionScreenWidth(8)),
        padding: EdgeInsets.all(getProportionScreenHeight(8)),
        height: getProportionScreenWidth(48),
        width: getProportionScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: productImagesSwiper.currentImageIndex == index
                  ? kPrimaryColor
                  : Colors.transparent),
        ),
        child: Image.network(product.productImages[index]),
      ),
    );
  }
}
