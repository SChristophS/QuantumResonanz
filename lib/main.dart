import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'services/language_service.dart';
import 'services/onboarding_service.dart';
import 'state/app_state.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/quantum_resonanz_screen.dart';

void main() {
  runApp(const QuantumResonanzApp());
}

class QuantumResonanzApp extends StatelessWidget {
  const QuantumResonanzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuantumResonanzController()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
      ],
      child: Consumer<LanguageService>(
        builder: (context, languageService, _) {
          return MaterialApp(
            title: 'QuantumResonanz',
            debugShowCheckedModeBanner: false,
            theme: _buildDarkTheme(),
            locale: languageService.locale,
            supportedLocales: const [
              Locale('de'),
              Locale('en'),
              Locale('zh', 'CN'),
              Locale('es'),
              Locale('ja'),
              Locale('fr'),
              Locale('pt', 'BR'),
              Locale('ko'),
              Locale('it'),
              Locale('ru'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const _AppRoot(),
          );
        },
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

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late Future<bool> _onboardingFuture;
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    _onboardingFuture = _onboardingService.hasCompletedOnboarding();
  }

  void _completeOnboarding() {
    setState(() {
      _onboardingFuture = Future.value(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _onboardingFuture,
      builder: (context, snapshot) {
        final completed = snapshot.data ?? false;
        if (!completed) {
          return OnboardingScreen(
            onFinished: _completeOnboarding,
          );
        }
        return const QuantumResonanzScreen();
      },
    );
  }
}


