import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class QuietHoursApp extends StatelessWidget {
  const QuietHoursApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.hindSiliguriTextTheme();
    const brand = Color(0xFF146C94);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.light,
    );

    return GetMaterialApp(
      title: 'Quiet Hours',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
        visualDensity: VisualDensity.standard,
        textTheme: baseTextTheme.apply(
          bodyColor: const Color(0xFF1A3A4D),
          displayColor: const Color(0xFF0D2B3A),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: false,
          titleTextStyle: baseTextTheme.titleLarge?.copyWith(
            color: const Color(0xFF0D2B3A),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return baseTextTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              );
            }
            return baseTextTheme.labelMedium;
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(size: 26);
            }
            return const IconThemeData(size: 24);
          }),
          indicatorColor: colorScheme.primaryContainer.withValues(alpha: 0.85),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          focusElevation: 6,
          hoverElevation: 6,
          highlightElevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: baseTextTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: colorScheme.primaryContainer.withValues(alpha: 0.75),
          disabledColor: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          surfaceTintColor: Colors.transparent,
          shadowColor: const Color(0xFF0D2B3A).withValues(alpha: 0.12),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6B8A9E),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: brand, width: 2),
          ),
        ),
      ),
    );
  }
}
