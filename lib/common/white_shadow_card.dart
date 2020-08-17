import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/common/style/colors.dart';
import 'package:flutter_turn_pages/common/style/padding.dart';
import 'package:flutter_turn_pages/common/style/size.dart';

/// Обертка виджета в виде Белой карточки с тенью
class WhiteShadowCard extends StatelessWidget {
  final Widget child;

  const WhiteShadowCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
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
    );
  }
}