import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'ui/screens/quantum_resonanz_screen.dart';

void main() {
  runApp(const QuantumResonanzApp());
}

class QuantumResonanzApp extends StatelessWidget {
  const QuantumResonanzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuantumResonanzController(),
      child: MaterialApp(
        title: 'QuantumResonanz',
        debugShowCheckedModeBanner: false,
        theme: _buildDarkTheme(),
        home: const QuantumResonanzScreen(),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const primaryColor = Color(0xFF29E0FF); // Neon-Cyan
    const secondaryColor = Color(0xFFB968FF); // Neon-Violett
    const backgroundColor = Color(0xFF050712);

    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: const Color(0xFF0C0F1E),
        onSurface: Colors.white,
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB0B5D0),
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Color(0xFFCCD0EA),
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          shadowColor: primaryColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}


