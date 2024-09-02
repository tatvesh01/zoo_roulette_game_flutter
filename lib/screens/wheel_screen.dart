import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:video_player/video_player.dart';
import 'package:zoo_zimba/controllers/wheel_controller.dart';
import '../Utils/color_helper.dart';
import '../controllers/aw_dialog_controller.dart';
import '../controllers/splash_screen_controller.dart';
import '../generated/assets.dart';
import 'dart:math' as math;
import '../globles.dart';
import '../models/selected_item_model.dart';
import 'package:bordered_text/bordered_text.dart';

class WheelSCREEN extends StatelessWidget {
  WheelSCREEN({Key? key}) : super(key: key);
  WheelController wheelController = Get.put(WheelController());
  CommonDialogController commonDialogController = Get.find();
  double chipsSpacing = 5;
  double itemSpacing = 4;
  Alignment commonStartAlignMent = const Alignment(0.92, -0.78);
  Alignment commonStartAlignMentUser = const Alignment(-0.955, 0.90);

  @override
  Widget build(BuildContext context) {
    chipsSpacing = deviceWidth * 0.006;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Obx(() => mainFullScreenContainer()),
          Obx(() => balanceUpdateAnimWid()),
          Obx(() => coinAnimWidUsers()),
          Obx(() => userBalanceWid()),
          Obx(() => bottomWid(context)),
          Obx(() => usersWid()),
          Obx(() => placeBetWid()),
          Obx(() => stopBetWid()),
          backButtonWid(),
          Obx(
            () => wheelController.palceBetTimer1SecCountDown.value <= 3 && wheelController.palceBetTimer1SecCountDown.value > 0
                ? animWid321()
                : const SizedBox(),
          ),
          Obx(() => resultItemMiddelWid()),
          Obx(() => wheelController.canPlayerBet.value ? betTimerWid() : const SizedBox()),
          animWidParrot(),
          Obx(() =>
              wheelController.isJustEnterInGame.value && !wheelController.isFirstTimeInWheelScreen.value ? waitingWid() : const SizedBox()),
          Obx(() => wheelController.isFirstTimeInWheelScreen.value ? darkLayerWid() : const SizedBox()),
          Obx(() => wheelController.isFirstTimeInWheelScreen.value ? arrowLottie() : const SizedBox()),
          Obx(() => wheelController.isFirstTimeInWheelScreen.value ? backButtonWid(isFromGuide: true) : const SizedBox()),
          Obx(() => hintVidDialog(context)),
          Obx(() => hintTextDialog(context)),
          Obx(() => commonDialogController.addMoneyDialog(context, itemSpacing)),
          Obx(() => commonDialogController.recordsDialog(context)),
          // wheelNewDesign(),
        ],
      ),
    );
  }

  Positioned arrowLottie() {
    return Positioned(
      top: deviceHeight * 0.3,
      right: deviceWidth * 0.05,
      child: Lottie.asset(
        Assets.lottieJsonsArrow,
        height: deviceHeight * 0.30,
        width: deviceHeight * 0.30,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget waitingWid() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.3),
      ),
      width: deviceWidth,
      height: deviceHeight,
      padding: EdgeInsets.only(bottom: deviceHeight * 0.08, left: deviceWidth * 0.08),
      child: BorderedText(
        strokeColor: const Color(0xFF836324),
        strokeWidth: 5,
        child: const Text(
          "Waiting for next round...",
          style: TextStyle(
            color: Color.fromARGB(255, 230, 208, 127),
            fontSize: 30,
            fontWeight: FontWeight.w600,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget darkLayerWid() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.5),
      ),
      width: deviceWidth,
      height: deviceHeight,
    );
  }

  Widget hintVidDialog(BuildContext context) {
    return Positioned(
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.4),
          ),
          margin: EdgeInsets.all(wheelController.hintDialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: wheelController.hintDialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(wheelController.hintDialogAlign.value ? 0 : deviceHeight * 0.80),
            duration: const Duration(milliseconds: 200),
            height: deviceHeight * 0.89,
            width: deviceWidth * 0.75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * 0.89,
                  width: deviceWidth * 0.75,
                  child: Image.asset(
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    Assets.iconsDialogSubBg,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: deviceHeight * 0.85,
                    width: deviceWidth * 0.73,
                    child: wheelController.ishintVidcontrollerReady.value && wheelController.hintVidcontroller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: wheelController.hintVidcontroller.value.aspectRatio,
                            child: Stack(
                              children: [
                                VideoPlayer(wheelController.hintVidcontroller),
                                Container(
                                    height: deviceHeight * 0.81,
                                    width: deviceWidth * 0.73,
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 15,),

                                        InkWell(
                                          onTap: (){
                                            wheelController.hintVidcontroller.play();
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                              Assets.iconsVideoIcon,
                                              fit: BoxFit.fill,
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Expanded(
                                            flex: 10,
                                            child: VideoProgressIndicator(wheelController.hintVidcontroller, allowScrubbing: true)),
                                      ],
                                    )),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ),
                Positioned(
                  top: 2.5,
                  right: 2.5,
                  child: InkWell(
                    onTap: () {
                      wheelController.hintDialogAlign(!wheelController.hintDialogAlign.value);
                      wheelController.hintVidcontroller.seekTo(Duration.zero);
                      wheelController.hintVidcontroller.pause();
                    },
                    child: SizedBox(
                      height: deviceHeight * 0.15,
                      width: deviceHeight * 0.15,
                      child: Image.asset(
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
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

  Widget hintTextDialog(BuildContext context) {
    return Positioned(
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.4),
          ),
          margin: EdgeInsets.all(wheelController.hintTextDialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: wheelController.hintTextDialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(wheelController.hintTextDialogAlign.value ? 0 : deviceHeight * 0.80),
            duration: const Duration(milliseconds: 200),
            height: deviceHeight * 0.76,
            width: deviceWidth * 0.75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * 0.89,
                  width: deviceWidth * 0.75,
                  child: Image.asset(
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    Assets.iconsDialogSubBg,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.031),
                    child: Text(
                      hintText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                Positioned(
                  top: 2.5,
                  right: 2.5,
                  child: InkWell(
                    onTap: () {
                      wheelController.hintTextDialogAlign(!wheelController.hintTextDialogAlign.value);
                    },
                    child: SizedBox(
                      height: deviceHeight * 0.15,
                      width: deviceHeight * 0.15,
                      child: Image.asset(
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
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

  Widget upiDialog(BuildContext context) {
    return Positioned(
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedContainer(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.4),
          ),
          margin: EdgeInsets.all(wheelController.upiDialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: wheelController.upiDialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(wheelController.upiDialogAlign.value ? 0 : deviceHeight * 0.80),
            duration: const Duration(milliseconds: 200),
            height: deviceHeight * 0.89,
            width: deviceWidth * 0.75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * 0.89,
                  width: deviceWidth * 0.75,
                  child: Image.asset(
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    Assets.iconsDialogSubBg,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 2.5,
                  right: 2.5,
                  child: InkWell(
                    onTap: () {
                      wheelController.upiDialogAlign(!wheelController.upiDialogAlign.value);
                    },
                    child: SizedBox(
                      height: deviceHeight * 0.15,
                      width: deviceHeight * 0.15,
                      child: Image.asset(
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
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

  Widget animWidParrot() {
    return Positioned(
      top: 0,
      left: 0,
      child: IgnorePointer(
        ignoring: true,
        child: Lottie.asset(
          Assets.lottieJsonsParrot,
          height: deviceHeight * 0.30,
          width: deviceHeight * 0.30,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget animWid321() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: deviceHeight * 0.15),
        child: IgnorePointer(
          ignoring: true,
          child: Lottie.asset(
            Assets.lottieJsonsThreeTwoOne,
            height: deviceHeight * 0.40,
            width: deviceHeight * 0.40,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget bottomWid(BuildContext context) {
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: deviceWidth * 0.025),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: deviceWidth * 0.98,
              child: Image.asset(
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
                Assets.iconsBottomsssss,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Center(child: SizedBox(width: deviceWidth * 0.60, child: chipsRow())),
          Positioned(
              bottom: deviceHeight * 0.005,
              right: 0,
              child: InkWell(
                onTap: () async {
                  if(!playasgueststatusData.value){
                    commonDialogController.addMoneyWithDrawdialogAlign(!commonDialogController.addMoneyWithDrawdialogAlign.value);
                    commonDialogController.selectedOptionInDialog(0);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  height: deviceHeight * 0.14,
                  width: deviceWidth * 0.20,
                ),
              )),
          SizedBox(width: deviceWidth),
        ],
      ),
    );
  }

  Widget balanceUpdateAnimWid() {
    //const Alignment(-0.80, 1),const Alignment(-0.80, 0.60),const Alignment(-0.80, 0.70),const Alignment(-0.80, 0.65),const Alignment(-0.80, 0.68)
    return AnimatedAlign(
      alignment: wheelController.balanceUpdateAnimAlign.value == 0
          ? const Alignment(-0.80, 0.95)
          : wheelController.balanceUpdateAnimAlign.value == 1
              ? const Alignment(-0.80, 0.60)
              : wheelController.balanceUpdateAnimAlign.value == 2
                  ? const Alignment(-0.80, 0.70)
                  : wheelController.balanceUpdateAnimAlign.value == 3
                      ? const Alignment(-0.80, 0.65)
                      : wheelController.balanceUpdateAnimAlign.value == 4
                          ? const Alignment(-0.80, 0.68)
                          : const Alignment(-0.80, 0.68),
      duration: wheelController.makeInvisiblebalanceUpdate.value ? Duration.zero : const Duration(milliseconds: 380),
      child: Container(
        // height: deviceHeight * 0.06,
        // width: deviceHeight * 0.06,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: BorderedText(
          strokeColor: const Color(0xFF836324),
          strokeWidth: 2,
          child: Text(
            wheelController.afterWinOrLossAmount.toString(),
            style: const TextStyle(
              color: Color.fromARGB(255, 239, 217, 134),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              // fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget betTimerWid() {
    return Positioned(
      top: 0,
      left: deviceWidth * 0.265,
      child: SizedBox(
        width: deviceWidth * 0.095,
        height: deviceWidth * 0.095,
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: deviceWidth * 0.07,
                  child: Image.asset(
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    Assets.iconsCenterOfCircle2,
                    fit: BoxFit.fill,
                  ),
                ),
                Lottie.asset(
                  Assets.lottieJsonsCountdown,
                  height: deviceHeight * 0.50,
                  width: deviceHeight * 0.50,
                  fit: BoxFit.fitWidth,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: deviceHeight * 0.040),
                    Text(
                      wheelController.canPlayerBet.value ? "Betting" : '',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 17,
                        fontFamily: 'Canterbury',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.08),
                    /* SizedBox(
                height: 40,
                child: DefaultTextStyle(
                  style: TextStyle(
                      color: Colors.red[900], fontSize: 22, fontFamily: 'Horizon', fontWeight: FontWeight.w500),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 50),
                    animatedTexts: [
                      for (int i = 10; i >= 0; i--)
                        RotateAnimatedText(
                          '$i',
                          duration: const Duration(milliseconds: 810),
                        ),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ), */
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: deviceHeight * 0.050),
                    Text(
                      wheelController.canPlayerBet.value ? wheelController.palceBetTimer1SecCountDown.value.toString() : '',
                      style: const TextStyle(color: Colors.black54, fontSize: 22, fontFamily: 'Canterbury', fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            /* SizedBox(
              height: 30,
              width: 15,
              child: Image.asset(errorBuilder: (context, error, stackTrace) => const SizedBox(),
                Assets.imagesChain,
                fit: BoxFit.contain,
              ),
            ), */
            /* Positioned(
              right: 0,
              child: SizedBox(
                height: 30,
                width: 15,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.asset(errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    Assets.imagesChain,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }

  Widget coinAnimWidUsers() {
    return Positioned(
      child: commonCoinAnimUser(
        startAlignment: commonStartAlignMentUser,
        endAlignment: coinAnimAlignmentsList[wheelController.selectedCurrentItemIndex.value],
        coinImg: coinAnimChipsList[wheelController.selectedCoin.value - 1],
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  Widget mainFullScreenContainer() {
    return Container(
      /* color: ColorHelper.darkBlue, */
      decoration: const BoxDecoration(
        gradient: ColorHelper.appBarGradient,
        image: DecorationImage(
          image: AssetImage(Assets.iconsBgFull1),
          fit: BoxFit.cover,
        ),
      ),
      height: deviceHeight,
      child: mainRowWidget(),
    );
  }

  Widget mainRowWidget() {
    return Row(
      children: [
        SizedBox(width: deviceWidth * 0.031),
        wheelWidMainRowPart(),
        Expanded(
          child: SizedBox(
            height: deviceHeight,
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.050, top: deviceHeight * 0.066),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  columnOf3Items(
                                    i1: 1,
                                    i2: 8,
                                    itemName1: Assets.betItemsMonkey.getBetItemNameValue(),
                                    itemImage1: Assets.betItemsMonkey,
                                    itemName2: Assets.betItemsLion.getBetItemNameValue(),
                                    itemImage2: Assets.betItemsLion,
                                  ),
                                  SizedBox(width: itemSpacing),
                                  columnOf3Items(
                                    i1: 6,
                                    i2: 3,
                                    itemName1: Assets.betItemsRabbit.getBetItemNameValue(),
                                    itemImage1: Assets.betItemsRabbit,
                                    itemName2: Assets.betItemsPanda.getBetItemNameValue(),
                                    itemImage2: Assets.betItemsPanda,
                                  ),
                                  SizedBox(width: itemSpacing),
                                  columnOf3Items(
                                    i1: 0,
                                    i2: 5,
                                    itemName1: Assets.betItemsSwallow.getBetItemNameValue(),
                                    itemImage1: Assets.betItemsSwallow,
                                    itemName2: Assets.betItemsPeacock.getBetItemNameValue(),
                                    itemImage2: Assets.betItemsPeacock,
                                  ),
                                  SizedBox(width: itemSpacing),
                                  columnOf3Items(
                                    i1: 7,
                                    i2: 2,
                                    itemName1: Assets.betItemsPigeon.getBetItemNameValue(),
                                    itemImage1: Assets.betItemsPigeon,
                                    itemName2: Assets.betItemsEagle.getBetItemNameValue(),
                                    itemImage2: Assets.betItemsEagle,
                                  ),
                                ],
                              ),
                              SizedBox(height: itemSpacing * 1.5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  sharkBetItemWid(
                                    i: 4,
                                    itemName: Assets.betItemsShark.getBetItemNameValue(),
                                    itemImage: Assets.betItemsShark,
                                  ),
                                  SizedBox(width: itemSpacing),
                                  sharkBetItemWid(
                                    i: 9,
                                    itemName: Assets.betItemsFrog.getBetItemNameValue(),
                                    itemImage: Assets.betItemsFrog,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            // decoration: const BoxDecoration(color: ColorHelper.bgColor),
                            width: deviceWidth * 0.075,
                            height: deviceHeight * 0.7,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: deviceWidth * 0.075,
                                  height: deviceHeight * 0.7,
                                  child: Image.asset(
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                    Assets.recordItemsRecordbox,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                wheelController.isJustEnterInGame.value && !wheelController.isFirstTimeInWheelScreen.value
                                    ? const SizedBox()
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: deviceHeight * 0.13,
                                          right: 5,
                                          left: 5,
                                          bottom: deviceHeight * 0.025,
                                        ),
                                        child: ListView.separated(
                                          itemCount: wheelController.recordItemsList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return SizedBox(
                                              // color: Colors.white,
                                              width: deviceWidth * 0.030,
                                              height: deviceWidth * 0.060,
                                              child: Image.asset(
                                                errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                                wheelController.recordItemsList[index].recordItemImgpath,
                                                fit: BoxFit.fill,
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) => const SizedBox(
                                            height: 5,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: deviceWidth * 0.085,
                      child: SizedBox(
                        height: deviceHeight * 0.076,
                        width: deviceWidth * 0.019,
                        child: Image.asset(
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          Assets.imagesChain,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: deviceWidth * 0.230,
                      child: SizedBox(
                        height: deviceHeight * 0.076,
                        width: deviceWidth * 0.019,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Image.asset(
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            Assets.imagesChain,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                /*  Stack(
                  children: [
                    SizedBox(
                      width: deviceWidth,
                      height: deviceWidth * 0.10,
                      child: Image.asset(errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        Assets.iconsBottoms,
                        fit: BoxFit.fill,
                      ),
                    ),
                    
                  ],
                ), */
              ],
            ),
          ),
        ),
        SizedBox(width: deviceWidth * 0.030),
      ],
    );
  }

  Widget sharkBetItemWid({
    required int i,
    required String itemName,
    required String itemImage,
  }) {
    return Obx(
      () => wheelController.isItemWidUpdate.value
          ? Container()
          : InkWell(
              onTap: wheelController.canPlayerBet.value
                  ? () {
                      clickOfBet(i, itemName);
                    }
                  : null,
              child: Container(
                width: (deviceWidth * 0.19) + itemSpacing,
                height: isTablet ? deviceWidth * 0.12 : deviceWidth * 0.10,
                // margin: EdgeInsets.fromLTRB(deviceWidth * 0.1, 0, 0, 0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  /* image: DecorationImage(
                  image: AssetImage(Assets.iconsBgImg),
                  fit: BoxFit.cover,
                ), */
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: deviceHeight,
                      width: deviceWidth,
                      child: Image.asset(
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        itemImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    if (wheelController.whereTOStopCount.value == i && wheelController.canlightedShow.value)
                      ExplicitAnimatedStyledContainer(
                        style: Style(
                          width: 156.toPXLength,
                          height: 156.toPXLength,
                          alignment: Alignment.center,
                          childAlignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(0),
                          shapeBorder:
                              RectangleShapeBorder(border: wheelController.startBorder.copyWith(strokeCap: StrokeCap.round, width: 5)),
                        ),
                        localAnimations: {
                          AnimationTrigger.visible: MultiAnimationSequence(control: CustomAnimationControl.loop, sequences: {
                            AnimationProperty.shapeBorder: AnimationSequence<MorphableShapeBorder>()
                              ..add(
                                duration: const Duration(milliseconds: 1000),
                                value: RectangleShapeBorder(
                                    border: wheelController.middleBorder.copyWith(strokeCap: StrokeCap.round, width: 5)),
                              )
                              ..add(
                                duration: const Duration(milliseconds: 1000),
                                value:
                                    RectangleShapeBorder(border: wheelController.endBorder.copyWith(strokeCap: StrokeCap.round, width: 5)),
                              ),
                          }),
                        },
                        child: const SizedBox(),
                      ),
                    Container(
                      height: deviceHeight,
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: wheelController.whereTOStopCount.value == i && wheelController.canlightedShow.value
                            ? Colors.transparent
                            : Colors.black87.withOpacity(0.4),
                      ),
                    ),
                    /* Center(
                      child: Text(
                        wheelController.getitemAmount(i) == 0 ? "" : wheelController.getitemAmount(i).toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ), */
                    if (wheelController.canPlayerBet.value)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: deviceHeight * 0.008),
                          child: GradientText(
                            getBetBotAmpunt(itemName),
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                            ),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: .4,
                            colors: const [
                              Color.fromARGB(255, 11, 194, 197),
                              Color.fromARGB(255, 25, 70, 166),
                            ],
                          ), /* Text(
                          wheelController.getitemAmount(i) == 0 ? "" : wheelController.getitemAmount(i).toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 11, 194, 197), fontSize: 13, fontWeight: FontWeight.w800),
                        ), */
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: deviceHeight * 0.015),
                        child: BorderedText(
                          strokeColor: const Color(0xFF836324),
                          strokeWidth: 2,
                          child: Text(
                            wheelController.getitemAmount(i) == 0 ? "" : wheelController.getitemAmount(i).toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 239, 217, 134),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              // fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget chipsRow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chipsBtn(i: 1, chipPrice: Assets.iconsTenChips),
            SizedBox(width: chipsSpacing),
            chipsBtn(i: 2, chipPrice: Assets.iconsFiftyChips),
            SizedBox(width: chipsSpacing),
            chipsBtn(i: 3, chipPrice: Assets.iconsOneHundredChips),
            SizedBox(width: chipsSpacing),
            chipsBtn(i: 4, chipPrice: Assets.iconsFiveHundresChips),
            SizedBox(width: chipsSpacing),
            chipsBtn(i: 5, chipPrice: Assets.iconsOneThousandChips),
            SizedBox(width: chipsSpacing),
            chipsBtn(i: 6, chipPrice: Assets.iconsFiveThousandChips),
            SizedBox(width: chipsSpacing),
            chipsBtn(i: 7, chipPrice: Assets.iconsTenThousandChips),
            SizedBox(width: chipsSpacing),
          ],
        ),
      ),
    );
  }

  Widget wheelWidMainRowPart() {
    return SizedBox(
      width: deviceWidth * 0.30,
      height: deviceWidth * 0.30,
      child: Stack(
        children: [
          wheelWidget(),
        ],
      ),
    );
  }

  Widget wheelWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              wheelNewDesign(),
              Positioned(
                top: -(deviceHeight * 0.038),
                child: pointerWid(),
              ),
              // innerWheel(),
            ],
          ),
        ],
      ),
    );
  }

  Widget columnOf3Items({
    required int i1,
    required int i2,
    // required int i3,
    required String itemName1,
    required String itemImage1,
    required String itemName2,
    required String itemImage2,
    // required String itemName3,
  }) {
    return Column(
      children: [
        items(i1, itemName1, itemImage1),
        SizedBox(
          height: itemSpacing,
        ),
        items(i2, itemName2, itemImage2),
        /* SizedBox(height: itemSpacing),
        items(i3, itemName3), */
      ],
    );
  }

  Widget items(int i, String itemName, String itemImage) {
    return Obx(
      () => wheelController.isItemWidUpdate.value
          ? Container()
          : InkWell(
              onTap: wheelController.canPlayerBet.value
                  ? () {
                      clickOfBet(i, itemName);
                    }
                  : null,
              child: Container(
                width: deviceWidth * 0.095,
                height: deviceHeight * 0.26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  /* image: DecorationImage(
                  image: AssetImage(Assets.iconsBgImg),
                  fit: BoxFit.cover,
                ), */
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: deviceHeight,
                      width: deviceWidth,
                      child: Image.asset(
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        itemImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    /* InnerShadow(
                      blur: 5,
                      color: wheelController.whereTOStopCount.value == i && wheelController.canFrameShow.value
                          ? const Color(0xFFFFFFFF)
                          : Colors.transparent,
                      offset: const Offset(5, 5),
                      child: SizedBox(
                        height: deviceHeight,
                        width: deviceWidth,
                        child: Image.asset(errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          itemImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ), */
                    if (wheelController.whereTOStopCount.value == i && wheelController.canlightedShow.value)
                      ExplicitAnimatedStyledContainer(
                        style: Style(
                          width: 150.toPXLength,
                          height: 150.toPXLength,
                          alignment: Alignment.center,
                          childAlignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(0),
                          shapeBorder:
                              RectangleShapeBorder(border: wheelController.startBorder.copyWith(strokeCap: StrokeCap.round, width: 5)),
                        ),
                        localAnimations: {
                          AnimationTrigger.visible: MultiAnimationSequence(control: CustomAnimationControl.loop, sequences: {
                            AnimationProperty.shapeBorder: AnimationSequence<MorphableShapeBorder>()
                              ..add(
                                duration: const Duration(milliseconds: 1000),
                                value: RectangleShapeBorder(
                                    border: wheelController.middleBorder.copyWith(strokeCap: StrokeCap.round, width: 5)),
                              )
                              ..add(
                                duration: const Duration(milliseconds: 1000),
                                value:
                                    RectangleShapeBorder(border: wheelController.endBorder.copyWith(strokeCap: StrokeCap.round, width: 5)),
                              ),
                          }),
                        },
                        child: const SizedBox(),
                      ),
                    /* if (wheelController.whereTOStopCount.value == i)
                      SizedBox(
                        height: deviceHeight,
                        width: deviceWidth,
                        child: Image.asset(errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          Assets.imagesBlinkingFrameWhite,
                          fit: BoxFit.fill,
                        ),
                      ), */
                    Container(
                      height: deviceHeight,
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: wheelController.whereTOStopCount.value == i && wheelController.canlightedShow.value
                            ? Colors.transparent
                            : Colors.black87.withOpacity(0.4),
                      ),
                    ),
                    if (wheelController.canPlayerBet.value)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: deviceHeight * 0.008),
                          child: GradientText(
                            getBetBotAmpunt(itemName),
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                            ),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: .4,
                            colors: const [
                              Color.fromARGB(255, 11, 194, 197),
                              Color.fromARGB(255, 25, 70, 166),
                            ],
                          ) /* Text(
                          wheelController.getitemAmount(i) == 0 ? "" : wheelController.getitemAmount(i).toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 11, 194, 197), fontSize: 13, fontWeight: FontWeight.w800),
                        ) */
                          ,
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: deviceHeight * 0.06),
                        child: BorderedText(
                          strokeColor: const Color(0xFF836324),
                          strokeWidth: 2,
                          child: Text(
                            wheelController.getitemAmount(i) == 0 ? "" : wheelController.getitemAmount(i).toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 239, 217, 134),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              // fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String getBetBotAmpunt(String itemName) {
    String betBotValue = "";
    String tempItemkey = wheelController.betCountOnEach.value.toJson().keys.where((element) {
      return element == itemName;
    }).toString();
    try {
      if (wheelController.betCountOnEach.value.toJson()[tempItemkey.replaceAll("(", "").replaceAll(")", "")] != 0) {
        betBotValue = wheelController.betCountOnEach.value.toJson()[tempItemkey.replaceAll("(", "").replaceAll(")", "")].toString();
      }
    } catch (e) {
      debugPrint('E: $e');
    }

    return betBotValue;
  }

  void clickOfBet(int i, String itemName) {
    if ((wheelController.isFirstTime || wheelController.checkFirstTimeForCanBet.value) &&
        wheelController.userBalance.value >= 20 &&
        wheelController.getCoinValue() == 10) {
      subMethodClickOfBet(i, itemName);
    } else if (((wheelController.isFirstTime || wheelController.checkFirstTimeForCanBet.value) && wheelController.getCoinValue() != 10)) {
      Fluttertoast.showToast(msg: "To bet above 10 ₹ please add money");
    } else if (wheelController.userBalance.value >= 20 && wheelController.userBalance.value >= wheelController.getCoinValue()) {
      subMethodClickOfBet(i, itemName);
    } else {
      /* if (wheelController.userBalance.value < wheelController.getCoinValue()) {
        
      } */
      Fluttertoast.showToast(msg: "You don't have enough balance please add money");
    }
  }

  void subMethodClickOfBet(int i, String itemName) {
    debugPrint("selectedItems i ==>  $i itemName $itemName");

    if (wheelController.selectedItems.any((element) => element.selectedItemIndex == i)) {
      debugPrint("this is if contains");
      debugPrint("already has one ====> i ==> $i itemName $itemName");
      for (var k = 0; k < wheelController.selectedItems.length; k++) {
        if (wheelController.selectedItems[k].selectedItemIndex == i) {
          wheelController.selectedItems[k].selectedItemAmount += wheelController.getCoinValue();
          wheelController.userBalance.value -= wheelController.getCoinValue();
          wheelController.selectedCurrentItemIndex(i);
          wheelController.coinAnimCallMethodUser();
        }
      }
    } else {
      debugPrint("this is else contains");
      if (wheelController.selectedItems.length < 4) {
        debugPrint("new has one ====> i ==> $i itemName $itemName");
        wheelController.selectedItems.add(
          SelectedItem(selectedItemAmount: wheelController.getCoinValue(), selectedItemIndex: i, selectedItemName: itemName),
        );
        wheelController.userBalance.value -= wheelController.getCoinValue();
        wheelController.selectedCurrentItemIndex(i);
        wheelController.coinAnimCallMethodUser();
      }
    }

    debugPrint('wheelController.userBalance.VALUE: ${wheelController.userBalance.value}');
    debugPrint("selectedItems.length ==>  ${wheelController.selectedItems.length}");
    List temp = [];
    for (var inx = 0; inx < wheelController.selectedItems.length; inx++) {
      temp.add(wheelController.selectedItems[inx].toJson());
    }
    Map<String, Object?> abc = {selectedBetItemsKey: temp};
    debugPrint("selectedItems ==>  $temp");
    debugPrint("selectedItems ==>  ${jsonEncode(abc)}");
    wheelController.updateBetArreyByPlayerId(selectedBetItemsMap: abc, selecteditemIndex: i);
    debugPrint('GETITEMAMOUNT(I): ${wheelController.getitemAmount(i)}');
    wheelController.isItemWidUpdate(true);
    wheelController.isItemWidUpdate(false);
  }

  Widget chipsBtn({required int i, required String chipPrice}) {
    return InkWell(
      onTap: () {
        wheelController.selectedCoin(i);
        debugPrint('WHEELCONTROLLER.SELECTEDCOIN: ${wheelController.selectedCoin.value}');
      },
      child: Stack(
        children: [
          Container(
            margin:
                wheelController.selectedCoin.value == i ? EdgeInsets.only(bottom: deviceHeight * 0.025, right: deviceWidth * 0.004) : null,
            height: isTablet
                ? deviceHeight * 0.11
                : deviceHeight > 400
                    ? deviceHeight * 0.12
                    : deviceHeight * 0.135,
            width: isTablet
                ? deviceHeight * 0.11
                : deviceHeight > 400
                    ? deviceHeight * 0.12
                    : deviceHeight * 0.135,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: wheelController.selectedCoin.value == i ? Colors.green : Colors.transparent,
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: wheelController.selectedCoin.value == i
                  ? [
                      const BoxShadow(
                        color: ColorHelper.white,
                        blurRadius: 2.5,
                        spreadRadius: 0,
                        offset: Offset(1, 2.5),
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: SizedBox(
                height: deviceHeight,
                child: Image.asset(
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  chipPrice,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            height: isTablet
                ? deviceHeight * 0.105
                : deviceHeight > 400
                    ? deviceHeight * 0.115
                    : deviceHeight * 0.135,
            width: isTablet
                ? deviceHeight * 0.105
                : deviceHeight > 400
                    ? deviceHeight * 0.115
                    : deviceHeight * 0.135,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: wheelController.selectedCoin.value != i ? Colors.black87.withOpacity(0.3) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget pointerWid() {
    return SizedBox(
      height: deviceHeight * 0.20,
      child: Image.asset(
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
        Assets.iconsPointer,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget userBalanceWid() {
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          Positioned(
            bottom: -(deviceHeight * 0.005),
            left: -(deviceWidth * 0.002),
            child: Stack(
              children: [
                SizedBox(
                  height: deviceHeight * 0.145,
                  width: deviceWidth * 0.23,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.145,
                        width: deviceWidth * 0.23,
                        child: Image.asset(
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          Assets.iconsBotomUserBg,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: deviceWidth * 0.047, top: deviceHeight * 0.013),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                commonDialogController.playerName.value,
                                style: const TextStyle(
                                  color: Color(0xFF3d251e),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                wheelController.userBalance.value.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF3d251e),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: isTablet ? -2 : null,
                  top: isTablet ? 3 : null,
                  child: SizedBox(
                    height: isTablet ? deviceHeight * 0.14 : deviceHeight * 0.16,
                    child: Image.asset(
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      Assets.iconsUserIconFrame,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget backButtonWid({bool isFromGuide = false}) {
    return Positioned(
      top: deviceHeight * 0.331,
      right: deviceWidth * 0.019,
      child: Column(
        children: [
          utilityButton(
              iconPath: isFromGuide ? "" : Assets.iconsBackIcon,
              onTap: () {
                Get.back();
              }),
          SizedBox(height: deviceHeight * 0.013),
          utilityButton(
              iconPath: Assets.iconsVideoIcon,
              onTap: () {
                wheelController.isFirstTimeInWheelScreen(false);
                wheelController.hintDialogAlign(!wheelController.hintDialogAlign.value);
                wheelController.hintVidcontroller.play();
              }),
          SizedBox(height: deviceHeight * 0.013),
          utilityButton(
              iconPath: isFromGuide ? "" : Assets.iconsInfoIcon,
              onTap: () {
                wheelController.hintTextDialogAlign(!wheelController.hintTextDialogAlign.value);
              }),
        ],
      ),
    );
  }

  Widget wheelNewDesign() {
    return AnimatedRotation(
      curve: Curves.easeOut,
      turns: wheelController.wheelTurn.value,
      duration: wheelController.wheelAnimDuration.value,
      child: SizedBox(
        child: Transform.rotate(
          angle: -20 * math.pi / 180,
          child: Image.asset(
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
            Assets.imagesCircleBgFinal,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget utilityButton({required String iconPath, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: deviceHeight * 0.120,
        width: deviceHeight * 0.120,
        child: Image.asset(
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
          iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget usersWid() {
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      alignment: Alignment.topLeft,
      // padding: const EdgeInsets.only(top: 30, left: 20),
      child: Stack(
        children: [
          /* if (wheelController.coinAnimationList.isNotEmpty && wheelController.coinAnimationList.last.isNotEmpty)
            ...wheelController.coinAnimationList.last, */ /* Assets.iconsInfoIcon */
          if (wheelController.doesShowAllCoins.value) ...[
            for (var i = 100; i <= 640; i += 30)
              commonLinerAnim(
                startAlignment: commonStartAlignMent,
                endAlignment: coinAnimAlignmentsList[math.Random().nextInt(3)],
                coinImg: coinAnimChipsList[math.Random().nextInt(5)],
                duration: Duration(milliseconds: i),
              ),
            for (var i = 100; i <= 640; i += 30)
              commonLinerAnim(
                startAlignment: commonStartAlignMent,
                endAlignment: coinAnimAlignmentsList[math.Random().nextInt(7) + 3],
                coinImg: coinAnimChipsList[math.Random().nextInt(5)],
                duration: Duration(milliseconds: i),
              ),
          ],
          Positioned(
            top: deviceHeight * 0.076,
            right: deviceWidth * 0.019,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: deviceHeight * 0.120,
                    width: deviceHeight * 0.120,
                    child: Image.asset(
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      Assets.iconsUserIcon2,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                BorderedText(
                  strokeColor: const Color(0xFF836324),
                  strokeWidth: 2,
                  child: Text(
                    "(${wheelController.onlineUsersCount.value.toString()})",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 239, 217, 134),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget frogCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.38, 0.52),
      coinImg: Assets.iconsOneHundredChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget sharkCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(-0.055, 0.52),
      coinImg: Assets.iconsOneHundredChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget eagleCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.465, -0.05),
      coinImg: Assets.iconsOneHundredChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget peacockCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.26, -0.05),
      coinImg: Assets.iconsOneHundredChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget pandaCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.05, -0.05),
      coinImg: Assets.iconsTenChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget lionCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(-0.15, -0.05),
      coinImg: Assets.iconsTenChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget pegionCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.465, -0.58),
      coinImg: Assets.iconsFiftyChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget swallowCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.26, -0.58),
      coinImg: Assets.iconsFiftyChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget rabbitCoinAnim() {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(0.05, -0.58),
      coinImg: Assets.iconsFiftyChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget monkeyCoinAnim({required Duration duration}) {
    return commonLinerAnim(
      startAlignment: commonStartAlignMent,
      endAlignment: const Alignment(-0.15, -0.58),
      coinImg: Assets.iconsTenChips,
      duration: const Duration(milliseconds: 500),
    );
  }

  List<Widget> coinWidAnimList() {
    // Future.delayed(Duration(milliseconds: math.Random().nextInt(200) + 50), () {});
    return List.generate(
      25,
      (i) => commonLinerAnim(
        startAlignment: commonStartAlignMent,
        endAlignment: coinAnimAlignmentsList[math.Random().nextInt(9)],
        coinImg: coinAnimChipsList[math.Random().nextInt(6)],
        duration: Duration(milliseconds: math.Random().nextInt(500) + 380),
      ),
    );
  }

  Widget commonLinerAnim(
      {required Alignment startAlignment, required Alignment endAlignment, required String coinImg, required Duration duration}) {
    return AnimatedAlign(
      alignment: wheelController.coinAnimationBool.value ? endAlignment : startAlignment,
      duration: wheelController.makeInvisibleCoinAnimation.value ? const Duration(milliseconds: 0) : duration,
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          height: deviceHeight * 0.06,
          width: deviceHeight * 0.06,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
            coinImg,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget commonLinerAnim2(
      {required Alignment startAlignment, required Alignment endAlignment, required String coinImg, required Duration duration}) {
    return AnimatedAlign(
      alignment: wheelController.coinAnimationBool2.value ? endAlignment : startAlignment,
      duration: wheelController.makeInvisibleCoinAnimation2.value ? const Duration(milliseconds: 0) : duration,
      child: Container(
        height: deviceHeight * 0.06,
        width: deviceHeight * 0.06,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
          coinImg,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget commonLinerAnim3(
      {required Alignment startAlignment, required Alignment endAlignment, required String coinImg, required Duration duration}) {
    return AnimatedAlign(
      alignment: wheelController.coinAnimationBool3.value ? endAlignment : startAlignment,
      duration: wheelController.makeInvisibleCoinAnimation3.value ? const Duration(milliseconds: 0) : duration,
      child: Container(
        height: deviceHeight * 0.06,
        width: deviceHeight * 0.06,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
          coinImg,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget commonCoinAnimUser({
    required Alignment startAlignment,
    required Alignment endAlignment,
    required String coinImg,
    required Duration duration,
  }) {
    return AnimatedAlign(
      alignment: wheelController.coinAnimationBoolUser.value ? endAlignment : startAlignment,
      duration: wheelController.makeInvisibleCoinAnimationUser.value ? const Duration(milliseconds: 0) : duration,
      child: Container(
        height: deviceHeight * 0.06,
        width: deviceHeight * 0.06,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
          coinImg,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget stopBetWid() {
    return Center(
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedAlign(
          alignment: wheelController.stopYourbetAlign.value == 0
              ? const Alignment(-4.78, 0)
              : wheelController.stopYourbetAlign.value == 1
                  ? const Alignment(0, 0)
                  : const Alignment(4.78, 0),
          duration: wheelController.makeInvisibleStopYourbet.value ? const Duration(milliseconds: 0) : const Duration(milliseconds: 350),
          child: wheelController.makeInvisibleStopYourbet.value
              ? const SizedBox()
              : Image.asset(
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  Assets.imagesStopBetFinal,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }

  Widget placeBetWid() {
    return Center(
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: AnimatedAlign(
          alignment: wheelController.placeYourbetAlign.value == 0
              ? const Alignment(-6.5, 0)
              : wheelController.placeYourbetAlign.value == 1
                  ? const Alignment(0, 0)
                  : const Alignment(6.5, 0),
          duration: wheelController.makeInvisiblePlaceYourbet.value ? const Duration(milliseconds: 0) : const Duration(milliseconds: 350),
          child: wheelController.makeInvisiblePlaceYourbet.value
              ? const SizedBox()
              : Image.asset(
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  Assets.imagesPlaceBetFinal,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }

  Widget resultItemMiddelWid() {
    return Positioned(
      top: -(deviceHeight * 0.076),
      child: Center(
        child: SizedBox(
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(wheelController.resultAlign.value ? deviceHeight * 0.80 : deviceHeight * 0.102),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            duration: const Duration(milliseconds: 250),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /* AnimatedRotation(
                  turns: wheelController.resultRotation.value,
                  duration: const Duration(milliseconds: 3000),
                  child: SizedBox(
                    height: deviceHeight * 0.80,
                    width: deviceHeight * 0.80,
                    child: Image.asset(
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      Assets.imagesPngwing,
                      fit: BoxFit.fill,
                    ),
                  ),
                ), */
                Lottie.asset(
                  Assets.lottieJsonsStars,
                  height: deviceHeight,
                  width: deviceHeight,
                  fit: BoxFit.cover,
                ),
                /* Lottie.asset(
                  Assets.lottieJsonsWave,
                  height: deviceHeight,
                  width: deviceHeight,
                  fit: BoxFit.cover,
                ), */
                Positioned(
                  top: deviceHeight * 0.127,
                  child: SizedBox(
                    height: deviceHeight * 0.40,
                    width: deviceHeight * 0.40,
                    child: Image.asset(
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      wheelController.getitemImagePathRecord(wheelController.whereTOStopCount.value),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: deviceHeight * 0.255,
                  child: SizedBox(
                    height: deviceHeight * 0.60,
                    width: deviceHeight * 0.70,
                    child: Image.asset(
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      wheelController.getitemImagePathRibbin(wheelController.whereTOStopCount.value),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: deviceHeight * 0.15,
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: deviceHeight * 0.3),
                    height: deviceHeight * 0.60,
                    width: deviceHeight * 0.70,
                    child: SizedBox(
                      height: deviceHeight * 0.15,
                      child: Image.asset(
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        getHowManyXAssetPath,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                /* BorderedText(
                  strokeColor: const Color.fromARGB(255, 239, 217, 134),
                  strokeWidth: 3.5,
                  child: Text(
                    wheelController.whereTOStopCount.value == 9
                        ? "Frog"
                        : wheelController.getitemNameRecord(wheelController.whereTOStopCount.value),
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 25,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                ), */
                /* Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: SizedBox(
                    height: deviceHeight * 0.20,
                    width: deviceHeight * 0.20,
                    child: Image.asset(
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      Assets.imagesSixx,
                      fit: BoxFit.fill,
                    ),
                  ),
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get getHowManyXAssetPath {
    if (getCoinValueWithX(wheelController.whereTOStopCount.value) == 6) {
      return Assets.imagesSixx;
    } else if (getCoinValueWithX(wheelController.whereTOStopCount.value) == 8) {
      return Assets.imagesEightx;
    } else if (getCoinValueWithX(wheelController.whereTOStopCount.value) == 12) {
      return Assets.imagesTwelvex;
    } else if (getCoinValueWithX(wheelController.whereTOStopCount.value) == 24) {
      return Assets.imagesTwentyfourx;
    } else if (getCoinValueWithX(wheelController.whereTOStopCount.value) == 50) {
      return Assets.imagesFiftyx;
    }

    return "";
  }
}
