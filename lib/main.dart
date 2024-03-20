import 'package:db/db/database.dart';
import 'package:db/screens/home.dart';
import 'package:db/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF87CEEB),
  brightness: Brightness.light,
);
final darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF87CEEB),
  brightness: Brightness.dark,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Provider<AppDatabase>(
      create: (context) => AppDatabase(),
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          print("Current Theme : ${isDarkMode()}");
          print("Color scheme: ${isDarkMode() ? darkDynamic : lightDynamic}");
          return MaterialApp(
            theme: ThemeData(
              colorScheme: isDarkMode()
                  ? darkDynamic ?? darkColorScheme
                  : lightDynamic ?? lightColorScheme,
            ),
            home: const MyApp(),
          );
        },
      ),
      dispose: (context, db) => db.close(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static String title = 'Notes SQLite';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
