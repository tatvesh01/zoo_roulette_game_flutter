import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zoo_zimba/controllers/wheel_controller.dart';

import '../Utils/color_helper.dart';
import '../generated/assets.dart';
import '../globles.dart';
import '../models/add_money_model.dart';
import '../models/user_data_model.dart';
import '../models/withdraw_model.dart';

class CommonDialogController extends GetxController {
  RxString playerId = "".obs;
  RxString playerName = "".obs;
  RxString playerImg = "".obs;
  RxBool isloggedIn = false.obs;
  RxBool isAnonymous = false.obs;
  RxBool loader = false.obs;
  final database = FirebaseDatabase.instance.ref();
  RxBool addMoneyWithDrawdialogAlign = false.obs;
  RxInt selectedOptionInDialog = 0.obs;
  RxInt userBalance = 0.obs;
  RxInt minWithdrawLimit = 0.obs;
  RxInt maxWithdrawLimit = 0.obs;
  RxBool recordDialogAlign = false.obs;
  TextEditingController upiAddController = TextEditingController();
  TextEditingController upiNameController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();
  FocusNode upiAddNode = FocusNode();
  FocusNode upiNameNode = FocusNode();
  FocusNode amountNode = FocusNode();
  RxList<AddMoneyItem> addMoneyItemList = RxList();
  RxList<WithdrawItem> withdrawItemList = RxList();
  RxList<WithdrawItem> buyChipsRecordItemList = RxList();
  RxBool upiAddReadOnly = false.obs;
  RxBool upiNameReadOnly = false.obs;
  List<StreamSubscription> streams = [];
  List<AddMoneyItem> buyChipsList = [
    AddMoneyItem(addMoneyChips: "50", addMoneyPrice: "50"),
    AddMoneyItem(addMoneyChips: "100", addMoneyPrice: "100"),
    AddMoneyItem(addMoneyChips: "200", addMoneyPrice: "200"),
    AddMoneyItem(addMoneyChips: "305", addMoneyPrice: "300"),
    AddMoneyItem(addMoneyChips: "510", addMoneyPrice: "500"),
    AddMoneyItem(addMoneyChips: "1020", addMoneyPrice: "1000"),
    AddMoneyItem(addMoneyChips: "5040", addMoneyPrice: "5000"),
    AddMoneyItem(addMoneyChips: "10060", addMoneyPrice: "10000"),
  ];
  DataSnapshot? getRefOFPlayerElement;
  RxString adminUpi = "".obs;
  RxString adminUpiName = "".obs;
  RxString adminUpiDecription = "".obs;
  RxBool isWithdrawDialog = false.obs;

  @override
  void onInit() async {
    initilizeMethod();
    super.onInit();
  }

  void initilizeMethod() {
    playerId(localDataStorage.read(playerIdkey) ?? "");
    playerName(localDataStorage.read(playerNamekey) ?? "");
    playerImg(localDataStorage.read(playerImgkey) ?? "");
    isloggedIn(localDataStorage.read(playerIdkey) != null && localDataStorage.read(playerIdkey).toString().isNotEmpty);
    isAnonymous(localDataStorage.read(isAnonymousKey) != null && localDataStorage.read(isAnonymousKey));
    debugPrint('LOCALDATASTORAGE.READ(playerIdkey): ${localDataStorage.read(playerIdkey)} \n $isloggedIn');
    addMoneyItemList(buyChipsList);
    streams = [
      database.child(usersKey).onValue.listen((event) {
        for (final child in event.snapshot.children) {
          if (child.child(playerIdkey).value != null) {
            if (child.child(playerIdkey).value == playerId.value) {
              if (child.child(userCurrentBalanceKey).value.runtimeType == int) {
                userBalance(child.child(userCurrentBalanceKey).value as int);
                debugPrint('strepams 2.2.2.2.2.2 USERBALANCE: $userBalance');
              }
            }
          }
        }
      }, onError: (error) {
        debugPrint('whereTOStop ERROR: $error');
        // Error.
      }),
    ];
    getMaxMinWithdrawLimits();
    getAddMoneyPriceList();
    getUpiDetails();
    getAdminUpiDetails();
    getWithDrawRequestList();
    super.onInit();
  }

  void getMaxMinWithdrawLimits() {
    database.child(minWithdrawLimitKey).get().then((event) {
      if (event.value.runtimeType == int) {
        minWithdrawLimit(event.value as int);
      }
    }, onError: (error) {
      debugPrint(' database.child(last20RecordList).get() ERROR: $error');
    });
    database.child(maxWithdrawLimitKey).get().then((event) {
      if (event.value.runtimeType == int) {
        maxWithdrawLimit(event.value as int);
      }
    }, onError: (error) {
      debugPrint(' database.child(last20RecordList).get() ERROR: $error');
    });
  }

  void getAdminUpiDetails() {
    database.child(adminUpiDecriptionKey).get().then((event) {
      if (event.value.runtimeType == String) {
        adminUpiDecription(event.value.toString());
      }
    }, onError: (error) {
      debugPrint(' database.child(adminUpiDecriptionKey).get() ERROR: $error');
    });
    database.child(adminUpiNameKey).get().then((event) {
      if (event.value.runtimeType == String) {
        adminUpiName(event.value.toString());
      }
    }, onError: (error) {
      debugPrint(' database.child(adminUpiDecriptionKey).get() ERROR: $error');
    });
    database.child(adminUpiKey).get().then((event) {
      if (event.value.runtimeType == String) {
        adminUpi(event.value.toString());
      }
    }, onError: (error) {
      debugPrint(' database.child(adminUpiDecriptionKey).get() ERROR: $error');
    });
  }

  void getAddMoneyPriceList() {
    try {
      /////================================================buy Chips List============================================

      database.child(addMoneyPriceListKey).get().then((event) {
        List tempAddMoneyList = [];
        for (var i = 0; i < buyChipsList.length; i++) {
          tempAddMoneyList.add(buyChipsList[i].toJson());
        }
        if (event.value == null) {
          database.update({addMoneyPriceListKey: tempAddMoneyList});
        }
        debugPrint('+-+-+-+- EVENT: ${event.value}');
        debugPrint('+-+-+-+- EVENT: ${event.value.runtimeType}');
        if (event.children.isNotEmpty) {
          for (final child in event.children) {
            debugPrint('+-+-+-+-CHILD.value: ${child.value}');
            debugPrint('+-+-+-+-CHILD.key: ${child.key}');
            addMoneyItemList = jsonDecode(jsonEncode(event.value)) != null
                ? List<AddMoneyItem>.from(jsonDecode(jsonEncode(event.value)).map((x) => AddMoneyItem.fromJson(x))).obs
                : const <AddMoneyItem>[].obs;
            debugPrint('ADDMONEYITEMLIST: ${addMoneyItemList[0].toJson()}');
          }
        }
      }, onError: (error) {
        debugPrint(' database.child(last20RecordList).get() ERROR: $error');
      });
    } catch (e) {
      debugPrint('last20RecordList E: $e');
    }
  }

  Future<bool> getWithDrawRequestList() async {
    bool hasAddedMoney = false;
    await database.child(usersKey).get().then((event) {
      /*  debugPrint('EVENT: ${event.value}'); */
      for (final child in event.children) {
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId.value) {
            database.child(usersKey).child(child.key.toString()).get().then((event) {
              debugPrint('0.0.0.0.0.0EVENT: ${jsonEncode(event.value)}');
              UserDataModel userDataModel = jsonDecode(jsonEncode(event.value)) != null
                  ? UserDataModel.fromJson(jsonDecode(jsonEncode(event.value)))
                  : UserDataModel();
              withdrawItemList(userDataModel.withdrawListItems);
              buyChipsRecordItemList(userDataModel.addMoneyListItems);
              hasAddedMoney = buyChipsRecordItemList.isNotEmpty;
            }, onError: (error) {
              debugPrint('database.child(users).get() ERROR: $error');
            });
          }
        }
      }
    }, onError: (error) {
      debugPrint(' database.child(usersKey).get() ERROR: $error');
    });
    return hasAddedMoney;
  }

  void getUpiDetails() {
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId.value) {
            if (child.child(upiAddressKey).value != null) {
              upiAddController.text = child.child(upiAddressKey).value.toString();
            }
            if (child.child(upiNameKey).value != null) {
              upiNameController.text = child.child(upiNameKey).value.toString();
            }
          }
        }
      }
      upiAddReadOnly(upiAddController.text.trim().isNotEmpty);
      upiNameReadOnly(upiNameController.text.trim().isNotEmpty);
    }, onError: (error) {
      debugPrint('database.child(users).get() ERROR: $error');
    });
  }

  void withDrawRequest(int enteredAmount) {
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        /* debugPrint('CHILD: ${child.value}'); */
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId.value) {
            database.child(usersKey).child(child.key.toString()).get().then((event) {
              debugPrint('0.0.0.0.0.0EVENT: ${jsonEncode(event.value)}');
              UserDataModel userDataModel = jsonDecode(jsonEncode(event.value)) != null
                  ? UserDataModel.fromJson(jsonDecode(jsonEncode(event.value)))
                  : UserDataModel();
              withdrawItemList(userDataModel.withdrawListItems);
              userBalance.value -= enteredAmount;
              debugPrint('pela WITHDRAWITEMLIST: $withdrawItemList');
              withdrawItemList(
                List.from(withdrawItemList)
                  ..add(
                    WithdrawItem(
                      amount: enteredAmount.toString(),
                      no: (Random().nextInt(200000) + 100000).toString(),
                      status: WithdrawStatus.processing.name,
                      time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    ),
                  ),
              );
              debugPrint('pa6i WITHDRAWITEMLIST: ${withdrawItemList.length}');
            }, onError: (error) {
              debugPrint('database.child(users).get() ERROR: $error');
            }).then((value) {
              debugPrint('Yeah');
              List tempWithdrawList = List<dynamic>.from(withdrawItemList.map((x) => x.toJson()));
              debugPrint('TEMPWITHDRAWLIST: $tempWithdrawList');
              debugPrint('child.ref.toString(): ${child.ref.toString()}');
              debugPrint('USERSKEY: $usersKey');
              debugPrint('WITHDRAWLISTKEY: $withdrawListKey');
              database.child(usersKey).child(child.key.toString()).update({withdrawListKey: tempWithdrawList});
              database.child(usersKey).child(child.key.toString()).update({userCurrentBalanceKey: userBalance.value});
              Fluttertoast.showToast(msg: "Withdarw Request Send Successfully");
              debugPrint('Yeah2');
            });
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(users).get() ERROR: $error');
    });
    registerUpiDetails();
    /* if (!upiAddReadOnly.value || !upiNameReadOnly.value) {
      registerUpiDetails();
    } */
  }

  void registerUpiDetails() {
    if (upiAddController.text.trim().isNotEmpty && upiNameController.text.trim().isNotEmpty) {
      database.child(usersKey).get().then((event) {
        for (final child in event.children) {
          if (child.child(playerIdkey).value != null) {
            if (child.child(playerIdkey).value == playerId.value) {
              database.child(usersKey).child(child.key.toString()).update({upiAddressKey: upiAddController.text.trim()});
              database.child(usersKey).child(child.key.toString()).update({upiNameKey: upiNameController.text.trim()});
            }
          }
        }
      }, onError: (error) {
        debugPrint('database.child(users).get() ERROR: $error');
      });
    }
  }

  void addMoneyRequest(int enteredAmount, {String status = "processing"}) {
    database.child(usersKey).get().then((event) {
      for (final child in event.children) {
        if (child.child(playerIdkey).value != null) {
          if (child.child(playerIdkey).value == playerId.value) {
            database.child(usersKey).child(child.key.toString()).get().then((event) {
              debugPrint('0.0.0.0.0.0EVENT: ${jsonEncode(event.value)}');
              UserDataModel userDataModel = jsonDecode(jsonEncode(event.value)) != null
                  ? UserDataModel.fromJson(jsonDecode(jsonEncode(event.value)))
                  : UserDataModel();
              buyChipsRecordItemList(userDataModel.addMoneyListItems);
              userBalance.value += enteredAmount;
              debugPrint('pela buyChipsRecordItemList: $buyChipsRecordItemList');
              buyChipsRecordItemList(
                List.from(buyChipsRecordItemList)
                  ..add(
                    WithdrawItem(
                      amount: enteredAmount.toString(),
                      no: (Random().nextInt(200000) + 100000).toString(),
                      status: status,
                      time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    ),
                  ),
              );
              debugPrint('pa6i buyChipsRecordItemList: ${buyChipsRecordItemList.length}');
            }, onError: (error) {
              debugPrint('database.child(users).get() ERROR: $error');
            }).then((value) {
              debugPrint('Yeah');
              List tempAddMoneyList = List<dynamic>.from(buyChipsRecordItemList.map((x) => x.toJson()));
              debugPrint('tempAddMoneyList: $tempAddMoneyList');
              debugPrint('child.ref.toString(): ${child.ref.toString()}');
              debugPrint('USERSKEY: $usersKey');
              debugPrint('addMoneyListKey: $addMoneyListKey');
              database.child(usersKey).child(child.key.toString()).update({addMoneyListKey: tempAddMoneyList});
              database.child(usersKey).child(child.key.toString()).update({userCurrentBalanceKey: userBalance.value});
              if (status == WithdrawStatus.success.name) {
                Fluttertoast.showToast(msg: "Payment Success");
              } /* else if (status == WithdrawStatus.failed.name) {
                Fluttertoast.showToast(msg: "Payment Failed");
              } */

              debugPrint('Yeah2');
              try {
                WheelController wheelController = Get.find();
                int tempBalanceVar = userBalance.value;
                wheelController.userBalance(tempBalanceVar);
              } catch (e) {
                debugPrint('wheelController = Get.find() E: $e');
              }
            });
          }
        }
      }
    }, onError: (error) {
      debugPrint('database.child(users).get() ERROR: $error');
    });
    /* if (!upiAddReadOnly.value || !upiNameReadOnly.value) {
      registerUpiDetails();
    } */
  }

  Widget addMoneyDialog(BuildContext context, double itemSpacing) {
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
          margin: EdgeInsets.all(addMoneyWithDrawdialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: addMoneyWithDrawdialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(addMoneyWithDrawdialogAlign.value ? 0 : deviceHeight * 0.80),
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
                                        selectedOptionInDialog.value == 0 ? Assets.iconsAddMoneyDialogText : Assets.iconsWithdrawDialogText,
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
                                                  userBalance.value.toString(),
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
                                    if (selectedOptionInDialog.value == 0) buyChipsWid(itemSpacing: itemSpacing),
                                    if (selectedOptionInDialog.value == 1) withdrawWid(),
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
                              addMoneyWithDrawdialogAlign(!addMoneyWithDrawdialogAlign.value);
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
                            recordDialogAlign(!recordDialogAlign.value);
                            getWithDrawRequestList();
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

  Widget addMoneyBtns(String btnText, int i) {
    return InkWell(
      onTap: () {
        selectedOptionInDialog(i);
      },
      child: SizedBox(
        height: deviceHeight * 0.12,
        width: deviceWidth * 0.15,
        child: Stack(
          children: [
            if (selectedOptionInDialog.value == i)
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

  Widget buyChipsWid({double itemSpacing = 10}) {
    return SizedBox(
      height: deviceHeight,
      width: deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cmnBuyChipWid(chips: addMoneyItemList[0].addMoneyChips, price: addMoneyItemList[0].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(chips: addMoneyItemList[1].addMoneyChips, price: addMoneyItemList[1].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(chips: addMoneyItemList[2].addMoneyChips, price: addMoneyItemList[2].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(chips: addMoneyItemList[3].addMoneyChips, price: addMoneyItemList[3].addMoneyPrice),
            ],
          ),
          SizedBox(height: itemSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cmnBuyChipWid(chips: addMoneyItemList[4].addMoneyChips, price: addMoneyItemList[4].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(chips: addMoneyItemList[5].addMoneyChips, price: addMoneyItemList[5].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(chips: addMoneyItemList[6].addMoneyChips, price: addMoneyItemList[6].addMoneyPrice),
              SizedBox(width: itemSpacing),
              cmnBuyChipWid(chips: addMoneyItemList[7].addMoneyChips, price: addMoneyItemList[7].addMoneyPrice),
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
                cmnTotalBalWid(title: "Total Balance", amount: userBalance.value.toString()),
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
                          controller: amountTextController,
                          focusNode: amountNode,
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
                  controller: upiAddController,
                  focusNode: upiAddNode,
                  readOnly: upiAddReadOnly.value,
                ),
                cmnUpiFieldsWid(
                  title: "Upi Name",
                  controller: upiNameController,
                  focusNode: upiNameNode,
                  readOnly: upiNameReadOnly.value,
                ),
              ],
            ),
          ),
          SizedBox(height: deviceHeight * 0.013),
          InkWell(
            onTap: () {
              int enteredAmount = int.tryParse(amountTextController.text.trim()) ?? 0;
              /*  getWithDrawRequestList().then((hasAddedMoney) {
                
              }); */
              if (upiAddController.text.trim().isNotEmpty &&
                  upiAddController.text.trim().contains("@") &&
                  upiNameController.text.trim().isNotEmpty &&
                  amountTextController.text.trim().isNotEmpty &&
                  enteredAmount >= minWithdrawLimit.value &&
                  enteredAmount <= maxWithdrawLimit.value &&
                  enteredAmount <= userBalance.value) {
                amountTextController.clear();
                withDrawRequest(enteredAmount);
              } else {
                if (amountTextController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Please Enter valid Amount");
                } else if (upiAddController.text.trim().isEmpty || !upiAddController.text.trim().contains("@")) {
                  Fluttertoast.showToast(msg: "Please Enter Upi Address Correctly");
                } else if (upiNameController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Please Enter Upi Name Correctly");
                } else if (enteredAmount < minWithdrawLimit.value) {
                  Fluttertoast.showToast(msg: "Please Enter Amount greater than ${minWithdrawLimit.value}");
                } else if (enteredAmount > userBalance.value) {
                  Fluttertoast.showToast(msg: "Please Enter Amount lower than ${userBalance.value}");
                } else if (enteredAmount > maxWithdrawLimit.value) {
                  Fluttertoast.showToast(msg: "Please Enter Amount lower than ${maxWithdrawLimit.value}");
                } /* else if (!hasAddedMoney) {
                    Fluttertoast.showToast(msg: "To Withdraw Please Add Money");
                  } */
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

  String get getWithdrawable {
    if (userBalance.value > minWithdrawLimit.value && userBalance.value < maxWithdrawLimit.value) {
      return userBalance.value.toString();
    } else if (userBalance.value < minWithdrawLimit.value) {
      return 0.toString();
    } else if (userBalance.value > maxWithdrawLimit.value) {
      return maxWithdrawLimit.value.toString();
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
                    // readOnly: readOnly,
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
    return InkWell(
      onTap: () async {
        if (int.tryParse(price) != null) {
          /* addMoneyRequest(int.tryParse(price) != null ? int.tryParse(price)! : 10000, status: WithdrawStatus.success.name); */
          try {
            final res = await EasyUpiPaymentPlatform.instance.startPayment(
              EasyUpiPaymentModel(
                payeeVpa: adminUpi.value,
                payeeName: adminUpiName.value,
                amount: int.tryParse(price) != null ? int.tryParse(price)!.toDouble() : 100000.0,
                description: adminUpiDecription.value,
              ),
            );
            addMoneyRequest(int.tryParse(price) != null ? int.tryParse(price)! : 10000, status: WithdrawStatus.success.name);
            // TODO: add your success logic here
            print(res);
          } on EasyUpiPaymentException {
            Fluttertoast.showToast(msg: "Payment Failed");
            // addMoneyRequest(int.tryParse(price) != null ? int.tryParse(price)! : 10000, status: WithdrawStatus.failed.name);
            // TODO: add your exception logic here
          }
        }
      },
      child: SizedBox(
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
      ),
    );
  }

  Widget recordsDialog(BuildContext context) {
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
          margin: EdgeInsets.all(recordDialogAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: recordDialogAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(recordDialogAlign.value ? 0 : deviceHeight * 0.80),
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
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.05),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white54, width: 2, strokeAlign: StrokeAlign.outside)),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              recordDialogBtns(
                                isEnable: isWithdrawDialog.value,
                                btnText: "Withdraw",
                                onTap: () {
                                  isWithdrawDialog(!isWithdrawDialog.value);
                                },
                              ),
                              const SizedBox(width: 5),
                              const VerticalDivider(
                                color: Colors.white54,
                                thickness: 2,
                              ),
                              const SizedBox(width: 5),
                              recordDialogBtns(
                                isEnable: !isWithdrawDialog.value,
                                btnText: "Buy Chips",
                                onTap: () {
                                  isWithdrawDialog(!isWithdrawDialog.value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
                        child: Padding(
                          padding: EdgeInsets.only(top: deviceHeight * 0.05),
                          child: Column(
                            children: [
                              Table(
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
                                  if (isWithdrawDialog.value) ...records() else ...buyChipsRecords(),
                                ],
                              ),
                              if ((isWithdrawDialog.value && withdrawItemList.isEmpty) ||
                                  (!isWithdrawDialog.value && buyChipsRecordItemList.isEmpty))
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "No Record Found",
                                      style: TextStyle(color: ColorHelper.white, fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ) /* :Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
                        child: Padding(
                          padding: EdgeInsets.only(top: deviceHeight * 0.05),
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
                              if (isWithdrawDialog.value) ...records() else ...buyChipsRecords(),
                            ],
                          ),
                        ),
                      ),
                    ), */
                  ],
                ),
                Positioned(
                  top: isTablet ? 9.5 : 7,
                  right: isTablet ? 2 : 2.5,
                  child: InkWell(
                    onTap: () {
                      recordDialogAlign(!recordDialogAlign.value);
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

  Widget recordDialogBtns({void Function()? onTap, required String btnText, required bool isEnable}) {
    return InkWell(
        onTap: onTap,
        child: SizedBox(
          height: deviceHeight * 0.07,
          width: deviceWidth * 0.12,
          child: Stack(
            children: [
              if (isEnable)
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
                  style: const TextStyle(color: ColorHelper.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ));
  }

  List<TableRow> records() {
    return List.generate(
      withdrawItemList.length <= 6 ? withdrawItemList.length : 6,
      (index) => TableRow(
        children: [
          recordRowWid(withdrawItemList.reversed.toList()[index].no),
          recordRowWid(withdrawItemList.reversed.toList()[index].amount),
          recordRowWid(withdrawItemList.reversed.toList()[index].time),
          withdrawItemList.reversed.toList()[index].reason.isNotEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      recordRowWid(withdrawItemList.reversed.toList()[index].status),
                      InkWell(
                        onTap: () {
                          Fluttertoast.showToast(msg: withdrawItemList.reversed.toList()[index].reason, toastLength: Toast.LENGTH_LONG);
                        },
                        child: const Icon(
                          Icons.report_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                )
              : recordRowWid(withdrawItemList.reversed.toList()[index].status),
        ],
      ),
    );
  }

  List<TableRow> buyChipsRecords() {
    return List.generate(
      buyChipsRecordItemList.length <= 6 ? buyChipsRecordItemList.length : 6,
      (index) => TableRow(
        children: [
          recordRowWid(buyChipsRecordItemList.reversed.toList()[index].no),
          recordRowWid(buyChipsRecordItemList.reversed.toList()[index].amount),
          recordRowWid(buyChipsRecordItemList.reversed.toList()[index].time),
          buyChipsRecordItemList.reversed.toList()[index].reason.isNotEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      recordRowWid(buyChipsRecordItemList.reversed.toList()[index].status),
                      InkWell(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: buyChipsRecordItemList.reversed.toList()[index].reason, toastLength: Toast.LENGTH_LONG);
                        },
                        child: const Icon(
                          Icons.report_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                )
              : recordRowWid(buyChipsRecordItemList.reversed.toList()[index].status),
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
  }

  void stremCloseMethod() {
    try {
      for (var it in streams) {
        it.cancel();
      }
    } catch (e) {
      debugPrint('stremCloseMethod E: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    stremCloseMethod();
  }

  @override
  void dispose() {
    stremCloseMethod();
    super.dispose();
  }
}
