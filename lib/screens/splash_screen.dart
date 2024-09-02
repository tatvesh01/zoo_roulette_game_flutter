import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zoo_zimba/Utils/color_helper.dart';
import 'package:zoo_zimba/controllers/aw_dialog_controller.dart';
import 'package:zoo_zimba/controllers/splash_screen_controller.dart';
import '../generated/assets.dart';
import '../globles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'wheel_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreenController splashController = Get.put(SplashScreenController());
  CommonDialogController commonDialogController = Get.put(CommonDialogController());

  SplashScreen({Key? key}) : super(key: key);
  double itemSpacing = 10;

  @override
  Widget build(BuildContext context) {
    isTablet = context.mediaQueryShortestSide > 510;
    deviceShortestSide = context.mediaQueryShortestSide;
    debugPrint('DEVICESHORTESTSIDE: $deviceShortestSide');
    debugPrint('context.size: ${MediaQuery.of(context).size}');
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    itemSpacing = MediaQuery.of(context).size.height * 0.02;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: Image.asset(
              Assets.iconsSplashimg,
              fit: BoxFit.fill,
            ),
          ),
          refAndEarnBtnClickBOx(),
          loginBtnClickBOx(context),



          Obx(() => playasgueststatusData.value ? SizedBox() : addMoney(context)),
          Obx(() => playasgueststatusData.value ? SizedBox() : withdrawMoney(context)),
          Obx(() => playasgueststatusData.value ? SizedBox() : supportWid()),
          Obx(() => commonDialogController.isloggedIn.value ? userProfileWid() : const SizedBox()),
          Obx(() => commonDialogController.addMoneyDialog(context, itemSpacing)),
          Obx(() => commonDialogController.recordsDialog(context)),
          Obx(() => splashController.forceUpdateDialog(context)),
          // Obx(() => commonDialogController.loader.value ? darkLayerWid() : const SizedBox()),
        ],
      ),
    );
  }

  /* Widget darkLayerWid() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.3),
      ),
      width: deviceWidth,
      height: deviceHeight,
      child: Lottie.asset(
        Assets.lottieJsonsLoading,
        height: deviceHeight * 0.30,
        width: deviceHeight * 0.30,
        fit: BoxFit.fitWidth,
      ),
    );
  } */
  
  Widget refAndEarnBtnClickBOx() {
    return Positioned(
      bottom: deviceHeight * 0.019,
      left: 0,
      child: InkWell(
        onTap: () {
          Share.share('check out this application And Get ₹50 bonus https://play.google.com/store/apps/details?id=$packageName');
        },
        child: SizedBox(
          /* decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ), */
          width: deviceWidth * 0.20,
          child: Image.asset(
            Assets.iconsRefrearn,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget loginBtnClickBOx(BuildContext context) {
    return Positioned(
      bottom: deviceHeight * 0.13,
      right: deviceWidth * 0.053,
      child: Column(
        children: [

            Obx(()=>playasgueststatusData.value?Column(
              children: [
                ...playAsGuestWid()
              ],
            ):SizedBox()),

          InkWell(
            onTap: () {
              /* commonDialogController.loader(true); */
              // Get.to(() => WheelSCREEN(), arguments: ["player1"]);
              if (commonDialogController.isloggedIn.value) {
                Get.to(() => WheelSCREEN(), arguments: [commonDialogController.playerId.value]);
              } else {
                signInWithGoogle(context).then((value) {
                  commonDialogController.stremCloseMethod();
                  commonDialogController.initilizeMethod();
                });
              }
              /* Future.delayed(const Duration(seconds: 2), () {
                commonDialogController.loader(false);
              }); */
            },
            child: SizedBox(
              /*  decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ), */
              width: deviceWidth * 0.23,
              child: Image.asset(
                Assets.iconsLoginBtn,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(height: deviceHeight * 0.05),
          Obx(() => playasgueststatusData.value ? SizedBox() : cmnFonts("There is financial risk in this game, \nso play carefully."),),
          SizedBox(height: deviceHeight * 0.03),
          Row(
            children: [
              ppAndTCWid(
                'Privacy Policy',
                onTap: () {
                  Get.to(
                    () => const WebViewApp(
                      url: "https://www.privacypolicies.com/live/a27342c2-ee31-4284-a121-8834abd3b99f",
                    ),
                  );
                },
              ),
              SizedBox(width: deviceWidth * 0.01),
              ppAndTCWid(
                'Terms & Condition',
                onTap: () {
                  Get.to(
                    () => const WebViewApp(
                      url: "https://www.privacypolicies.com/live/c707211c-8d88-4e8e-906b-b9e8ed09486d",
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* Widget loginBtnClickBOx(BuildContext context) {
    return Positioned(
      bottom: deviceHeight * 0.20,
      right: deviceWidth * 0.053,
      child: Obx(
        () => Column(
          children: [
            ...playAsGuestWid(),
            InkWell(
              onTap: () {
                /* commonDialogController.loader(true); */
                // Get.to(() => WheelSCREEN(), arguments: ["player1"]);
                if (commonDialogController.isloggedIn.value && !commonDialogController.isAnonymous.value) {
                  Get.to(() => WheelSCREEN(), arguments: [commonDialogController.playerId.value]);
                } else {
                  signInWithGoogle(context).then((value) {
                    commonDialogController.stremCloseMethod();
                    commonDialogController.initilizeMethod();
                  });
                }
                /* Future.delayed(const Duration(seconds: 2), () {
                  commonDialogController.loader(false);
                }); */
              },
              child: SizedBox(
                /*  decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ), */
                width: deviceWidth * 0.23,
                child: Image.asset(
                  Assets.iconsLoginBtn,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.05),
            cmnFonts("There is financial risk in this game, \nso play carefully."),
            SizedBox(height: deviceHeight * 0.03),
            Row(
              children: [
                ppAndTCWid(
                  'Privacy Policy',
                  onTap: () {
                    Get.to(
                      () => const WebViewApp(
                        url: "https://sites.google.com/view/zoorouletteprivacypolicy/",
                      ),
                    );
                  },
                ),
                SizedBox(width: deviceWidth * 0.01),
                ppAndTCWid(
                  'Terms & Condition',
                  onTap: () {
                    Get.to(
                      () => const WebViewApp(
                        url: "https://sites.google.com/view/zooroulettetermsandservice/",
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> playAsGuestWid() {
    debugPrint('playAsGuestWid ${commonDialogController.isAnonymous.value || localDataStorage.read(isAnonymousKey) == null}');
    debugPrint('playAsGuestWid 1 ${localDataStorage.read(isAnonymousKey) == null}');
    debugPrint('playAsGuestWid 2 ${commonDialogController.isAnonymous.value}');
    return (commonDialogController.isAnonymous.value || localDataStorage.read(isAnonymousKey) == null)
        ? [
            InkWell(
              onTap: () {
                if (commonDialogController.isloggedIn.value) {
                  Get.to(() => WheelSCREEN(), arguments: [commonDialogController.playerId.value]);
                } else {
                  signInWithGuest().then((value) {
                    commonDialogController.stremCloseMethod();
                    commonDialogController.initilizeMethod();
                  });
                }
              },
              child: const Text.rich(
                TextSpan(
                  style: TextStyle(color: ColorHelper.white, fontSize: 20, fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Play As Guest",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    // can add more TextSpans here...
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "OR",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorHelper.white, fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10)
          ]
        : [];
  }
*/


  List<Widget> playAsGuestWid() {
    debugPrint('playAsGuestWid ${commonDialogController.isAnonymous.value || localDataStorage.read(isAnonymousKey) == null}');
    debugPrint('playAsGuestWid 1 ${localDataStorage.read(isAnonymousKey) == null}');
    debugPrint('playAsGuestWid 2 ${commonDialogController.isAnonymous.value}');
    return (commonDialogController.isAnonymous.value || localDataStorage.read(isAnonymousKey) == null)
        ? [
      InkWell(
        onTap: () {
          if (commonDialogController.isloggedIn.value) {
            Get.to(() => WheelSCREEN(), arguments: [commonDialogController.playerId.value]);
          } else {
            signInWithGuest().then((value) {
              commonDialogController.stremCloseMethod();
              commonDialogController.initilizeMethod();
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
          decoration: BoxDecoration(color: Color(0xff48BE13),
            border: Border.all(color: Colors.white,width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: const Text.rich(
            TextSpan(
              style: TextStyle(color: ColorHelper.white, fontSize: 20, fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: "Play As Guest",
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                    //decoration: TextDecoration.underline,
                  ),
                ),
                // can add more TextSpans here...
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        "OR",
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorHelper.white, fontSize: 16, fontWeight: FontWeight.w400),
      ),
      const SizedBox(height: 10)
    ]
        : [];
  }


  Widget cmnFonts(
    String data,
  ) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style: const TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.w400),
    );
  } 

  Widget ppAndTCWid(String text, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          style: const TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.w400),
          children: <TextSpan>[
            TextSpan(
              text: text,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            // can add more TextSpans here...
          ],
        ),
      ),
    );
  }

  Widget addMoney(BuildContext context) {
    return Positioned(
      bottom: deviceHeight * 0.019,
      left: 250,
      child: InkWell(
        onTap: () {
          if (commonDialogController.isloggedIn.value) {
            commonDialogController.addMoneyWithDrawdialogAlign(!commonDialogController.addMoneyWithDrawdialogAlign.value);
            commonDialogController.selectedOptionInDialog(0);
          } else {
            signInWithGoogle(context).then((value) {
              commonDialogController.stremCloseMethod();
              commonDialogController.initilizeMethod();
            });
          }
        },
        child: SizedBox(
          height: deviceHeight * 0.18,
          width: deviceHeight * 0.18,
          child: Image.asset(
            Assets.imagesAddmony,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget withdrawMoney(BuildContext context) {
    return Positioned(
      bottom: deviceHeight * 0.019,
      left: 350,
      child: InkWell(
        onTap: () {
          if (commonDialogController.isloggedIn.value) {
            commonDialogController.addMoneyWithDrawdialogAlign(!commonDialogController.addMoneyWithDrawdialogAlign.value);
            commonDialogController.selectedOptionInDialog(1);
          } else {
            signInWithGoogle(context).then((value) {
              commonDialogController.stremCloseMethod();
              commonDialogController.initilizeMethod();
            });
          }
        },
        child: SizedBox(
          height: deviceHeight * 0.18,
          width: deviceHeight * 0.18,
          child: Image.asset(
            Assets.imagesWithdraw,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget supportWid() {
    return Positioned(
      bottom: deviceHeight * 0.019,
      left: 450,
      child: InkWell(
        onTap: () async {
          /*  Get.to(() => AdminSCREEN()); */
          String email = Uri.encodeComponent("charlyray1997@gmail.com");
          Uri mail = Uri.parse("mailto:$email");
          if (await launchUrl(mail)) {
            //email app opened
            debugPrint('email app opened:');
          } else {
            //email app is not opened
            debugPrint('email app is not opened:');
          }
        },
        child: SizedBox(
          height: deviceHeight * 0.18,
          width: deviceHeight * 0.18,
          child: Image.asset(
            Assets.imagesSupport,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget userProfileWid() {
    return Positioned(
      top: 0,
      right: -deviceWidth * 0.005,
      child: Container(
        alignment: Alignment.center,
        height: deviceHeight * 0.22,
        width: deviceWidth * 0.25,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: deviceWidth * 0.25,
                child: Image.asset(
                  Assets.iconsProfileSpl,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            /* Padding(
              padding: EdgeInsets.only(left: deviceWidth * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Guest12313132",
                    style: TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Balance: 500",
                    style: TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ) */
            /* Positioned(
              right: deviceWidth * 0.023,
              top: deviceHeight * 0.075,
              child: ,
            ) */
            Container(
              width: deviceWidth * 0.25,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: deviceWidth * 0.10, right: deviceWidth * 0.02),
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    commonDialogController.playerName.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  Text(
                    "Balance: ${commonDialogController.userBalance.value}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*  Widget addMoneyDialog(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom * 0.65,
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.4),
          ),
          margin: EdgeInsets.all(splashController.addMoneyWithDrawdialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: splashController.addMoneyWithDrawdialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(splashController.addMoneyWithDrawdialogAlign.value ? 0 : deviceHeight * 0.80),
            duration: const Duration(milliseconds: 200),
            height: deviceHeight * 0.88,
            width: deviceWidth * 0.75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * 0.86,
                  width: deviceWidth * 0.75,
                  child: Image.asset(
                    Assets.iconsDialogBg,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 2.5,
                  top: 5,
                  child: SizedBox(
                    height: deviceHeight * 0.85,
                    width: deviceWidth,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: deviceHeight * 0.045,
                          right: deviceHeight * 0.045,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: deviceWidth * 0.54,
                                height: deviceHeight * 0.15,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: deviceHeight * 0.15,
                                      width: deviceWidth * 0.3,
                                      child: Image.asset(
                                        splashController.selectedOptionInDialog.value == 0
                                            ? Assets.iconsAddMoneyDialogText
                                            : Assets.iconsWithdrawDialogText,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(width: deviceWidth * 0.02),
                                    Container(
                                      height: deviceHeight * 0.09,
                                      width: deviceWidth * 0.16,
                                      alignment: Alignment.center,
                                      // margin: const EdgeInsets.only(bottom: 10),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: deviceHeight * 0.09,
                                            width: deviceWidth * 0.16,
                                            child: Image.asset(
                                              Assets.iconsYourBalanceBg,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          Center(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  splashController.userBalance.value.toString(),
                                                  style:
                                                      const TextStyle(color: ColorHelper.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(width: deviceHeight * 0.01),
                                                SizedBox(
                                                  height: isTablet ? deviceShortestSide * 0.025 : deviceHeight * 0.04,
                                                  width: isTablet ? deviceShortestSide * 0.025 : deviceHeight * 0.04,
                                                  child: Image.asset(
                                                    Assets.iconsChipsIcon,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: deviceWidth * 0.03),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.64,
                                width: deviceWidth * 0.54,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: deviceHeight,
                                      width: deviceWidth,
                                      child: Image.asset(
                                        Assets.iconsDialogSubBg,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    if (splashController.selectedOptionInDialog.value == 0) buyChipsWid(),
                                    if (splashController.selectedOptionInDialog.value == 1) withdrawWid(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: isTablet ? 8 : 5,
                          right: isTablet ? 3.5 : 3,
                          child: InkWell(
                            onTap: () {
                              splashController.addMoneyWithDrawdialogAlign(!splashController.addMoneyWithDrawdialogAlign.value);
                            },
                            child: SizedBox(
                              height: deviceHeight * 0.15,
                              width: deviceHeight * 0.15,
                              child: Image.asset(
                                Assets.iconsCloseIcon,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: deviceWidth * 0.01, top: deviceHeight * 0.15),
                    width: isTablet ? deviceWidth * 0.175 : deviceWidth * 0.18,
                    height: deviceHeight * 0.60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            addMoneyBtns("Buy Chips", 0),
                            SizedBox(height: deviceHeight * 0.03),
                            addMoneyBtns("Withdraw", 1),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            splashController.recordDialogAlign(!splashController.recordDialogAlign.value);
                            splashController.getWithDrawRequestList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.receipt_long, color: ColorHelper.gray),
                              SizedBox(width: 10),
                              Text(
                                "Records",
                                style: TextStyle(color: ColorHelper.white, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 */
  /* Widget buyChipsWid() {
    return SizedBox(
      height: deviceHeight,
      width: deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[0].addMoneyChips, price: splashController.addMoneyItemList[0].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[1].addMoneyChips, price: splashController.addMoneyItemList[1].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[2].addMoneyChips, price: splashController.addMoneyItemList[2].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[3].addMoneyChips, price: splashController.addMoneyItemList[3].addMoneyPrice),
            ],
          ),
          SizedBox(height: itemSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[4].addMoneyChips, price: splashController.addMoneyItemList[4].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[5].addMoneyChips, price: splashController.addMoneyItemList[5].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[6].addMoneyChips, price: splashController.addMoneyItemList[6].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(
                  chips: splashController.addMoneyItemList[7].addMoneyChips, price: splashController.addMoneyItemList[7].addMoneyPrice),
            ],
          ),
        ],
      ),
    );
  }

  Widget withdrawWid() {
    return SizedBox(
      height: deviceHeight,
      width: deviceWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: deviceHeight * 0.03),
          Container(
            height: deviceHeight * 0.18,
            width: deviceWidth * 0.46,
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
            decoration: BoxDecoration(color: Colors.black26.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cmnTotalBalWid(title: "Total Balance", amount: splashController.userBalance.value.toString()),
                cmnTotalBalWid(title: "Withdrawable", amount: getWithdrawable),
              ],
            ),
          ),
          SizedBox(height: deviceHeight * 0.013),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              cmnTextWid("Amount"),
              SizedBox(width: deviceWidth * 0.03),
              SizedBox(
                height: deviceHeight * 0.07,
                width: deviceWidth * 0.14,
                child: Stack(
                  children: [
                    SizedBox(
                      height: deviceHeight,
                      width: deviceWidth,
                      child: Image.asset(
                        Assets.iconsFinalBtn,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: deviceWidth * 0.095,
                        child: cmnTextField(
                          controller: splashController.amountTextController,
                          focusNode: splashController.amountNode,
                          contentPadding: EdgeInsets.zero,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.013),
          Container(
            alignment: Alignment.centerLeft,
            height: deviceHeight * 0.23,
            width: deviceWidth * 0.40,
            padding: EdgeInsets.only(left: deviceWidth * 0.02),
            decoration: BoxDecoration(color: Colors.black26.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cmnUpiFieldsWid(
                  title: "Upi Address",
                  controller: splashController.upiAddController,
                  focusNode: splashController.upiAddNode,
                  readOnly: splashController.upiAddReadOnly.value,
                ),
                cmnUpiFieldsWid(
                  title: "Upi Name",
                  controller: splashController.upiNameController,
                  focusNode: splashController.upiNameNode,
                  readOnly: splashController.upiNameReadOnly.value,
                ),
              ],
            ),
          ),
          SizedBox(height: deviceHeight * 0.013),
          InkWell(
            onTap: () {
              int enteredAmount = int.tryParse(splashController.amountTextController.text.trim()) ?? 0;
              if (splashController.upiAddController.text.trim().isNotEmpty &&
                  splashController.upiNameController.text.trim().isNotEmpty &&
                  splashController.amountTextController.text.trim().isNotEmpty &&
                  enteredAmount >= splashController.minWithdrawLimit.value &&
                  enteredAmount <= splashController.maxWithdrawLimit.value &&
                  enteredAmount <= splashController.userBalance.value) {
                splashController.amountTextController.clear();
                splashController.withDrawRequest(enteredAmount);
              } else {
                if (splashController.amountTextController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Please Enter valid Amount");
                }
                if (splashController.upiAddController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Please Fill the Upi Details Correctly");
                }
                if (splashController.upiNameController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Please Fill the Upi Details Correctly");
                }
                if (enteredAmount < splashController.minWithdrawLimit.value) {
                  Fluttertoast.showToast(msg: "Amount must be greater than ${splashController.minWithdrawLimit.value}");
                }
                if (enteredAmount > splashController.userBalance.value &&
                    splashController.userBalance.value < splashController.maxWithdrawLimit.value) {
                  Fluttertoast.showToast(msg: "Amount must be lower than ${splashController.userBalance.value}");
                } else if (enteredAmount > splashController.maxWithdrawLimit.value) {
                  Fluttertoast.showToast(msg: "Amount must be lower than ${splashController.maxWithdrawLimit.value}");
                }
              }
            },
            child: SizedBox(
              height: deviceHeight * 0.07,
              width: deviceWidth * 0.12,
              child: Stack(
                children: [
                  SizedBox(
                    height: deviceHeight,
                    width: deviceWidth,
                    child: Image.asset(
                      Assets.iconsBtnBg,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Withdraw",
                      style: TextStyle(color: ColorHelper.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
 */
  /* String get getWithdrawable {
    if (splashController.userBalance.value > splashController.minWithdrawLimit.value &&
        splashController.userBalance.value < splashController.maxWithdrawLimit.value) {
      return splashController.userBalance.value.toString();
    } else if (splashController.userBalance.value < splashController.minWithdrawLimit.value) {
      return 0.toString();
    } else if (splashController.userBalance.value > splashController.maxWithdrawLimit.value) {
      return splashController.maxWithdrawLimit.value.toString();
    }
    return 0.toString();
  }

  Widget cmnUpiFieldsWid({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool readOnly = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: deviceWidth * 0.12, child: cmnTextWid(title)),
        cmnTextWid(":"),
        SizedBox(width: deviceWidth * 0.03),
        SizedBox(
          height: deviceHeight * 0.09,
          width: deviceWidth * 0.22,
          child: Stack(
            children: [
              SizedBox(
                height: deviceHeight,
                width: deviceWidth,
                child: Image.asset(
                  Assets.iconsUpiaddBg,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: SizedBox(
                  width: deviceWidth * 0.21,
                  child: cmnTextField(
                    controller: controller,
                    focusNode: focusNode,
                    readOnly: readOnly,
                    contentPadding: EdgeInsets.only(left: deviceHeight * 0.025),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cmnTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    EdgeInsetsGeometry? contentPadding,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: ColorHelper.white, fontSize: 11, fontWeight: FontWeight.bold),
      cursorColor: Colors.white.withOpacity(0.7),
      decoration: InputDecoration(
        isCollapsed: true,
        // hintText: value,
        // hintStyle: const TextStyle(
        //   color: ColorHelper.white,
        //   fontSize: 11,
        //   fontWeight: FontWeight.bold,
        // ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: contentPadding,
      ),
    );
  }

  Widget cmnTotalBalWid({required String title, required String amount}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        cmnTextWid(title),
        SizedBox(height: deviceHeight * 0.015),
        SizedBox(
          height: deviceHeight * 0.07,
          width: deviceWidth * 0.14,
          child: Stack(
            children: [
              SizedBox(
                height: deviceHeight,
                width: deviceWidth,
                child: Image.asset(
                  Assets.iconsFinalBtn,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Text(
                  amount,
                  style: const TextStyle(color: ColorHelper.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cmnTextWid(String textStr) {
    return Text(
      textStr,
      style: const TextStyle(color: ColorHelper.white, fontSize: 13, fontWeight: FontWeight.bold),
    );
  }

  Widget cmnBuyChipWid({required String chips, required String price}) {
    return SizedBox(
      height: deviceWidth * 0.12,
      width: deviceWidth * 0.12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: deviceHeight,
            width: deviceHeight,
            child: Image.asset(
              Assets.iconsAddmoneyBox,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: deviceHeight * 0.025,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chips,
                  style: const TextStyle(color: ColorHelper.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: deviceHeight * 0.01),
                SizedBox(
                  height: deviceHeight * 0.04,
                  width: deviceHeight * 0.04,
                  child: Image.asset(
                    Assets.iconsChipsIcon,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: deviceHeight * 0.022,
            child: Text(
              "₹ $price",
              style: const TextStyle(color: ColorHelper.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
 */
  /* Widget addMoneyBtns(String btnText, int i) {
    return InkWell(
      onTap: () {
        splashController.selectedOptionInDialog(i);
      },
      child: SizedBox(
        height: deviceHeight * 0.12,
        width: deviceWidth * 0.15,
        child: Stack(
          children: [
            if (splashController.selectedOptionInDialog.value == i)
              SizedBox(
                height: deviceHeight,
                width: deviceWidth,
                child: Image.asset(
                  Assets.iconsBtnBg,
                  fit: BoxFit.fill,
                ),
              ),
            Center(
              child: Text(
                btnText,
                style: const TextStyle(color: ColorHelper.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
 */
  /* Widget recordsDialog(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom * 0.65,
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.4),
          ),
          margin: EdgeInsets.all(splashController.recordDialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: splashController.recordDialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(splashController.recordDialogAlign.value ? 0 : deviceHeight * 0.80),
            duration: const Duration(milliseconds: 200),
            height: deviceHeight * 0.88,
            width: deviceWidth * 0.75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * 0.86,
                  width: deviceWidth * 0.75,
                  child: Image.asset(
                    Assets.iconsDialogSubBg,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Table(
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorHelper.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                children: [
                                  recordRowWid("No", showBorder: true, isTitle: true),
                                  recordRowWid("Amount", showBorder: true, isTitle: true),
                                  recordRowWid("Time", showBorder: true, isTitle: true),
                                  recordRowWid("Status", showBorder: true, isTitle: true),
                                ],
                              ),
                              ...records(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: isTablet ? 9.5 : 7,
                  right: isTablet ? 2 : 2.5,
                  child: InkWell(
                    onTap: () {
                      splashController.recordDialogAlign(!splashController.recordDialogAlign.value);
                    },
                    child: SizedBox(
                      height: deviceHeight * 0.15,
                      width: deviceHeight * 0.15,
                      child: Image.asset(
                        Assets.iconsCloseIcon,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> records() {
    return List.generate(
      splashController.withdrawItemList.length <= 7 ? splashController.withdrawItemList.length : 7,
      (index) => TableRow(
        children: [
          recordRowWid(splashController.withdrawItemList.reversed.toList()[index].no),
          recordRowWid(splashController.withdrawItemList.reversed.toList()[index].amount),
          recordRowWid(splashController.withdrawItemList.reversed.toList()[index].time),
          recordRowWid(splashController.withdrawItemList.reversed.toList()[index].status),
        ],
      ),
    );
  }

  Widget recordRowWid(String dataText, {bool showBorder = false, bool isTitle = false}) {
    return Container(
      height: isTitle ? null : 30,
      padding: showBorder ? const EdgeInsets.only(bottom: 8) : null,
      alignment: Alignment.center,
      child: Text(
        dataText,
        style: TextStyle(
          color: isTitle ? ColorHelper.white : ColorHelper.white,
          fontSize: isTitle ? 16 : 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  } */
}

class WebViewApp extends StatefulWidget {
  final String url;
  const WebViewApp({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
