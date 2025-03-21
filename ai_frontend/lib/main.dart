import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/views/home_view.dart';
import 'package:ai_frontend/views/library_view.dart';
import 'package:ai_frontend/views/sign_in_view.dart';
import 'package:ai_frontend/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wyriugkvdczzcmyekles.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind5cml1Z2t2ZGN6emNteWVrbGVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NjkwMTEsImV4cCI6MjA1NTU0NTAxMX0.0qEVMgsn5Zbo2AQ1rrcMfY-FsWtMtldKOcGl3L2Zyew',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.submitButton),
        textTheme:
            GoogleFonts.interTextTheme(ThemeData.dark().textTheme.copyWith(
                  bodyMedium:
                      TextStyle(fontSize: 16, color: AppColors.whiteColor),
                )),
      ),
      home: SignUpView(),
      routes: {
        '/library': (context) => LibraryView(),
        '/signup': (context) => SignUpView(),
        '/signin': (context) => SignInView(),
        '/home': (context) => HomeView(),

      },
    );
  }
}
