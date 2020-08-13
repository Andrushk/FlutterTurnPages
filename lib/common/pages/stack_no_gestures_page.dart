import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/style/colors.dart';
import 'package:flutter_turn_pages/common/style/padding.dart';
import 'package:flutter_turn_pages/common/style/size.dart';

mixin StackNoGesturesPage<Page extends PageBase> on PageBaseState<Page> {
  int pageIndex = 0;

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
          buildAppBar(),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (widget, animation){
              return ScaleTransition(scale: animation, child: widget,);
            },
            child: IndexedStack(
              key: Key('$pageIndex'),
              children: pages.map((p) => cardWrap(p)).toList(),
              index: pageIndex,
            ),
          ),
          GestureDetector(
            onHorizontalDragStart: (details){},
            onHorizontalDragUpdate: (details) {
              print(
                  'delta=${details.delta}, local=${details.localPosition}, global=${details.globalPosition}');
            },
          )
        ],
      ),
    );
  }

  Widget buildAppBar() => Container();

  List<Widget> get pages => [];

  Widget cardWrap(Widget content) {
    return Padding(
      child: Container(
        child: content,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: FrPadding.verticalCardPadding,
              color: FrColors.cardShadow,
            ),
          ],
          borderRadius: FrSize.cardRadius,
        ),
      ),
      padding: const EdgeInsets.only(
        left: FrPadding.horizontalCardPadding,
        right: FrPadding.horizontalCardPadding,
        top: FrPadding.verticalCardPadding + 100,
        bottom: FrPadding.verticalCardPadding + 10,
      ),
    );
  }

  moveLeft() {
    if (pageIndex <= 0) return;
    setState(() {
      pageIndex--;
    });
  }

  moveRight(){
    if (pageIndex >= pages.length-1) return;
    setState(() {
      pageIndex++;
    });
  }
}
