import 'package:find_x/bottom_nav/home.dart';
import 'package:find_x/res/color_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'index_page.dart';
import 'login.dart';


void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'find x',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          useMaterial3: true,
          colorScheme: ColorProfile.light),
      darkTheme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          useMaterial3: true,
          colorScheme: ColorProfile.dark),
      themeMode: ThemeMode.system,
      home:  _loadingPage(),
    );
  }
  Widget _loadingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            // User is signed in, load the home page
            return IndexPage();
          } else {
            // User is not signed in, load the login page
            return Login();
          }
        } else {
          // Show a loading indicator while checking the authentication state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
