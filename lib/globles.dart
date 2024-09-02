import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoo_zimba/generated/assets.dart';

import 'Utils/authentication.dart';
import 'models/google_user_data_model.dart';
import 'screens/wheel_screen.dart';

GetStorage localDataStorage = GetStorage();
//const String keys
String fcmToken = 'fcmToken';
String isAnonymousKey = 'isAnonymous';
String playerIdkey = 'playerId';
String playerNamekey = 'playerName';
String playerImgkey = 'playerImg';
String guserDataKey = 'guserData';
String currentEventKey = 'currentEvent';
String last20RecordListKey = 'last20RecordList';
String hintVideoUrlKey = 'hintVideoUrl';
String onlineUsersCountKey = 'onlineUsersCount';
String buyChipsListKey = 'buyChipsList';
String betBotChipsKey = 'betBotChips';

//globle var
String appName = "";
String packageName = "";
int versionCode = 0;
int versionCodeRemote = 0;
String appVersion = "";

double deviceHeight = 800;
double deviceWidth = 390;
const dummyPlaceHolderImage = "https://user-images.githubusercontent.com/47315479/81145216-7fbd8700-8f7e-11ea-9d49-bd5fb4a888f1.png";
bool isTablet = false;
double deviceShortestSide = 390;

String hintText = """Zoo Roulette

"Zoo Roulette" is a very entertaining and exiting large-scale online roulette game.

Players bet on the animals. Animals are divided into four categories, birds, beasts,

sharks,frog and you win the payout by betting on the right animals.

There are 10 betting areas in the game, and the odds for each area are different.""";

enum EventStatus {
  startBetting,
  stopBetting,
  startSpin,
  stopSpin,
  startResult,
  stopResult,
}

enum WithdrawStatus {
  processing,
  reviewing,
  success,
  failed,
  cancelled,
  pending,
}

String whereTOStopKey = "whereTOStop";
String whereTOStopObjKey = "whereTOStopObj";
String whereTOStopIndexKey = "whereTOStopIndex";
String usersKey = "users";
String selectedBetItemsKey = "selectedBetItems";
String userCurrentBalanceKey = "userCurrentBalance";
String userCurrentRoundWinLossAmountKey = "userCurrentRoundWinLossAmount";
String addMoneyPriceListKey = "addMoneyPriceList";
String withdrawListKey = "withdrawList";
String addMoneyListKey = "addMoneyList";
String minWithdrawLimitKey = "minWithdrawLimit";
String maxWithdrawLimitKey = "maxWithdrawLimit";
String upiAddressKey = "upiAddress";
String upiNameKey = "upiName";
String isFirstTimeKey = "isFirstTime";
String firstTimeWinBalanceKey = "firstTimeWinBalance";
String firstAfterWinOrLossAmountKey = "firstAfterWinOrLossAmount";
String afterWinOrLossAmountKey = "afterWinOrLossAmount";
String isFirstTimeInWheelScreenKey = "isFirstTimeInWheelScreen";
String adminUpiKey = "adminUpi";
String playasgueststatus = "playasgueststatus";
String adminUpiNameKey = "adminUpiName";
String adminUpiDecriptionKey = "adminUpiDecription";
// String latestAppVersionKey = "latestAppVersion";
String latestAppVersionCodeKey = "latestAppVersionCode";

List<String> recordItemsPathList = [
  Assets.recordItemsSwallow,
  Assets.recordItemsMonkey,
  Assets.recordItemsEagle,
  Assets.recordItemsPanda,
  Assets.recordItemsShark,
  Assets.recordItemsPeacock,
  Assets.recordItemsRabbit,
  Assets.recordItemsPigeon,
  Assets.recordItemsLion,
  Assets.recordItemsFrog,
];
List<String> ribbinItemsPathList = [
  Assets.ribbinItemsSwallow,
  Assets.ribbinItemsMonkey,
  Assets.ribbinItemsEagle,
  Assets.ribbinItemsPanda,
  Assets.ribbinItemsShark,
  Assets.ribbinItemsPeacock,
  Assets.ribbinItemsRabbit,
  Assets.ribbinItemsPigeon,
  Assets.ribbinItemsLion,
  Assets.ribbinItemsFrog,
];


List<Alignment> coinAnimAlignmentsList = [
  const Alignment(0.26, -0.58),
  const Alignment(-0.15, -0.58),
  const Alignment(0.465, -0.05),
  const Alignment(0.05, -0.05),
  const Alignment(-0.055, 0.52),
  const Alignment(0.26, -0.05),
  const Alignment(0.05, -0.58),
  const Alignment(0.465, -0.58),
  const Alignment(-0.15, -0.05),
  const Alignment(0.38, 0.52),
  const Alignment(0.20, -0.58),
  const Alignment(-0.10, -0.58),
  const Alignment(0.42, -0.05),
  const Alignment(0.0, -0.05),
  const Alignment(-0.0, 0.52),
  const Alignment(0.20, -0.05),
  const Alignment(0.0, -0.58),
  const Alignment(0.4, -0.58),
  const Alignment(-0.10, -0.05),
  const Alignment(0.32, 0.52),
];

List<String> coinAnimChipsList = [
  Assets.iconsTenChips,
  Assets.iconsFiftyChips,
  Assets.iconsOneHundredChips,
  Assets.iconsFiveHundresChips,
  Assets.iconsOneThousandChips,
  Assets.iconsFiveThousandChips,
  Assets.iconsTenThousandChips,
];

List<int> tempSeriesList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
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

String validateUpiID(String value) {
  String pattern = '^[w.-]+@[w.-]+\$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter UPI ID';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter valid UPI ID';
  }
  return "";
}

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

Future<void> signInWithGoogle(BuildContext context) async {
  // try {
    User? user = await Authentication.signInWithGoogle(context: context);
    if (user != null) {
      GUserDataModel gUserDataModel = GUserDataModel(
        displayName: user.displayName ?? "Guest${(Random().nextInt(313132) + 12010101)}",
        email: user.email ?? "",
        emailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
        userMetadataCreationTime: user.metadata.creationTime != null ? user.metadata.creationTime.toString() : "",
        userMetadataLastSignInTime: user.metadata.lastSignInTime != null ? user.metadata.lastSignInTime.toString() : "",
        phoneNumber: user.phoneNumber ?? "",
        photoUrl: user.photoURL ?? "",
        providerDataUid: user.providerData.isNotEmpty ? user.providerData.first.uid ?? "" : "",
        uid: user.uid,
      );
      /*    debugPrint('displayName: ${user.displayName!}');
      debugPrint('displayName: ${user.email}');
      debugPrint('displayName: ${user.phoneNumber}');
      debugPrint('displayName: ${user.metadata}'); */
      debugPrint('displayName: ${gUserDataModel.displayName}');
      localDataStorage.write(playerIdkey, gUserDataModel.uid);
      localDataStorage.write(isAnonymousKey, gUserDataModel.isAnonymous);
      localDataStorage.write(playerNamekey, gUserDataModel.displayName);
      localDataStorage.write(playerImgkey, gUserDataModel.photoUrl);
      localDataStorage.write(guserDataKey, jsonEncode(gUserDataModel.toJson()));
      createUserOrGetUser(gUserDataModel.uid, gUserDataModel);
      // Get.to(() => WheelSCREEN(), arguments: [playerId]);
    }
    /* var aa = await googleSignIn.signIn();
      debugPrint(aa?.email);
      debugPrint(aa?.displayName); */
  // } catch (error) {
  //   debugPrint('signInWithGoogle ERROR: $error');
  // }
}

Future<void> signInWithGuest() async {
  try {
    User? user = await Authentication.signInAnonymously();
    if (user != null) {
      GUserDataModel gUserDataModel = GUserDataModel(
        displayName: user.displayName ?? "Guest${(Random().nextInt(313132) + 120101)}",
        email: user.email ?? "",
        emailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
        userMetadataCreationTime: user.metadata.creationTime != null ? user.metadata.creationTime.toString() : "",
        userMetadataLastSignInTime: user.metadata.lastSignInTime != null ? user.metadata.lastSignInTime.toString() : "",
        phoneNumber: user.phoneNumber ?? "",
        photoUrl: user.photoURL ?? "",
        providerDataUid: user.providerData.isNotEmpty ? user.providerData.first.uid ?? "" : "",
        uid: user.uid,
      );
      /*    debugPrint('displayName: ${user.displayName!}');
      debugPrint('displayName: ${user.email}');
      debugPrint('displayName: ${user.phoneNumber}');
      debugPrint('displayName: ${user.metadata}'); */
      debugPrint('displayName: ${gUserDataModel.displayName}');
      localDataStorage.write(playerIdkey, gUserDataModel.uid);
      localDataStorage.write(isAnonymousKey, gUserDataModel.isAnonymous);
      localDataStorage.write(playerNamekey, gUserDataModel.displayName);
      localDataStorage.write(playerImgkey, gUserDataModel.photoUrl);
      localDataStorage.write(guserDataKey, jsonEncode(gUserDataModel.toJson()));
      createUserOrGetUser(gUserDataModel.uid, gUserDataModel);
      // Get.to(() => WheelSCREEN(), arguments: [playerId]);
    }
    /* var aa = await googleSignIn.signIn();
      debugPrint(aa?.email);
      debugPrint(aa?.displayName); */
  } catch (error) {
    debugPrint('signInWithGuest ERROR: $error');
  }
}

Future<DataSnapshot?> createUserOrGetUser(String playerId, GUserDataModel gUserDataModel) async {
  final database = FirebaseDatabase.instance.ref();
  DataSnapshot? getRefOFPlayerElement;
  database.child(usersKey).get().then((event) {
    try {
      getRefOFPlayerElement = event.children.where((element) => element.child(playerIdkey).value == playerId).first;
      debugPrint('GETREFOFPLAYERELEMENT: ${getRefOFPlayerElement!.value}');
      debugPrint('GETREFOFPLAYERELEMENT: ${getRefOFPlayerElement!.key}');
    } catch (e) {
      debugPrint('event.children.where Error: $e');
      database.child(usersKey).update({
        event.children.length.toString(): {playerIdkey: playerId, userCurrentBalanceKey: 50, guserDataKey: gUserDataModel.toJson()}
      }).then((value) {
        database.child(usersKey).child(event.children.length.toString()).child(playerIdkey).get().then((value) {
          debugPrint('value.refVALUE: ${value.ref.key}');
          debugPrint('value.refVALUE: ${value.value}');
          if (playerId == value.value) {
            Get.to(() => WheelSCREEN(), arguments: [gUserDataModel.uid]);
          }
        });
      });
    }
    if (event.children.isEmpty) {
      database.child(usersKey).child("0").update({playerIdkey: playerId, userCurrentBalanceKey: 50});
    }
  }, onError: (error) {
    debugPrint(' database.child(users).get() onInit ERROR: $error');
  });
  return getRefOFPlayerElement;
}

logOut(BuildContext context) async {
  await Authentication.signOut(context: context);
  localDataStorage.erase();
}
