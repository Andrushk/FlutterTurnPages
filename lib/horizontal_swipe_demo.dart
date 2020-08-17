import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/pages/simple_page.dart';
import 'package:flutter_turn_pages/common/style/padding.dart';
import 'package:flutter_turn_pages/common/swipe_stack.dart';
import 'package:flutter_turn_pages/common/white_shadow_card.dart';
import 'package:flutter_turn_pages/page1.dart';
import 'package:flutter_turn_pages/page2.dart';
import 'package:flutter_turn_pages/page3.dart';

class HorizontalSwipe extends PageBase {
  @override
  _HorizontalSwipeState createState() => _HorizontalSwipeState();
}

class _HorizontalSwipeState extends PageBaseState<HorizontalSwipe>
    with SimplePage {
  @override
  Widget buildAppBar(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [BackButton()],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: FrPadding.horizontalCardPadding,
        right: FrPadding.horizontalCardPadding,
        top: FrPadding.verticalCardPadding + 100,
        bottom: FrPadding.verticalCardPadding + 10,
      ),
      child: SwipeStack(
        children: [
          wrapPage(Page1()),
          wrapPage(Page2()),
          wrapPage(Page3()),
        ],
        bottomPage: bottomPage(),
      ),
    );
  }

  //bottom: 15.0
  Widget wrapPage(Widget page) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: WhiteShadowCard(child: page),
      );

  Widget bottomPage() => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Transform.rotate(
          child: WhiteShadowCard(child: Container()),
          angle: -.05,
        ),
      );
}
