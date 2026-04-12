import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 건다 디자인 토큰
class GundaColors {
  static const bg      = Color(0xFF111111);
  static const card    = Color(0xFF1A1A1A);
  static const border  = Color(0xFF2A2A2A);
  static const white   = Color(0xFFFFFFFF);
  static const grey1   = Color(0xFFAAAAAA);
  static const grey2   = Color(0xFF888888);
  static const grey3   = Color(0xFF777777);
  static const grey4   = Color(0xFF666666);
  static const grey5   = Color(0xFF555555);
  static const grey6   = Color(0xFF444444);
  static const green   = Color(0xFF1D9E75); // 달성
  static const greenBg = Color(0xFF0F3D2E);
  static const red     = Color(0xFFE24B4A); // 위반
  static const redBg   = Color(0xFF3D1515);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: GundaColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: GundaColors.green,
        surface: GundaColors.card,
        onSurface: GundaColors.white,
        error: GundaColors.red,
        outline: GundaColors.border,
      ),

      // ── AppBar ───────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: GundaColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: GundaColors.white,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: GundaColors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // ── Card ─────────────────────────────────────────
      cardTheme: CardThemeData(
        color: GundaColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── FilledButton (흰 배경 + 검정 텍스트) ──────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GundaColors.white,
          foregroundColor: GundaColors.bg,
          disabledBackgroundColor: GundaColors.grey5,
          disabledForegroundColor: GundaColors.grey3,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── TextButton ───────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: GundaColors.grey3,
          textStyle: const TextStyle(fontSize: 13),
        ),
      ),

      // ── InputDecoration ──────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GundaColors.card,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: GundaColors.grey5, width: 1),
        ),
        hintStyle: const TextStyle(
            color: GundaColors.grey3, fontSize: 14),
        labelStyle: const TextStyle(
            color: GundaColors.grey3, fontSize: 12),
      ),

      // ── Chip ─────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: GundaColors.card,
        selectedColor: GundaColors.white,
        labelStyle: const TextStyle(
            color: GundaColors.grey2, fontSize: 12),
        side: const BorderSide(color: GundaColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 4),
      ),

      // ── Divider ──────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0xFF222222),
        thickness: 0.5,
        space: 0,
      ),

      // ── ListTile ─────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        iconColor: GundaColors.grey2,
        titleTextStyle: TextStyle(
            color: GundaColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500),
        subtitleTextStyle: TextStyle(
            color: GundaColors.grey3, fontSize: 12),
      ),

      // ── Slider ───────────────────────────────────────
      sliderTheme: const SliderThemeData(
        activeTrackColor: GundaColors.white,
        inactiveTrackColor: GundaColors.grey6,
        thumbColor: GundaColors.white,
        overlayColor: Colors.transparent,
        trackHeight: 3,
        thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 7),
      ),

      // ── Checkbox ─────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? GundaColors.green
                : GundaColors.card),
        checkColor:
            WidgetStateProperty.all(GundaColors.white),
        side: const BorderSide(color: GundaColors.grey5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)),
      ),

      // ── Radio ────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? GundaColors.white
                : GundaColors.grey5),
      ),

      // ── Text ─────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.5),
        headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.3),
        titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: GundaColors.white,
            letterSpacing: -0.3),
        titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: GundaColors.white),
        bodyLarge: TextStyle(
            fontSize: 14, color: GundaColors.white),
        bodyMedium: TextStyle(
            fontSize: 13, color: GundaColors.grey1),
        bodySmall: TextStyle(
            fontSize: 11, color: GundaColors.grey3),
        labelSmall: TextStyle(
            fontSize: 10,
            color: GundaColors.grey4,
            letterSpacing: 0.1),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: GundaColors.green,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF1C1B1F),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1C1B1F)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F3F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: GundaColors.green, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 13),
      ),
    );
  }
}
