import 'package:flutter/material.dart';

import 'package:comic_creator/core/globals/my_colors.dart';

class Pallete {
  static const Map<int, Color> primaryColor = {
    50: Color.fromRGBO(35, 40, 107, .1),
    100: Color.fromRGBO(35, 40, 107, .2),
    200: Color.fromRGBO(35, 40, 107, .3),
    300: Color.fromRGBO(35, 40, 107, .4),
    400: Color.fromRGBO(35, 40, 107, .5),
    500: Color.fromRGBO(35, 40, 107, .6),
    600: Color.fromRGBO(35, 40, 107, .7),
    700: Color.fromRGBO(35, 40, 107, .8),
    800: Color.fromRGBO(35, 40, 107, .9),
    900: Color.fromRGBO(35, 40, 107, 1),
  };

  // defining the theme of the app
  static ThemeData getAppTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      canvasColor: const Color.fromRGBO(25, 25, 25, 1),
      dividerColor: const Color.fromARGB(255, 48, 48, 48),
      textTheme: Theme.of(context)
          .textTheme
          .copyWith(
            titleSmall:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 11),
          )
          .apply(
            bodyColor: Colors.white,
            displayColor: Colors.grey,
          ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Colors.orange),
      ),
      listTileTheme: const ListTileThemeData(iconColor: Colors.orange),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(17, 17, 17, 1),
        foregroundColor: textColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      dialogBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
    );
  }
}
