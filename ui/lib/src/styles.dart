import 'dart:ui';

class Colors {
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  static const gray50 = Color(0xFFF2F2F2);
  // static const gray100 = Color(0xFFE6E6E6);
  static const gray200 = Color(0xFFCCCCCC);
  // static const gray300 = Color(0xFFB3B3B3);
  // static const gray400 = Color(0xFF999999);
  static const gray500 = Color(0xFF808080);
  // static const gray600 = Color(0xFF666666);
  // static const gray700 = Color(0xFF4D4D4D);
  static const gray800 = Color(0xFF333333);
  // static const gray900 = Color(0xFF1A1A1A);

  static void printGrays() {
    void printGray(int i) {
      final color = Color.lerp(white, black, (i - 2) / 1000)!;
      final hex = color.value.toRadixString(16).toUpperCase();
      // ignore: avoid_print
      print('static const gray$i = Color(0x$hex);');
    }

    printGray(50);
    for (var i = 100; i <= 900; i += 100) {
      printGray(i);
    }
  }
}

class Spacing {
  static const extraSmall = 8.0;
  static const small = 12.0;
  static const medium = 16.0;
  // static const large = 24.0;
  static const extraLarge = 32.0;
}

class FontSize {
  // static const extraSmall = 12.0;
  static const small = 14.0;
  static const medium = 16.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
}

class IconSize {
  // static const extraSmall = 16.0;
  static const small = 20.0;
  static const medium = 24.0;
  // static const large = 32.0;
  // static const extraLarge = 40.0;
}

class Radius {
  // static const extraSmall = 4.0;
  // static const small = 6.0;
  static const medium = 8.0;
  // static const large = 12.0;
  // static const extraLarge = 16.0;
}
