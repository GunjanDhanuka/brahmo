import 'dart:async';

import 'package:flutter/material.dart';
import 'package:brahmo/globals/myColors.dart';
import 'package:brahmo/globals/myFonts.dart';
import 'package:brahmo/globals/mySpaces.dart';
import 'package:brahmo/pages/generateQR.dart';
import 'package:brahmo/pages/homeManagement.dart';
import 'package:brahmo/pages/scanQR.dart';
import 'package:brahmo/stores/otp_login_store.dart';
import 'package:provider/provider.dart';
import 'package:brahmo/stores/login_store.dart';
import 'package:brahmo/pages/microsoft.dart';

class Splash extends StatefulWidget {
  static String id = 'splash';

  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    //check if the user is already signed in
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeManagement()),
                (Route<dynamic> route) => false);
      } else {
        //if not signed-in, redirect to login screen
        Provider.of<otpLoginStore>(context, listen: false)
            .isAlreadyAuthenticated()
            .then((result2) {
          if (result2) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => ScanQR()),
                    (Route<dynamic> route) => false);
          } else {
            print("WORKS");
            //if not signed-in, redirect to login screen
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => MicrosoftLogin()),
                    (Route<dynamic> route) => false);
          }
        });
      }
    });
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeManagement()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.black,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/icons/swc.png'),
                height: 250,
                width: 250,
              ),
              MySpaces.vMediumGapInBetween,
              MyFonts().largeTitle("IITG Scanner", MyColors.white),
              MySpaces.hSmallGapInBetween,
              MyFonts()
                  .heading2('Scan id-cards anytime, anywhere!', MyColors.white)
            ],
          ),
        ),
      ),
    );
  }
}