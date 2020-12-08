import 'package:flutter/material.dart';

import 'hexcolor.dart';

class GlobalColor {
  GlobalColor._();

  // Colors
  static MaterialColor colorPrimary = MaterialColor(0xFF3368A9, color);

  static Map<int, Color> color = {
    50: Color.fromRGBO(107, 217, 175, .1),
    100: Color.fromRGBO(107, 217, 175, .2),
    200: Color.fromRGBO(107, 217, 175, .3),
    300: Color.fromRGBO(107, 217, 175, .4),
    400: Color.fromRGBO(107, 217, 175, .5),
    500: Color.fromRGBO(107, 217, 175, .6),
    600: Color.fromRGBO(107, 217, 175, .7),
    700: Color.fromRGBO(107, 217, 175, .8),
    800: Color.fromRGBO(107, 217, 175, .9),
    900: Color.fromRGBO(107, 217, 175, 1),
  };

  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color blue = HexToColor.hexToColor("#007FFF");

  static Color grey = HexToColor.hexToColor("#A2A2A2");
  static Color semiGrey = HexToColor.hexToColor("#00000073");
  static Color lightGrey = HexToColor.hexToColor("#8E8E8E");

  static Color darkGrey = HexToColor.hexToColor("#9A9A9A");

  static Color dotGrey = HexToColor.hexToColor("#D6D6D6");

  static Color orange = HexToColor.hexToColor("#F29900");
  static Color red = HexToColor.hexToColor("#DB001E");
  static Color yellow = HexToColor.hexToColor("#DBA100");

  static Color green = HexToColor.hexToColor("#00DB3A");
  static Color pink = HexToColor.hexToColor("#FF5858");
  static Color peach = HexToColor.hexToColor("#FF8B67");
}
