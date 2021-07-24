import 'package:gas_gameappstore/screens/ChangeStoreAddress/components/change_store_address_form.dart';
import 'package:gas_gameappstore/screens/ChangeStoreDescription/components/change_store_desc_form.dart';
import 'package:gas_gameappstore/screens/ChangeStoreName/components/change_store_name_form.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionScreenWidth(screenPadding)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Text(
              "Change Store Description",
              style: headingStyle,
            ),
            ChangeStoreDescForm(),
          ],
        ),
      ),
    );
  }
}