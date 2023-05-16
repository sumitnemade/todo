import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class Themes {
  static ThemeData greenGrey() => ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.green,
          onPrimary: Colors.green,
          secondary: Colors.grey,
          onSecondary: Colors.grey,
          error: Colors.redAccent,
          onError: Colors.redAccent,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
            color: Colors.green,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            )),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            color: Colors.grey,
          ),
        ),
      );

  static ThemeData redWhite() => ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.red,
          onPrimary: Colors.red,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.redAccent,
          onError: Colors.redAccent,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.red,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            color: Colors.grey,
          ),
        ),
      );

  static ThemeData tealGray() => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Varela',
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.white,
          onPrimary: Colors.black,
          secondary: AppColors.background,
          onSecondary: AppColors.white,
          error: Colors.redAccent,
          onError: Colors.redAccent,
          background: Colors.white,
          onBackground: AppColors.background,
          surface: AppColors.background,
          onSurface: AppColors.white,
        ),
        // timePickerTheme: TimePickerThemeData(
        //   // Customize the font of the DatePicker
        //   // itemTextStyle: TextStyle(
        //   //   fontSize: 20,
        //   //   fontWeight: FontWeight.bold,
        //   // ),
        //   // Customize the color of the DatePicker
        //   // backgroundColor: AppColors.background,
        //   // Customize the shape of the DatePicker
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   // Customize the border of the DatePicker
        //   // border: Border.all(
        //   //   color: Colors.blue,
        //   //   width: 2,
        //   // ),
        // ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            iconTheme: IconThemeData(
              color: AppColors.white,
            ),
            titleTextStyle: TextStyle(
                fontFamily: 'Varela',
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            )),
        buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.normal,
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Colors.white,
              onPrimary: Colors.white,
              secondary: AppColors.white,
              onSecondary: AppColors.white,
              error: Colors.redAccent,
              onError: Colors.redAccent,
              background: Colors.black,
              onBackground: Colors.black,
              surface: AppColors.background,
              onSurface: AppColors.white,
            )),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Varela',
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Varela',
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.white,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.secondary,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.secondary,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.secondary,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.secondary,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.secondary,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Varela',
            color: AppColors.secondary,
          ),
        ),
      );
}
