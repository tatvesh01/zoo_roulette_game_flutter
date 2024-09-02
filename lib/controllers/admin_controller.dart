import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoo_zimba/globles.dart';

import '../models/user_data_model.dart';
import '../models/withdraw_model.dart';

String viewAllKey = "View All";
String viewLessKey = "View Less";

class AdminController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPlay = false.obs;
  RxInt whereTOStopCount = Random().nextInt(10).obs;
  RxInt cycleNo = 0.obs;
  RxInt currentSec = 0.obs;
  List<StreamSubscription> streams = [];
  StreamSubscription? userBettingStream;
  final database = FirebaseDatabase.instance.ref();
  FocusNode ipNode = FocusNode();
  TextEditingController connectionIp = TextEditingController();
  late Timer every15sec;
  late Timer every1sec;
  RxList userDataList = RxList();
  // RxList<WithdrawItem> withdrawItemList = RxList();
  RxList<UserDataModel> allUserDataList = RxList();
  /////================================================Model Version======RecordList============================================
  /*  RxList<RecordItem> recordItemsList = RxList(); */
  /////================================================int Version======RecordList============================================
  RxList<int> recordItemsList = RxList();
  Timer? onlineUsersCountTimer;
  RxInt onlineUsersCount = (Random().nextInt(96) + 67).obs;
  RxString currentActionPlayerId = "".obs;
  Rx<WithdrawItem> currentActionItem = WithdrawItem().obs;
  RxBool recordDialogAlign = false.obs;
  RxList<String> viewAllText = RxList();

  @override
  void onInit() {
    super.onInit();
    onlineUsersCountTimer != null && onlineUsersCountTimer!.isActive ? onlineUsersCountTimer!.cancel() : null;
    streams = [
      database.child(whereTOStopKey).onValue.listen((event) {
        debugPrint('EVENT.SNAPSHOT.VALUE: ${event.snapshot.value}');
        whereTOStopCount(
            event.snapshot.value.runtimeType == int ? event.snapshot.value as int : whereTOStopCount.value);
      }, onError: (error) {
        debugPrint('whereTOStop ERROR: $error');
        // Error.
      }),
    ];
   
   
   */
  }

  void actionBTNCall({required String playerIden, required String reqNo, required String wStatus}) {
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        /* debugPrint('CHILD: ${child.value}'); */
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerIden) {
            List<WithdrawItem> withdrawItemList = jsonDecode(jsonEncode(child.child(withdrawListKey).value)) != null
                ? List<WithdrawItem>.from(
                    jsonDecode(jsonEncode(child.child(withdrawListKey).value)).map((x) => WithdrawItem.fromJson(x)))
                : const <WithdrawItem>[];
            for (var i = 0; i < withdrawItemList.length; i++) {
              if (reqNo == withdrawItemList[i].no) {
                debugPrint('WITHDRAWITEMLIST.length: ${withdrawItemList.length}');
                debugPrint('WITHDRAWITEMLIST no: ${withdrawItemList[i].no}');
                debugPrint('WITHDRAWITEMLIST amount: ${withdrawItemList[i].amount}');

                /* debugPrint('INDEXOFSELECTEDITEM: $indexOFSelectedItem'); */
                final selectedItemAmountDataSnapshot = child.child(withdrawListKey).child(i.toString());
                /*  debugPrint('SELECTEDITEMINDEX: $selecteditemIndex');
              debugPrint('SELECTEDITEMAMOUNTDATASNAPSHOT.VALUE: ${selectedItemAmountDataSnapshot.value}');
              debugPrint('+++GETITEMNAME(SELECTEDITEMINDEX): ${getitemName(selecteditemIndex)}');
              debugPrint('+++GETITEMAMOUNT(SELECTEDITEMINDEX): ${getitemAmount(selecteditemIndex)}'); */
                if (selectedItemAmountDataSnapshot.value != null &&
                    selectedItemAmountDataSnapshot.child(WithdrawItem.noKey).value == withdrawItemList[i].no &&
                    selectedItemAmountDataSnapshot.child(WithdrawItem.amountKey).value == withdrawItemList[i].amount) {
                  selectedItemAmountDataSnapshot.ref.update({WithdrawItem.statusKey: wStatus});
                  recordDialogAlign(!recordDialogAlign.value);
                  Future.delayed(const Duration(milliseconds: 300), () => getWithDrawRequestList());
                }
              }
            }
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(users).get() ERROR: $error');
    });
  }

  void getWithDrawRequestList() {
    debugPrint('EVENT: 21221');
    database.child(usersKey).get().then((event) {
      debugPrint('EVENT: ${event.value}');
      List<UserDataModel> tempAllUserDataList = jsonDecode(jsonEncode(event.value)) != null
          ? List<UserDataModel>.from(jsonDecode(jsonEncode(event.value)).map((x) => UserDataModel.fromJson(x)))
          : [];
      allUserDataList(tempAllUserDataList);
      viewAllText = List.filled(allUserDataList.length, viewAllKey).obs;
      /*   for (var i = 0; i < tempAllUserDataList.length; i++) {
        DataSnapshot? getRefOFPlayerElement;
        try {
          withdrawItemList(tempAllUserDataList[i].withdrawListItems);
          debugPrint('pela WITHDRAWITEMLIST: $withdrawItemList');

          debugPrint('pa6i WITHDRAWITEMLIST: ${withdrawItemList.length}');
          getRefOFPlayerElement = event.children
              .where((element) => element.child(playerIdkey).value == tempAllUserDataList[i].playerId)
              .first;
        } catch (e) {
          getRefOFPlayerElement = null;
          debugPrint('event.children.where Error: $e');
        }
        if (getRefOFPlayerElement != null) {
          database.child(usersKey).child(getRefOFPlayerElement.key.toString()).update({
            // withdrawListKey: [...tempWithdrawList]
          });
        }
      } */
    }, onError: (error) {
      debugPrint(' database.child(usersKey).get() ERROR: $error');
    });
  }

  void onlineUsersCountUpdateMathod() {
    onlineUsersCountTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      onlineUsersCount((Random().nextInt(32) + 67));
      database.update({onlineUsersCountKey: onlineUsersCount.value});
    });
  }

  int getCoinValueWithX(indexOFItem) {
    switch (indexOFItem) {
      case 0:
        return 6;
      case 1:
        return 8;
      case 2:
        return 12;
      case 3:
        return 8;
      case 4:
        return 24;
      case 5:
        return 8;
      case 6:
        return 6;
      case 7:
        return 8;
      case 8:
        return 12;
      case 9:
        return 50;
      default:
        return 0;
    }
  }
  // wheelPartsTransSwallow 6x
// wheelPartsTransMonkey   8x
// wheelPartsTransEagle    12x
// wheelPartsTransPanda    8x
// wheelPartsTransShark    24x
// wheelPartsTransPeacock   8x
// wheelPartsTransRabbit   6x
// wheelPartsTransPigeon   8x
// wheelPartsTransLion   12x
// wheelPartsTransFrog   50x

  @override
  void onClose() {
    try {
      for (var it in streams) {
        it.cancel();
      }
    } catch (e) {
      debugPrint('E: $e');
    }
    try {
      every15sec.cancel();
    } catch (e) {
      debugPrint('E: $e');
    }
    try {
      every1sec.cancel();
    } catch (e) {
      debugPrint('E: $e');
    }
    onlineUsersCountTimer != null && onlineUsersCountTimer!.isActive ? onlineUsersCountTimer!.cancel() : null;
    super.onClose();
  }

  @override
  void dispose() {
    onlineUsersCountTimer != null && onlineUsersCountTimer!.isActive ? onlineUsersCountTimer!.cancel() : null;
    super.dispose();
  }
}
