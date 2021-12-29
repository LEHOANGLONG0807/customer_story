import 'package:flutter/material.dart';
import '../common/common.dart';

import 'theme.dart';

class StoryWordThemeData {
  static final InputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(100),
  );
  static final InputBorder _focusInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(100),
  );
  static final themeData = ThemeData(
    colorScheme: _colorScheme,
    primaryColor: const Color(0xFFFFAC40),
    // primarySwatch: MaterialColor(0xFFFFAC40, const {
    //   50: const Color(0xFFFFF4E3),
    //   100: const Color(0xFFFFE2B8),
    //   200: const Color(0xFFFFCF8B),
    //   300: const Color(0xFFFFBB5E),
    //   400: const Color(0xFFFFAC40),
    //   500: const Color(0xFFFE9F2F),
    //   600: const Color(0xFFFA932C),
    //   700: const Color(0xFFF38429),
    //   800: const Color(0xFFEC7526),
    //   900: const Color(0xFFE25D20)
    // }),
//    fontFamily: GoogleFonts.poppins().fontFamily,
    accentColor: _colorScheme.primary,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: _colorScheme.onBackground),
      textTheme: _textTheme,
      elevation: 0,
      color: Colors.white,
    ),
    canvasColor: _colorScheme.background,
    toggleableActiveColor: _colorScheme.primary,
    indicatorColor: _colorScheme.onPrimary,
    bottomAppBarColor: Colors.white,
    scaffoldBackgroundColor: _colorScheme.background,
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),

    textTheme: _textTheme,
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: const Color(0xffBFBFBF),
      labelStyle: _textTheme.subtitle1,
      unselectedLabelStyle: _textTheme.subtitle1,
    ),
    // input
    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 2,
      helperMaxLines: 2,
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      hintStyle: _textTheme.caption!.text595959,
      focusedBorder: _focusInputBorder,
      border: _inputBorder,
      enabledBorder: _inputBorder,
      errorBorder: _inputBorder.copyWith(
          borderSide: BorderSide(
        color: _colorScheme.error,
      )),
      focusedErrorBorder: _inputBorder.copyWith(
        borderSide: BorderSide(
          color: _colorScheme.error,
        ),
      ),
      disabledBorder: _inputBorder,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 14.0,
      ),
    ),

    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 20,
      shadowColor: Colors.black.withOpacity(0.1),
      color: Colors.white,
    ),

    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        minimumSize: Size(76.0, 56.0),
        primary: AssetColors.primary,
        onPrimary: Colors.white,
        onSurface: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(76.0, 56.0),
        side: BorderSide(width: 1.5, color: _colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
  );

  static const _regular = FontWeight.w400;
  // static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static const _colorScheme = ColorScheme(
    primary: const Color(0xFFFFAC40),
    primaryVariant: const Color(0xFFE25D20),
    secondary: const Color(0xFFFFCF8B),
    secondaryVariant: Color(0xFFC77D02),
    background: Colors.white,
    onBackground: Colors.black,
    surface: const Color(0xFFBFBFBF),
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    brightness: Brightness.light,
  );

  static final TextTheme _textTheme = TextTheme(
    headline4: TextStyle(fontWeight: _bold, fontSize: 34.0, height: 41.0 / 34.0),
    headline5: TextStyle(fontWeight: _bold, fontSize: 24.0, height: 32.0 / 24.0),
    headline6: TextStyle(fontWeight: _bold, fontSize: 20.0, height: 28.0 / 20.0, color: Colors.black),
    subtitle1: TextStyle(fontWeight: _bold, fontSize: 15.0, height: 24.0 / 15.0),
    subtitle2: TextStyle(fontWeight: _semiBold, fontSize: 13.0, height: 20.0 / 13.0),
    bodyText1: TextStyle(fontWeight: _regular, fontSize: 15.0, height: 20.0 / 15.0),
    bodyText2: TextStyle(fontWeight: _regular, fontSize: 13.0, height: 20.0 / 13.0),
    button: TextStyle(fontWeight: _semiBold, fontSize: 13.0, height: 20.0 / 13.0),
    caption: TextStyle(fontWeight: _regular, fontSize: 12.0, height: 20.0 / 12.0),
    overline: TextStyle(fontWeight: _regular, fontSize: 10.0, height: 18.0 / 10.0),
  );
}
