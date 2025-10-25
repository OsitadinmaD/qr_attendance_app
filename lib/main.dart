import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance_app/firebase_options.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/login_screen/controller/login_controller.dart';
import 'package:qr_attendance_app/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(LoginController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Authentication App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          primary: const Color(0xFF0D47A1),
          onPrimary: const Color(0xFFFFFFFF),
          secondary: const Color.fromARGB(255, 233, 130, 46),
          onSecondary: const Color(0xFF000000),
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF212121),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4
          )
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        ),
        useMaterial3: true,
      ),
      home: SplashScreen()
    );
  }
}
