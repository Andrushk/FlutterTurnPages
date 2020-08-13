import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/style/colors.dart';
import 'package:flutter_turn_pages/common/style/size.dart';

mixin SimplePage<Page extends PageBase> on PageBaseState<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: FrSize.appBarBigHeight + FrSize.appBarBigOver,
            decoration: BoxDecoration(
              color: FrColors.bgTop,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          buildAppBar(context),
          buildBody(context),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) => Container();
  
  Widget buildBody(BuildContext context);

}
