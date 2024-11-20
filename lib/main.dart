import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_app/provider/theme_provider.dart';
import 'package:video_player_app/provider/video_provider.dart';
import 'package:video_player_app/view/home_page.dart';
import 'package:video_player_app/view/splash_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).isDark
            ? Provider.of<ThemeProvider>(context).darkTheme
            : Provider.of<ThemeProvider>(context).lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
