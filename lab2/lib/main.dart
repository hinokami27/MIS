
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab1/firebase_options.dart';
import 'package:lab1/services/notification_service.dart';
import 'package:lab1/services/favorites_service.dart';
import 'screens/main_screen.dart';

final NotificationService notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await notificationService.initNotifications();
  await notificationService.requestPermissions();

  await notificationService.scheduleDailyRecipeNotification();

  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesService(),
      child: const MealRecipeApp(),
    ),
  );
}

class MealRecipeApp extends StatelessWidget {
  const MealRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}