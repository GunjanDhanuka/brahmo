import 'package:brahmo/screens/auth/auth.dart';
import 'package:brahmo/screens/general/hmc_developers.dart';
import 'package:brahmo/screens/item_issue/item_confirm_screen.dart';
import 'package:brahmo/screens/main_screen.dart';
import 'package:brahmo/screens/user/home.dart';
import 'package:brahmo/screens/item_issue/item_selections.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff6BB156),
        scaffoldBackgroundColor: Color(0xFFF7F6EE)
      ),
      home: AuthScreen(),
      routes: {
        ItemSearchScreen.id : (context) => ItemSearchScreen(),
        HmcAndDevelopersInfo.id : (context) => HmcAndDevelopersInfo(),
        AuthScreen.id : (context) => AuthScreen(),
        ItemConfirmScreen.id : (context) => ItemConfirmScreen(),
      },
    );
  }
}
