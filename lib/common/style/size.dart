import 'package:flutter/material.dart';

class FrSize {
  /// Высота большого AppBar и "Заползание" AppBar под элементы списка
  static const double appBarBigHeight = 195;
  static const double appBarBigOver = 160;

  /// Высота большого AppBar и "Заползание" AppBar под элементы списка
  static const double appBarSmallHeight = 100;
  static const double appBarSmallOver = 60;

  /// Y - координата кнопок в AppBar
  static const double appBarButtonsTop = 54;

  /// Радиус скругления краев у карточек
  static const double cardRadiusValue = 15.0;
  static const BorderRadius cardRadius =
  const BorderRadius.all(Radius.circular(cardRadiusValue));
}
