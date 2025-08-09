import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 应用主题配置
class AppTheme {
  // 主色调
  static const Color primaryColor = Color(0xFF5E8B7E);
  static const Color secondaryColor = Color(0xFFA7C4BC);
  static const Color accentColor = Color(0xFF2F5D62);
  
  // 背景色
  static const Color backgroundColor = Color(0xFFF2F5F5);
  static const Color cardColor = Colors.white;
  
  // 文本颜色
  static const Color textPrimaryColor = Color(0xFF2D3E40);
  static const Color textSecondaryColor = Color(0xFF6D8A96);
  static const Color textLightColor = Color(0xFF9EAEB3);
  
  // 情绪颜色
  static const Color moodTerribleColor = Color(0xFFE57373);
  static const Color moodBadColor = Color(0xFFFFB74D);
  static const Color moodNeutralColor = Color(0xFFFFD54F);
  static const Color moodGoodColor = Color(0xFFAED581);
  static const Color moodExcellentColor = Color(0xFF81C784);
  
  // 圆角
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  
  // 间距
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;
  
  // 阴影
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  // 获取应用主题
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: cardColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: GoogleFonts.notoSansTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSans(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.notoSans(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.notoSans(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.notoSans(
          color: textPrimaryColor,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.notoSans(
          color: textPrimaryColor,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.notoSans(
          color: textSecondaryColor,
          fontSize: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        hintStyle: GoogleFonts.notoSans(
          color: textLightColor,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryColor.withOpacity(0.2),
        labelStyle: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicatorColor: primaryColor,
        labelStyle: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.notoSans(
          fontSize: 14,
        ),
      ),
    );
  }
  
  // 获取情绪对应的颜色
  static Color getMoodColor(int moodValue) {
    switch (moodValue) {
      case 1:
        return moodTerribleColor;
      case 2:
        return moodBadColor;
      case 3:
        return moodNeutralColor;
      case 4:
        return moodGoodColor;
      case 5:
        return moodExcellentColor;
      default:
        return moodNeutralColor;
    }
  }
}
