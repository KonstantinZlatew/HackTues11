import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackware/pages/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hackware/pages/login_page.dart';
import 'package:hackware/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  //maybe optional
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoSoil',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green.shade100,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'register' : (context) => RegisterPage(),
        'login' : (context) => LoginPage(),
      },
    );
  }
}
