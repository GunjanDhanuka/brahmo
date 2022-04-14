import 'package:brahmo/globals/myColors.dart';
import 'package:brahmo/pages/generateQR.dart';
import 'package:brahmo/pages/homeManagement.dart';
import 'package:brahmo/pages/login_page.dart';
import 'package:brahmo/pages/microsoft.dart';
import 'package:brahmo/pages/scanQR.dart';
import 'package:brahmo/pages/showScanDetails.dart';
import 'package:brahmo/pages/splash.dart';
import 'package:brahmo/pages/validate/approved.dart';
import 'package:brahmo/pages/validate/rejected.dart';
import 'package:brahmo/screens/auth/auth.dart';
import 'package:brahmo/screens/general/hmc_developers.dart';
import 'package:brahmo/screens/item_issue/item_confirm_screen.dart';
import 'package:brahmo/screens/main_screen.dart';
import 'package:brahmo/screens/user/home.dart';
import 'package:brahmo/screens/item_issue/item_selections.dart';
import 'package:brahmo/stores/login_store.dart';
import 'package:brahmo/stores/otp_login_store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //Initialize FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        //check for errors
        if (snapshot.hasError) {
          print('Something has gone wrong.');
        }

        //Once complete, show the application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<LoginStore>(
                create: (_) => LoginStore(),
              ),
              Provider<otpLoginStore>(
                create: (_) => otpLoginStore(),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: Color(0xff6BB156),
                  scaffoldBackgroundColor: Color(0xFFF7F6EE)),
              home: Splash(),
              routes: {
                ItemSelectionsScreen.id: (context) => ItemSelectionsScreen(),
                HmcAndDevelopersInfo.id: (context) => HmcAndDevelopersInfo(),
                AuthScreen.id: (context) => AuthScreen(),
                ItemConfirmScreen.id: (context) => ItemConfirmScreen(),
                MicrosoftLogin.id: (context) => MicrosoftLogin(),
                Splash.id: (context) => Splash(),
                HomeManagement.id: (context) => HomeManagement(),
                ScanQR.id: (context) => ScanQR(),
                QRGenerator.id: (context) => QRGenerator(),
                //StudentsList.id: (context) => StudentsList(),
                ShowScanDetails.id: (context) => ShowScanDetails(),
                Approved.id: (context) => Approved(),
                Rejected.id: (context) => Rejected(),
                LoginPage.id: (context) => LoginPage(),
                HomeScreen.id: (context) => HomeScreen(),
              },
            ),
          );
        }

        return MaterialApp(
          title: "Brahmo App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: Material(
            color: MyColors.white,
          ),
        );
      },
    );
  }
}

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xff6BB156),
//         scaffoldBackgroundColor: Color(0xFFF7F6EE)
//       ),
//       home: AuthScreen(),
//       routes: {
//         ItemSelectionsScreen.id : (context) => ItemSelectionsScreen(),
//         HmcAndDevelopersInfo.id : (context) => HmcAndDevelopersInfo(),
//         AuthScreen.id : (context) => AuthScreen(),
//         ItemConfirmScreen.id : (context) => ItemConfirmScreen(),
//       },
//     );
//   }
// }
