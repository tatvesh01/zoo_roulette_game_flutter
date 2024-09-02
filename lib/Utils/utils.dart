import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_helper.dart';

class Utils {
  Widget loader() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          ColorHelper.primaryred,
        ),
      ),
    );
  }

  static circularIndicator(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: ColorHelper.black.withOpacity(0.5),
      child: const SizedBox(
          height: 35,
          width: 35,
          child: Center(
              child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorHelper.primaryred,
            ),
          ))),
    );
  }

  static TextStyle loginSignUpHeadingStyle = const TextStyle(color: ColorHelper.primaryred, fontSize: 30, fontWeight: FontWeight.w900);

  static TextStyle headingStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: ColorHelper.primaryred,
    fontSize: 25,
    //fontFamily: "Verda",
  );

  static TextStyle titleStyleRed = const TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.primaryred,
    fontSize: 18,
    //fontFamily: "Verda",
  );
  static TextStyle titleStyleBlack = const TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.black,
    fontSize: 18,
    //fontFamily: "Verda",
  );
  static TextStyle text1StyleGrey = const TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.lightGray2,
    fontSize: 16,
    //fontFamily: "Verda",
  );
  static TextStyle text1StyleDarkGrey = TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.light_gray,
    fontSize: 18,
    //fontFamily: "Verda",
  );
  static TextStyle text2StyleDarkGrey = TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.light_gray,
    fontSize: 14,
    //fontFamily: "Verda",
  );
  static TextStyle text3StyleDarkGrey = TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.light_gray,
    fontSize: 15,
    //fontFamily: "Verda",
  );
  static TextStyle text3StyleDarkBlue = const TextStyle(
    fontWeight: FontWeight.w600,
    color: ColorHelper.darkBlue,
    fontSize: 13,
    //fontFamily: "Verda",
  );
  static TextStyle text1StyleWhite = const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: 14,
    //fontFamily: "Verda",
  );
  static TextStyle btnTextStyleWhite = const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: 20,
    //fontFamily: "Verda",
  );
  static TextStyle text2StyleWhite = const TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: 16,
    //fontFamily: "Verda",
  );

  static snackBarOnSuccess(String subTitle, {String title = 'Message', Color colors = ColorHelper.primaryred, IconData iconName = Icons.check}) {
    return Get.snackbar(title, subTitle,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorHelper.primaryred,
        icon: Icon(
          iconName,
          color: Colors.white,
        ),
        borderRadius: 5,
        colorText: Colors.white);
  }

  static snackBar(String subTitle, {String title = 'Error', Color colors = Colors.white, IconData iconName = Icons.error_outline}) {
    return Get.snackbar(title, subTitle,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: colors,
        icon: Icon(
          iconName,
          color: Colors.white,
        ),
        borderRadius: 5,
        colorText: Colors.white);
  }

  static RxBool isPermission = false.obs;

  static Future<bool> waitTwoSecond(int second) {
    return Future.delayed(Duration(seconds: second), () {
      return true;
    });
  }
}
