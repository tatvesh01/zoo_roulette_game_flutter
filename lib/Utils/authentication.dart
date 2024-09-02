import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoo_zimba/screens/wheel_screen.dart';

class Authentication {
  static customSnackBar({required String content}) {
    return Fluttertoast.showToast(
        msg: content,
        toastLength: Toast
            .LENGTH_LONG); /* SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    ) ;*/
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      /* Get.to(() => WheelSCREEN()); */
    }

    return firebaseApp;
  }

  static Future<User?> signInAnonymously() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final UserCredential userCredential = await auth.signInAnonymously();
    user = userCredential.user;
    return user;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        debugPrint('signInWithGoogle E: $e');
      }
    } else {
      // final GoogleSignIn googleSignIn = GoogleSignIn(clientId: '277754930218-201frau9m2v1jk1a3liptjvp54o0l7mv.apps.googleusercontent.com');
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            Authentication.customSnackBar(
              content: 'The account already exists with a different credential',
            );
            /*  ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content: 'The account already exists with a different credential',
              ),
            ); */
          } else if (e.code == 'invalid-credential') {
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            );
            /* ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content: 'Error occurred while accessing credentials. Try again.',
              ),
            ); */
          }
        } catch (e) {
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          );
          /*  ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          ); */
        }
      } else {
        /* Authentication.customSnackBar(
          content: 'No Record Found.',
        ); */
        /* ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'No Record Found.',
          ),
        ); */
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Authentication.customSnackBar(
        content: 'Error signing out. Try again.',
      );
      /* ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      ); */
    }
  }
}
