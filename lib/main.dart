import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:real_time_watchlist/core/routes/app_routes.dart';
import 'package:real_time_watchlist/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
