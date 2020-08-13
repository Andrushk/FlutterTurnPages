import 'package:flutter/material.dart';

class FrColors {
  // Верхняя часть фона
  static const Color bgTop = Color(0xFFffbe00);

  // Рамка вокруг фотографии профиля
  static const Color profileBorder = Color(0xFFffd353);

  // Стрелка в карточке скипаса
  static const Color skipassUpArrow = Color(0xFFec1b25);

  // Тень, отбрасываемая карточками
  static const Color cardShadow = Colors.black26;

  // Фон нижней части желтой карточки
  static const Color cardYellowBottom = Color(0xFFf8b900);

  // Фон иконки кол-ва товара в корзине
  static const Color bgCart = Color(0xFFe3001b);

  // По int-цвету услуги из БД возвращает Color, если в БД цвет - null, то
  // вернет дефолтный цвет
  static Color toServiceBgColor(int color) =>
      color != null ? Color(color) : Colors.grey;
}
