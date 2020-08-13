import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/style/colors.dart';
import 'package:flutter_turn_pages/common/style/padding.dart';
import 'package:flutter_turn_pages/common/style/size.dart';

mixin TurnPages<Page extends PageBase> on PageBaseState<Page> {
  final controller = PageController();
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_pageViewListener);
  }

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
          Column(
            children: [
              //buildAppBar(),
              Expanded(
                child: PageView.builder(
                  itemBuilder: (context, idx) {
                    final angle = idx-currentPageValue;
                    //print('angle=$angle');
                    final w = buildPage(pages[idx]);
                    if (idx == currentPageValue.floor()) {
                      return Transform(
                        alignment: Alignment.bottomLeft,
                        transform: Matrix4.identity()
                          ..rotateZ(angle),
                        child: w,
                      );
                    } else if (idx == currentPageValue.floor() + 1) {
                      //return buildPage(pages[idx]);
                      return Opacity(opacity: 1-angle, child: w);
                      return Transform(
                        transform: Matrix4.identity()
                          ..rotateZ(angle*2),
                        child:w,
                      );
                    } else {
                      return buildPage(pages[idx]);
                    }
                  },
                  controller: controller,
                  itemCount: pages.length,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_pageViewListener);
    super.dispose();
  }

  Widget buildPage(Widget content) {
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
        top: FrPadding.verticalCardPadding+100,
        bottom: FrPadding.verticalCardPadding + 10,
      ),
    );
  }

  Widget buildAppBar() => Container();

  List<Widget> get pages => [];

  void _pageViewListener() {
    setState(() {
      currentPageValue = controller.page;
    });
  }
}
