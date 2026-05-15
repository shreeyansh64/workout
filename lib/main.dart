import 'package:fitness_tracker_app/core/constants.dart';
import 'package:fitness_tracker_app/providers/onboarding/onboarding_provider.dart';
import 'package:fitness_tracker_app/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sh = await SharedPreferences.getInstance();
  final skipOnboarding = sh.getBool(hasSeenOnboarding);
  runApp(ProviderScope(overrides: [
    onboardingCompletedProvider.overrideWithValue(skipOnboarding ?? false),
  ], child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final seenOnboaring = ref.read(onboardingCompletedProvider);
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF00BFA5),
          surface: Color(0xFF141414),
          onSurface: Colors.white,
          onPrimary: Color(0xFF0A0A0A),
          tertiary: Color(0xFF64FFDA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        cardTheme: CardThemeData(
          color: const Color(0xFF141414),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
                color: Color(0xFF00E5FF).withOpacity(0.12), width: 1),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Color(0xFF00E5FF),
          unselectedLabelColor: Colors.white38,
          indicatorColor: Color(0xFF00E5FF),
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00E5FF),
          foregroundColor: Color(0xFF0A0A0A),
          elevation: 0,
          shape: CircleBorder(),
        ),
      ),
      home:  seenOnboaring ? WorkoutListScreen() : OnboardingScreen(),
    );
  }
}
