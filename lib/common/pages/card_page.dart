import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/style/colors.dart';
import 'package:flutter_turn_pages/common/style/padding.dart';
import 'package:flutter_turn_pages/common/style/size.dart';

/// Страница у который почти во весь размер нарисована карточка,
/// а снизу может быть здоровая кнопка
mixin CardPage<Page extends PageBase> on PageBaseState<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: FrSize.appBarBigHeight + FrSize.appBarBigOver,
            decoration: BoxDecoration(
              color: FrColors.bgTop,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          Column(
            children: <Widget>[
              buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: FrPadding.horizontalCardPadding,
                    right: FrPadding.horizontalCardPadding,
                    top: FrPadding.verticalCardPadding,
                    bottom: FrPadding.verticalCardPadding + 10,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(child: buildBody(context)),
                        Container(), // это кнопка снизу
                      ],
                    ),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() => Container();

  Widget buildBody(BuildContext context);
}
