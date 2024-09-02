import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zoo_zimba/generated/assets.dart';
import 'package:zoo_zimba/globles.dart';
import 'package:zoo_zimba/models/bet_count_on_each.dart';
import 'package:zoo_zimba/models/record_item_model.dart';
import 'package:zoo_zimba/models/wheel_item_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:zoo_zimba/models/wheretostopmodel.dart';
import '../models/selected_item_model.dart';
import 'aw_dialog_controller.dart';

extension GetBetItemName on String {
  String getBetItemNameValue() {
    String rawString = this;
    return rawString.split("/").last.split(".").first;
  }
}

class WheelController extends GetxController with GetTickerProviderStateMixin {
  CommonDialogController commonDialogController = Get.find();
  final coinAudioPlayer = AudioPlayer();
  final wheelAudioPlayer = AudioPlayer();
  final tick321AudioPlayer = AudioPlayer();
  final sumSumAudioPlayer = AudioPlayer();
  final resultAudioPlayer = AudioPlayer();
  RxBool isItemWidUpdate = false.obs;
  RxInt whereTOStopCount = 0.obs;
  RxBool canPlayerBet = false.obs;
  RxBool canFrameShow = false.obs;
  RxBool canlightedShow = false.obs;
  late Timer palceBetTimer1Sec;
  RxInt palceBetTimer1SecCountDown = 10.obs;
  RxInt selectedCoin = 1.obs;
  RxList<SelectedItem> selectedItems = RxList();
  RxList<RecordItem> recordItemsList = RxList();
  List<StreamSubscription> streams = [];
  final database = FirebaseDatabase.instance.ref();
  RxList<WheelItem> fortuneValues = <WheelItem>[
    WheelItem(imgpath: Assets.wheelPartsTransSwallow, bgColor: const Color(0xFFff0000)),
    WheelItem(imgpath: Assets.wheelPartsTransMonkey, bgColor: const Color(0xFF2d3f98)),
    WheelItem(imgpath: Assets.wheelPartsTransEagle, bgColor: const Color(0xFFef008f)),
    WheelItem(imgpath: Assets.wheelPartsTransPanda, bgColor: const Color(0xFFf7901f)),
    WheelItem(imgpath: Assets.wheelPartsTransShark, bgColor: const Color(0xFF46bb8f)),
    WheelItem(imgpath: Assets.wheelPartsTransPeacock, bgColor: const Color(0xFF85459a)),
    WheelItem(imgpath: Assets.wheelPartsTransRabbit, bgColor: const Color(0xFFfef100)),
    WheelItem(imgpath: Assets.wheelPartsTransPigeon, bgColor: const Color(0xFF0094dc)),
    WheelItem(imgpath: Assets.wheelPartsTransLion, bgColor: const Color(0xFFbadd49)), //badd49
    WheelItem(imgpath: Assets.wheelPartsTransFrog, bgColor: const Color(0xFFbadd49)), //badd49
  ].obs;
  DataSnapshot? getRefOFPlayerElement;
  StreamSubscription? userBettingStream;
  String playerId = Get.arguments[0];
  RxInt userBalance = 0.obs;
  RxString afterWinOrLossAmount = "".obs;
  RxBool isPlayingCoin = false.obs;
  RxBool isPlayingWheel = false.obs;
  RxBool isPlayingTick321 = false.obs;

  Rx<Duration> coinDuration = Duration.zero.obs;
  Rx<Duration> coinPosition = Duration.zero.obs;
  Rx<Duration> wheelDuration = Duration.zero.obs;
  Rx<Duration> wheelPosition = Duration.zero.obs;
  Rx<Duration> tick321Duration = Duration.zero.obs;
  Rx<Duration> tick321Position = Duration.zero.obs;
  Rx<Duration> sumSumDuration = Duration.zero.obs;
  Rx<Duration> sumSumPosition = Duration.zero.obs;
  Rx<Duration> resultDuration = Duration.zero.obs;
  Rx<Duration> resultPosition = Duration.zero.obs;
  Timer? bumbardmentTimer;
  Timer? showFrameTimer;
  RxInt placeYourbetAlign = 0.obs;
  RxInt stopYourbetAlign = 0.obs;
  RxBool makeInvisiblePlaceYourbet = false.obs;
  RxBool makeInvisibleStopYourbet = false.obs;
  // RxDouble resultAlign = 30.0.obs;
  RxDouble resultRotation = 0.0.obs;
  RxBool resultAlign = true.obs;
  RxBool coinAnimationBool = false.obs;
  RxBool coinAnimationBool2 = false.obs;
  RxBool coinAnimationBool3 = false.obs;
  RxBool coinAnimationBoolUser = false.obs;
  RxBool makeInvisibleCoinAnimationUser = false.obs;
  RxInt selectedCurrentItemIndex = 0.obs;
  RxBool makeInvisibleCoinAnimation = false.obs;
  RxBool doesShowAllCoins = false.obs;
  RxBool makeInvisibleCoinAnimation2 = false.obs;
  RxBool makeInvisibleCoinAnimation3 = false.obs;
  RxList<List<Widget>> coinAnimationList = RxList();
  RxDouble wheelTurn = 0.0.obs;
  Rx<Duration> wheelAnimDuration = Duration.zero.obs;
  Timer? wheelAnimTimer;
  Timer? balanceUpdateAnimTimer;
  RxInt onlineUsersCount = (math.Random().nextInt(96) + 67).obs;
  RxInt balanceUpdateAnimAlign = 0.obs;
  RxInt totalPlaceAmount = 0.obs;
  RxBool makeInvisiblebalanceUpdate = false.obs;
  RxBool tick321Align = true.obs;
  RxInt tick321AlignAnim = 0.obs;
  RxBool makeInvisibleTick321 = false.obs;
  late VideoPlayerController hintVidcontroller;
  RxBool ishintVidcontrollerReady = false.obs;
  RxBool hintDialogAlign = false.obs;
  RxBool hintTextDialogAlign = false.obs;
  RxBool upiDialogAlign = false.obs;
  Rx<BetCountOnEach> betCountOnEach = BetCountOnEach().obs;
  bool isFirstTime = false;
  RxBool checkFirstTimeForCanBet = false.obs;
  int howManyTime = 1;
  int firstTimeWinBalance = 0;
  RxBool isJustEnterInGame = true.obs;
  RxBool isFirstTimeInWheelScreen = false.obs;
  RxString hintVideoUrl = "".obs;

  void handleRoll() {
    debugPrint('wheelTurn.VALUE: ${wheelTurn.value}');
    wheelAnimTimer != null && wheelAnimTimer!.isActive ? wheelAnimTimer!.cancel() : null;
    wheelAnimDuration(const Duration(seconds: 8));
    wheelTurn((26 - (whereTOStopCount.value / 10)));
    debugPrint('(26 - (whereTOStopCount.value / 10)) WHERETOSTOPCOUNT.VALUE: ${whereTOStopCount.value}');
    debugPrint('(26 - (whereTOStopCount.value / 10)): ${(26 - (whereTOStopCount.value / 10))}');
  }

  void handleRollOnStopResult() {
    wheelAnimDuration(
      Duration.zero,
    );
    wheelTurn(0);
  }

  RxBool isAnimating = false.obs;

  @override
  void onInit() async {
    super.onInit();

    bumbardmentTimer != null && bumbardmentTimer!.isActive ? bumbardmentTimer!.cancel() : null;
    showFrameTimer != null && showFrameTimer!.isActive ? showFrameTimer!.cancel() : null;
    balanceUpdateAnimTimer != null && balanceUpdateAnimTimer!.isActive ? balanceUpdateAnimTimer!.cancel() : null;
    initializHintVideo();
    getRefOFPlayerElementMethod().then((value) {
      try {
        /////================================================int Version======RecordList============================================

        database.child(last20RecordListKey).get().then((event) {
          debugPrint('+-+-+-+- EVENT: ${event.value}');
          debugPrint('+-+-+-+- EVENT: ${event.value.runtimeType}');
          if (event.children.isNotEmpty) {
            for (final child in event.children) {
              debugPrint('+-+-+-+-CHILD.value: ${child.value}');
              debugPrint('+-+-+-+-CHILD.key: ${child.key}');
              debugPrint('CHILD.VALUE.RUNTIMETYPE: ${child.value.runtimeType}');
              int tempIndexofRecord = child.value.runtimeType == int ? child.value as int : 0;
              recordItemsList.add(
                RecordItem(
                  recordItemIndexByWheel: tempIndexofRecord,
                  recordItemName: getitemNameRecord(tempIndexofRecord),
                  recordItemImgpath: getitemImagePathRecord(
                    tempIndexofRecord,
                  ),
                ),
              );
            }
          }
        }, onError: (error) {
          debugPrint(' database.child(last20RecordList).get() ERROR: $error');
        });
      } catch (e) {
        debugPrint('last20RecordList E: $e');
      }
      checkIsFirstTimeInWheelScreen();

      setCoinAudio();
      setWheelAudio();
      setTick321Audio();
      setSumSumAudio();
      setResultAudio();
      streams = [
        database.child(whereTOStopObjKey).onValue.listen((event) {
          debugPrint('====================$whereTOStopObjKey===============');
          debugPrint('+-+-+-+-+-+-+-+-+-+-whereTOStopKey: ${event.snapshot.value}');
          WhereToStopObj whereToStopObj = jsonDecode(jsonEncode(event.snapshot.value)) != null
              ? WhereToStopObj.fromJson(jsonDecode(jsonEncode(event.snapshot.value)))
              : WhereToStopObj();
          bool canBalanceUpdate = true;
          int selectedItemsIndx = 0;
          if (isFirstTime) {
            try {
              selectedItemsIndx = math.Random().nextInt(selectedItems.length - 1);
              whereTOStopCount(selectedItems[selectedItemsIndx].selectedItemIndex);
              debugPrint('+-+-+-+-+-+-+-+-+-+-if (isFirstTime) try WHERETOSTOPCOUNT: ${whereTOStopCount.value}');
            } catch (e) {
              debugPrint('+-+-+-+-+-+-+-+-+-+-isFirstTime whereTOStopCount Error: $e');
              try {
                whereTOStopCount(selectedItems[selectedItemsIndx].selectedItemIndex);
                debugPrint('+-+-+-+-+-+-+-+-+-+-if (isFirstTime) catch try WHERETOSTOPCOUNT: ${whereTOStopCount.value}');
              } catch (e) {
                debugPrint('+-+-+-+-+-+-+-+-+-+-isFirstTime catch whereTOStopCount Error: $e');
                canBalanceUpdate = false;
              }
            }
            debugPrint('+-+-+-+-+-+-+-+-+-+-CANBALANCEUPDATE: $canBalanceUpdate');
            if (canBalanceUpdate) {
              firstTimeWinBalanceUpdateMethod(whereTOStopCount.value);
              checkIsPlayerFirstTime2();
            }
          } else {
            whereTOStopCount(whereToStopObj.whereToStop);
          }
        }),
        database.child(onlineUsersCountKey).onValue.listen((event) {
          debugPrint('onlineUsersCountKey EVENT.SNAPSHOT.VALUE: ${event.snapshot.value}');
          onlineUsersCount(event.snapshot.value.runtimeType == int ? event.snapshot.value as int : (math.Random().nextInt(96) + 67));
        }),
        database.child(currentEventKey).onValue.listen((event) {
          try {
            onAnyEvent(event.snapshot.value.toString());
          } catch (e) {
            debugPrint('onAnyEvent E: $e');
          }
        }),
        
        /* //AudioPlayer Code
      coinAudioPlayer.onPlayerStateChanged.listen((state) {
        isPlayingCoin(state == PlayerState.playing);
        debugPrint('isPlayingCoin.VALUE: ${isPlayingCoin.value}');
      }),
      coinAudioPlayer.onDurationChanged.listen((newDuration) {
        coinDuration(newDuration);
      }),
      coinAudioPlayer.onPositionChanged.listen((newPosition) {
        coinPosition(newPosition);
        debugPrint('coinPOSITION: $newPosition');
      }),
      //wheel
      wheelAudioPlayer.onPlayerStateChanged.listen((state) {
        isPlayingWheel(state == PlayerState.playing);
        debugPrint('isPlayingWheel.VALUE: ${isPlayingWheel.value}');
      }),
      wheelAudioPlayer.onDurationChanged.listen((newDuration) {
        wheelDuration(newDuration);
      }),
      wheelAudioPlayer.onPositionChanged.listen((newPosition) {
        wheelPosition(newPosition);
        debugPrint('wheelPOSITION: $newPosition');
      }),
      //Tick321
      tick321AudioPlayer.onPlayerStateChanged.listen((state) {
        isPlayingTick321(state == PlayerState.playing);
        debugPrint('isPlayingtick321.VALUE: ${isPlayingTick321.value}');
      }),
      tick321AudioPlayer.onDurationChanged.listen((newDuration) {
        tick321Duration(newDuration);
      }),
      tick321AudioPlayer.onPositionChanged.listen((newPosition) {
        tick321Position(newPosition);
        debugPrint('tick321POSITION: $newPosition');
      }), */
        /* audioPlayer.onPlayerComplete.listen((value) {
      }), */
        /*  audioPlayer.onSeekComplete.listen((value) {
      }), */
      ];
      checkIsPlayerFirstTime2();
    });
  }

  Future<void> getRefOFPlayerElementMethod() async {
    database.child(usersKey).get().then((event) {
      try {
        getRefOFPlayerElement = event.children.where((element) => element.child(playerIdkey).value == playerId).first;
        // debugPrint('getRefOFPlayerElementForBalance: ${getRefOFPlayerElement!.value}');
        debugPrint('getRefOFPlayerElementForBalance: ${getRefOFPlayerElement!.key}');
      } catch (e) {
        debugPrint('wheel controller event.children.where Error: $e');
        getRefOFPlayerElement = null;
      }
    }, onError: (error) {
      debugPrint(' database.child(users).get() onInit ERROR: $error');
    });
  }

  Future<void> initializHintVideo() async {
    database.child(hintVideoUrlKey).get().then((event) {
      debugPrint('+-+-+-+- EVENT: ${event.value}');
      debugPrint('+-+-+-+- EVENT: ${event.value.runtimeType}');
      try {
        hintVideoUrl(event.value.toString());
      } catch (e) {
        debugPrint('hintVideoUrl event.value.toString() E: $e');
      }
    }, onError: (error) {
      debugPrint(' database.child(last20RecordList).get() ERROR: $error');
    }).then((value) => hintVidcontroller = VideoPlayerController.network(
          hintVideoUrl.value,
        )..initialize().then((_) {
            ishintVidcontrollerReady(true);
            hintVidcontroller.pause();
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          }));
  }

  void firstTimeWinBalanceUpdateMethod(int selectedItemsIndx) {
    
  }

  void updateBetArreyByPlayerId({
    required Map<String, Object?> selectedBetItemsMap,
    required int selecteditemIndex,
    /* required String PlayerId */
  }) {
    checkIsPlayerFirstTime();
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        /* debugPrint('CHILD: ${child.value}'); */
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId) {
            
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(users).get() ERROR: $error');
    });
  }

  void checkIsPlayerFirstTime() {
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId) {
            if (child.child(isFirstTimeKey).value == null) {
              final isFirstTimeKeyDataSnapshot = child;
              isFirstTimeKeyDataSnapshot.ref.update({isFirstTimeKey: 1});
              isFirstTime = true;
              log('checkIsPlayerFirstTime CHILD.CHILD(ISFIRSTTIMEKEY).VALUE: ${child.child(isFirstTimeKey).value}');
            }
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(usersKey).child(playerIdkey).get() ERROR: $error');
    });
  }

  Future<void> checkIsPlayerFirstTime2() async {
    await database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId) {
            checkFirstTimeForCanBet(child.child(isFirstTimeKey).value == null);
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(usersKey).child(playerIdkey).get() ERROR: $error');
    });
  }

  void checkIsFirstTimeInWheelScreen() {
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        /* debugPrint('CHILD: ${child.value}'); */
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId) {
            debugPrint('userCurrentBalanceKey $userCurrentBalanceKey:- ${child.child(userCurrentBalanceKey).value}');
            if (child.child(userCurrentBalanceKey).value.runtimeType == int) {
              debugPrint(
                  'EVENT.VALUE.RUNTIMETYPE == INT: ${child.child(userCurrentBalanceKey).value.runtimeType == int}+-+- ${child.child(userCurrentBalanceKey).value}');
              userBalance(child.child(userCurrentBalanceKey).value as int);
            }
            if (child.child(isFirstTimeInWheelScreenKey).value == null) {
              final isFirstTimeInWheelScreenKeyDataSnapshot = child;
              isFirstTimeInWheelScreenKeyDataSnapshot.ref.update({isFirstTimeInWheelScreenKey: 1});
              isFirstTimeInWheelScreen(true);
              log('CHILD.CHILD(isFirstTimeInWheelScreenKey).VALUE: ${child.child(isFirstTimeInWheelScreenKey).value}');
              // isFirstTimeInWheelScreenKeyDataSnapshot.ref.update({userCurrentBalanceKey: 50});
            }
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(usersKey).child(playerIdkey).get() ERROR: $error');
    });
  }

  void onAnyEvent(String eventval) {
    if (isJustEnterInGame.value && eventval == EventStatus.stopResult.name) {
      isJustEnterInGame(false);
    }
  }

  void afterwinOrLossUpdateBalance(String tempAfterWinOrLossAmountKey, String tempUserCurrentBalanceKey) {
    database.child(usersKey).child(getRefOFPlayerElement!.key.toString()).child(tempAfterWinOrLossAmountKey).get().then((event) {
      debugPrint('tempAfterWinOrLossAmountKey $tempAfterWinOrLossAmountKey:- ${event.value}');
      if (event.value.runtimeType == String) {
        debugPrint('EVENT.VALUE.RUNTIMETYPE == INT: ${event.value.runtimeType == String}+-+- ${event.value}');
        afterWinOrLossAmount(event.value as String);
        // /users/1/selectedBetItems

      }
    }, onError: (error) {
      debugPrint('database.child(usersKey).get() onInit ERROR: $error');
    }).then((value) {
      database.child(usersKey).child(getRefOFPlayerElement!.key.toString()).child(tempUserCurrentBalanceKey).get().then((event) {
        debugPrint('tempUserCurrentBalanceKey $tempUserCurrentBalanceKey:- ${event.value}');
        if (event.value.runtimeType == int) {
          debugPrint('EVENT.VALUE.RUNTIMETYPE == INT: ${event.value.runtimeType == int}+-+- ${event.value}');
          userBalance(event.value as int);
          // /users/1/selectedBetItems
         
        }
        if (afterWinOrLossAmount.value.isNotEmpty && afterWinOrLossAmount.value != "0") {
          userBalanceUpdateAnimMethod();
          totalPlaceAmount(0);
          if (selectedItems.isNotEmpty) {
            for (var j = 0; j < selectedItems.length; j++) {
              totalPlaceAmount.value += selectedItems[j].selectedItemAmount;
            }
          }
        }
      }, onError: (error) {
        debugPrint('database.child(usersKey).get() onInit ERROR: $error');
      });
    });
  }

  int getCoinValue() {
    switch (selectedCoin.value) {
      case 1:
        return 10;
      case 2:
        return 50;
     
      case 6:
        return 5000;
      case 7:
        return 10000;
      default:
        return 0;
    }
  }

  int getitemAmount(int i) {
    int amount = 0;
    for (var indx = 0; indx < selectedItems.length; indx++) {
      if (selectedItems[indx].selectedItemIndex == i) {
        amount = selectedItems[indx].selectedItemAmount;
      }
    }
    return amount;
  }

  String getitemName(int i) {
    String itemName = '';
    for (var indx = 0; indx < selectedItems.length; indx++) {
      if (selectedItems[indx].selectedItemIndex == i) {
        itemName = selectedItems[indx].selectedItemName;
      }
    }

    return itemName;
  }

  String getitemImagePathRecord(int index) {
    String itemName = '';
    for (var i = 0; i < recordItemsPathList.length; i++) {
      if (recordItemsPathList[i].getBetItemNameValue() == fortuneValues[index].imgpath.getBetItemNameValue()) {
        itemName = recordItemsPathList[i];
      }
    }
    return itemName;
  }

  String getitemImagePathRibbin(int index) {
    String itemName = '';
    for (var i = 0; i < ribbinItemsPathList.length; i++) {
      if (ribbinItemsPathList[i].getBetItemNameValue() == fortuneValues[index].imgpath.getBetItemNameValue()) {
        itemName = ribbinItemsPathList[i];
      }
    }
    return itemName;
  }

  String getitemNameRecord(int index) {
    String itemName = '';
    for (var i = 0; i < recordItemsPathList.length; i++) {
      if (recordItemsPathList[i].getBetItemNameValue().toLowerCase() == fortuneValues[index].imgpath.getBetItemNameValue().toLowerCase()) {
        itemName = recordItemsPathList[i].getBetItemNameValue();
      }
    }
    return itemName;
  }

  Future<void> setCoinAudio() async {
    //Repeat Song when Completed
    await coinAudioPlayer.setReleaseMode(ReleaseMode.stop);

    String coinAudioPath = Assets.audiosKhanak;
    setCoinSource(AssetSource(coinAudioPath)).then((value) {
      // audioPlayer.resume();
    });
    coinPosition.value = (await coinAudioPlayer.getCurrentPosition()) ?? Duration.zero;
  }

  Future<void> setCoinSource(Source source) async {
    await coinAudioPlayer.setSource(source);
    debugPrint('Completed setting source.');
  }

  //wheel
  Future<void> setWheelAudio() async {
    //Repeat Song when Completed
    await wheelAudioPlayer.setReleaseMode(ReleaseMode.stop);
    String wheelAudioPath = Assets.audiosWheelSound;
    setWheelSource(AssetSource(wheelAudioPath)).then((value) {
      // audioPlayer.resume();
    });
    wheelPosition.value = (await wheelAudioPlayer.getCurrentPosition()) ?? Duration.zero;
  }

  Future<void> setWheelSource(Source source) async {
    await wheelAudioPlayer.setSource(source);
    debugPrint('Completed setting source.');
  }

  //tick321
  Future<void> setTick321Audio() async {
    //Repeat Song when Completed
    await tick321AudioPlayer.setReleaseMode(ReleaseMode.stop);
    String tick321AudioPath = Assets.audiosTickTickTick;
    setTick321Source(AssetSource(tick321AudioPath)).then((value) {
      // audioPlayer.resume();
    });
    tick321Position.value = (await tick321AudioPlayer.getCurrentPosition()) ?? Duration.zero;
  }

  Future<void> setTick321Source(Source source) async {
    await tick321AudioPlayer.setSource(source);
    debugPrint('Completed setting source.');
  }

  //sumSum
  Future<void> setSumSumAudio() async {
    //Repeat Song when Completed
    await sumSumAudioPlayer.setReleaseMode(ReleaseMode.stop);
    String sumSumAudioPath = Assets.audiosSumSum4;
    setSumSumSource(AssetSource(sumSumAudioPath)).then((value) {
      // audioPlayer.resume();
    });
    sumSumPosition.value = (await sumSumAudioPlayer.getCurrentPosition()) ?? Duration.zero;
  }

  Future<void> setSumSumSource(Source source) async {
    await sumSumAudioPlayer.setSource(source);
    debugPrint('Completed setting source.');
  }

  //Result
  Future<void> setResultAudio() async {
    //Repeat Song when Completed
    await resultAudioPlayer.setReleaseMode(ReleaseMode.stop);
    String resultAudioPath = Assets.audiosResult;
    setResultSource(AssetSource(resultAudioPath)).then((value) {
      // audioPlayer.resume();
    });
    resultPosition.value = (await resultAudioPlayer.getCurrentPosition()) ?? Duration.zero;
  }

  Future<void> setResultSource(Source source) async {
    await resultAudioPlayer.setSource(source);
    debugPrint('Completed setting source.');
  }

  void blinkingFrameTimerMethod() {
    
  }

  void placeYourbetAnimation() {
    debugPrint('PLACEYOURBETALIGN.VALUE: ${placeYourbetAlign.value}');
    if (placeYourbetAlign.value > 1) {
      resetPlaceYourBetAnimation();
    } else {
      sumSumAudioPlayer.stop();
      sumSumAudioPlayer.resume();
      makeInvisiblePlaceYourbet(false);
      placeYourbetAlign(1);
      Future.delayed(const Duration(milliseconds: 1000), () {
        placeYourbetAlign(2);
        Future.delayed(const Duration(milliseconds: 500), () {
          resetPlaceYourBetAnimation();
        });
      });
    }
  }

  void stopYourbetAnimation() {
    debugPrint('StopYOURBETALIGN.VALUE: ${stopYourbetAlign.value}');
    if (stopYourbetAlign.value > 1) {
      resetStopYourBetAnimation();
    } else {
      sumSumAudioPlayer.stop();
      sumSumAudioPlayer.resume();
      makeInvisibleStopYourbet(false);
      stopYourbetAlign(1);
      Future.delayed(const Duration(milliseconds: 1000), () {
        stopYourbetAlign(2);
        Future.delayed(const Duration(milliseconds: 500), () {
          resetStopYourBetAnimation();
        });
      });
    }
  }

  void resetPlaceYourBetAnimation() {
    makeInvisiblePlaceYourbet(true);
    placeYourbetAlign(0);
  }

  void resetStopYourBetAnimation() {
    makeInvisibleStopYourbet(true);
    stopYourbetAlign(0);
  }

  void coinAnimCallMethodUser() {
    debugPrint('COINANIMATIONBOOLUser.VALUE: ${coinAnimationBoolUser.value}');
    if (coinAnimationBoolUser.value) {
      resetCoinAnimationUser();
    } else {
      if (!makeInvisibleCoinAnimationUser.value) {
        coinAnimationBoolUser(true);
        Future.delayed(const Duration(milliseconds: 400), () {
          resetCoinAnimationUser();
        });
      }
    }
  }

  void resetCoinAnimationUser() {
    makeInvisibleCoinAnimationUser(true);
    coinAnimationBoolUser(false);
    Future.delayed(const Duration(milliseconds: 100), () {
      makeInvisibleCoinAnimationUser(false);
    });
  }

  void coinAnimCallMethod() {
    doesShowAllCoins(true);
    debugPrint('COINANIMATIONBOOL.VALUE: ${coinAnimationBool.value}');
    coinAudioPlayer.stop();
    coinAudioPlayer.seek(const Duration(milliseconds: 200));
    bumbardmentTimer = Timer.periodic(const Duration(milliseconds: 650), (t) {
      if (coinAnimationBool.value) {
        resetCoinAnimation();
      } else {
        if (!makeInvisibleCoinAnimation.value) {
          coinAnimationBool(true);
          coinAudioPlayer.resume();
        }
      }
      /* Future.delayed(const Duration(milliseconds: 200), () {
        if (coinAnimationBool2.value) {
          makeInvisibleCoinAnimation2(true);
          coinAnimationBool2(false);
          Future.delayed(const Duration(milliseconds: 100), () {
            makeInvisibleCoinAnimation2(false);
          });
        } else {
          if (!makeInvisibleCoinAnimation2.value) {
            coinAnimationBool2(true);
          }
        }
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (coinAnimationBool3.value) {
          makeInvisibleCoinAnimation3(true);
          coinAnimationBool3(false);
          Future.delayed(const Duration(milliseconds: 100), () {
            makeInvisibleCoinAnimation3(false);
          });
        } else {
          if (!makeInvisibleCoinAnimation3.value) {
            coinAnimationBool3(true);
          }
        }
      }); */
      /*  Future.delayed(const Duration(seconds: 10), () {
        t.isActive ? t.cancel() : null;
        Future.delayed(const Duration(seconds: 1), () {
          resetCoinAnimation();
        });
        // isPlaying.value ? audioPlayer.stop() : null;
      }); */
    });
  }

  void resetCoinAnimation() {
    coinAudioPlayer.stop();
    coinAudioPlayer.seek(const Duration(milliseconds: 200));
    makeInvisibleCoinAnimation(true);
    coinAnimationBool(false);
    Future.delayed(const Duration(milliseconds: 300), () {
      makeInvisibleCoinAnimation(false);
    });
  }

  void resultMidWidShowHide() {
    resultAlign(!resultAlign.value);
    debugPrint('RESULTROTATION.VALUE: ${resultRotation.value}');
    if (resultRotation.value == 0) {
      resultRotation(3);
    } else {
      resultRotation(0);
    }
    Future.delayed(const Duration(seconds: 3), () {
      resultAlign(true);
      debugPrint('RESULTROTATION.VALUE: ${resultRotation.value}');
      if (resultRotation.value == 0) {
        resultRotation(3);
      } else {
        resultRotation(0);
      }
    });
  }

  void userBalanceUpdateAnimMethod() {
    balanceUpdateAnimTimer != null && balanceUpdateAnimTimer!.isActive ? balanceUpdateAnimTimer!.cancel() : null;
    balanceUpdateAnimTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      
      if (t.tick == 7) {
        balanceUpdateAnimTimer != null && balanceUpdateAnimTimer!.isActive ? balanceUpdateAnimTimer!.cancel() : null;
      }
    });
  }

  DynamicBorderSide startBorder = DynamicBorderSide(
      width: 15,
      begin: 0.toPercentLength,
      end: 0.toPercentLength,
      gradient: const SweepGradient(startAngle: math.pi, colors: [Colors.white, Colors.white]),
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round);
  DynamicBorderSide middleBorder = DynamicBorderSide(
      width: 15,
      begin: 0.toPercentLength,
      end: 50.toPercentLength,
      shift: 50.toPercentLength,
      gradient: const SweepGradient(startAngle: math.pi, colors: [Colors.white, Colors.white]),
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round);
  DynamicBorderSide endBorder = DynamicBorderSide(
      width: 15,
      begin: 100.toPercentLength,
      end: 100.toPercentLength,
      shift: 100.toPercentLength,
      gradient: const SweepGradient(startAngle: math.pi, colors: [Colors.white, Colors.white]),
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round);

  @override
  void onClose() {
    super.onClose();
    for (var it in streams) {
      it.cancel();
    }
  
    resultAudioPlayer.stop();
    resultAudioPlayer.dispose();
    try {
      palceBetTimer1Sec.cancel();
    } catch (e) {
      debugPrint('onClose Error: $e');
    }
    try {
      hintVidcontroller.dispose();
    } catch (e) {
      debugPrint('onClose Error: $e');
    }
    bumbardmentTimer != null && bumbardmentTimer!.isActive ? bumbardmentTimer!.cancel() : null;
    showFrameTimer != null && showFrameTimer!.isActive ? showFrameTimer!.cancel() : null;
    wheelAnimTimer != null && wheelAnimTimer!.isActive ? wheelAnimTimer!.cancel() : null;
    balanceUpdateAnimTimer != null && balanceUpdateAnimTimer!.isActive ? balanceUpdateAnimTimer!.cancel() : null;
  }

  @override
  void dispose() {
    try {
      hintVidcontroller.dispose();
    } catch (e) {
      debugPrint('onClose Error: $e');
    }
    palceBetTimer1Sec.isActive ? palceBetTimer1Sec.cancel() : null;
    bumbardmentTimer != null && bumbardmentTimer!.isActive ? bumbardmentTimer!.cancel() : null;
    showFrameTimer != null && showFrameTimer!.isActive ? showFrameTimer!.cancel() : null;
    wheelAnimTimer != null && wheelAnimTimer!.isActive ? wheelAnimTimer!.cancel() : null;
    balanceUpdateAnimTimer != null && balanceUpdateAnimTimer!.isActive ? balanceUpdateAnimTimer!.cancel() : null;
    super.dispose();
  }
}
