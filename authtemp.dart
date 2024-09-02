import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:zoo_zimba/Utils/color_helper.dart';
import 'package:zoo_zimba/globles.dart';
// import 'package:zoo_zimba/screens/dashboard.dart';
import 'package:zoo_zimba/screens/wheel_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId = '';
  final SmsAutoFill _autoFill = SmsAutoFill();

  void verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
          Fluttertoast.showToast(
              msg: "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}", toastLength: Toast.LENGTH_SHORT);
        },
        verificationFailed: (FirebaseAuthException authException) {
          Fluttertoast.showToast(
              msg: "Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}",
              toastLength: Toast.LENGTH_SHORT);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Fluttertoast.showToast(msg: "Please check your phone for the verification code.", toastLength: Toast.LENGTH_SHORT);

          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(msg: "verification code: $verificationId", toastLength: Toast.LENGTH_SHORT);
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: $e");
    }
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      showSnackbar("Successfully signed in UID: ${user!.uid}");
    } catch (e) {
      showSnackbar("Failed to sign in: $e");
    }
  }

  void signInAnonymously() {
    _auth.signInAnonymously().then((result) {
      final User? user = result.user;
      debugPrint('USER: ${user.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: deviceWidth * 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 25),
              SingleChildScrollView(
                child: SizedBox(
                  height: deviceHeight * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: deviceWidth * 0.8,
                        child: TextFormField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[700],
                          ),
                          child: const Text("Get current number"),
                          onPressed: () async {
                            _phoneNumberController.text = await _autoFill.hint ?? "";
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[400],
                          ),
                          child: const Text("Verify Number"),
                          onPressed: () async {
                            verifyPhoneNumber();
                          },
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.8,
                        child: TextFormField(
                          controller: _smsController,
                          decoration: const InputDecoration(labelText: 'Verification code'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[200],
                          ),
                          child: const Text("Sign in"),
                          onPressed: () async {
                            signInWithPhoneNumber();
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent[200],
                            ),
                            onPressed: () async {
                              signInAnonymously();
                            },
                            child: const Text("Anon Sign in")),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // Get.to(() => DashBoardSCREEN());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 200,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              color: ColorHelper.primaryred,
                              child: const Text(
                                "Go to Dashboard",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 50),
                          InkWell(
                            onTap: () {
                              Get.to(() => WheelSCREEN(), arguments: ["player1"]);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 200,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              color: ColorHelper.primaryred,
                              child: const Text(
                                "Go to Player1",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 50),
                          InkWell(
                            onTap: () {
                              Get.to(() => WheelSCREEN(), arguments: ["player2"]);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 200,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              color: ColorHelper.primaryred,
                              child: const Text(
                                "Go to Player2",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void showSnackbar(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}
