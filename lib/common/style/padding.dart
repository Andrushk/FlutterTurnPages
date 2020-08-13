import 'package:flutter/material.dart';

class FrPadding {
  static const horizontalCardPadding = 28.0;
  static const verticalCardPadding = 15.0;

  /// Отступы для заголовков групп
  static const groupTitle =
  const EdgeInsets.symmetric(horizontal: horizontalCardPadding + 22.0);

  /// Отступы внутри карточек
  static const cardIn =
  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0);

  /// Отступы снаружи карточек
  static const cardOut = const EdgeInsets.symmetric(
      horizontal: horizontalCardPadding, vertical: verticalCardPadding);

  /// Отступы снаружи для второстепенных карточек
  static const cardSecondaryOut = const EdgeInsets.symmetric(
      horizontal: horizontalCardPadding - 8, vertical: verticalCardPadding);
}
