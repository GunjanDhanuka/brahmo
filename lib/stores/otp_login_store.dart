import 'package:brahmo/screens/admin/scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brahmo/pages/login_page.dart';
import 'package:brahmo/pages/scanQR.dart';
import 'package:mobx/mobx.dart';
import 'package:brahmo/pages/homeManagement.dart';
import 'package:brahmo/pages/microsoft.dart';
import 'package:brahmo/pages/otp_page.dart';

part 'otp_login_store.g.dart';

class otpLoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String actualCode;
  String enteredContact;
  @observable
  bool isLoginLoading = false;
  @observable
  bool isOtpLoading = false;

  @observable
  GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  User firebaseUser;
  final _firestore = FirebaseFirestore.instance;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = await _auth.currentUser;
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<void> getCodeWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    isLoginLoading = true;
    enteredContact = phoneNumber;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential auth) async {
          //add phone number check
          bool response = await checkPhoneFirebase(enteredContact);
          if (response == false) {
            print('\n\n\nNOT FOUND\n\n\n');
            // loginScaffoldKey.currentState.showSnackBar(SnackBar(
            //   behavior: SnackBarBehavior.floating,
            //   backgroundColor: Colors.red,
            //   content: Text(
            //     'This number does not exist in the database of mess managers.',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ));
            Fluttertoast.showToast(
                msg: 'You are not a registered Admin User.');
            isLoginLoading = false;
            isOtpLoading = false;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => MicrosoftLogin()),
                    (Route<dynamic> route) => false);
            return;
          }
          await _auth.signInWithCredential(auth).then((UserCredential value) {
            if (value != null && value.user != null) {
              print('Authentication successful');
              onAuthenticationSuccessful(context, value);
            } else {
              loginScaffoldKey.currentState.showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(
                  'Invalid code/invalid authentication',
                  style: TextStyle(color: Colors.white),
                ),
              ));
            }
          }).catchError((error) {
            loginScaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'Something has gone wrong, please try later',
                style: TextStyle(color: Colors.white),
              ),
            ));
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print('Error message: ' + authException.message);
          loginScaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
              style: TextStyle(color: Colors.white),
            ),
          ));
          // Fluttertoast.showToast(msg: 'You are not a registered Mess Manager.');
          isLoginLoading = false;
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          actualCode = verificationId;
          isLoginLoading = false;
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const OtpPage()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        });
  }

  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    isOtpLoading = true;
    final AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);
    bool response = await checkPhoneFirebase(enteredContact);
    print(response.toString() + "gd");
    if (response == false) {
      print('\n\n\nNOT FOUND\n\n\n');
      // loginScaffoldKey.currentState.showSnackBar(SnackBar(
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.red,
      //   content: Text(
      //     'This number does not exist in the database of mess managers.',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ));
      Fluttertoast.showToast(msg: 'You are not a registered Admin User.');
      isLoginLoading = false;
      isOtpLoading = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => MicrosoftLogin()),
              (Route<dynamic> route) => false);
      return;
    }
    //verify phone number
    await _auth.signInWithCredential(_authCredential).catchError((error) {
      print(error);
      isOtpLoading = false;
      otpScaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          'Wrong code ! Please enter the last code received.',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }).then((UserCredential authResult) {
      if (authResult != null && authResult.user != null) {
        print('Authentication successful');
        onAuthenticationSuccessful(context, authResult);
      }
    });
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, UserCredential result) async {
    isLoginLoading = true;
    isOtpLoading = true;

    firebaseUser = result.user;
    print('\n\n\nReached auth success\n\n\n');
    print(result.user.phoneNumber);

    if (await checkPhoneFirebase(firebaseUser.phoneNumber)) {
      print('\n\n\nFound number\n\n\n');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => ScannerScreen()),
              (Route<dynamic> route) => false);
    } else {
      print('\n\n\nNOT FOUND\n\n\n');
      // loginScaffoldKey.currentState.showSnackBar(SnackBar(
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.red,
      //   content: Text(
      //     'This number does not exist in the database of mess managers.',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ));
      Fluttertoast.showToast(msg: 'You are not a registered Admin User.');
      isLoginLoading = false;
      isOtpLoading = false;
      Navigator.pop(context);
      Navigator.pushNamed(context, LoginPage.id);
    }

    isLoginLoading = false;
    isOtpLoading = false;
  }

  //TODO: Create a doc in firestore for storing the phone numbers of admin users
  Future<bool> checkPhoneFirebase(String phoneNumber) async {
    print('\n\n\nChecking in data');
    QuerySnapshot querySnapshot =
    await _firestore.collection('admin').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      print(phoneNumber);
      print(doc.get('phone').toString());
      if (phoneNumber == doc.get('phone').toString())
        return true;
    }
    return false;
  }

  @action
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MicrosoftLogin()),
            (Route<dynamic> route) => false);
    firebaseUser = null;
  }
}