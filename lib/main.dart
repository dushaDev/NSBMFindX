import 'package:find_x/res/color_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase/fire_base_msg_service.dart';
import 'navigation_provider.dart';
import 'index_page.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMsgService().initNotifications();
  // FirebaseOptions firebaseOptions;
  // firebaseOptions = FirebaseOptions(
  //   apiKey: dotenv.env['FIREBASE_API_KEY']!,
  //   appId: dotenv.env['FIREBASE_APP_ID']!,
  //   messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
  //   projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
  // );
  // await Firebase.initializeApp(options: firebaseOptions);

  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
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
      home: _loadingPage(),
    );
  }

  Widget _loadingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            // User is signed in, load the home page after index page manage user's type (admin/student)
            return IndexPage();
          } else {
            // User is not signed in, load the login page true Splash screen
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

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('initializing..');
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
    print('initialization complete');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Required for background processing
  print("Handling a background message: ${message.messageId}");
  // You can process the message here, e.g., save to local storage
}
