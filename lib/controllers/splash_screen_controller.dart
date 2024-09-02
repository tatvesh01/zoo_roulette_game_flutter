// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/color_helper.dart';
import '../generated/assets.dart';
import '../globles.dart';
import '../main.dart';
import '../models/notificationdata_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
RxBool playasgueststatusData = true.obs;

class SplashScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  FirebaseMessaging? _messaging;
  FlutterLocalNotificationsPlugin? flip;
  var vibrationPattern = Int64List(4);
  final database = FirebaseDatabase.instance.ref();
  String firebaseFcmToken = "";
  RxInt fcmRTDBIndex = 0.obs;
  RxBool forceUpdateAlign = false.obs;

  @override
  Future<void> onInit() async {
    await getPackageInfo();
    await getDeviceInfo();
    await registerFcmNotification();
    await getforceUpdate();
    await getGuestLoginStatus();
    flip = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var macOS = iOS;
    var settings = InitializationSettings(android: android, iOS: iOS, macOS: macOS);
    flip!.initialize(
      settings,
      /* onSelectNotification: (payload) {
        debugPrint('PAYLOAD: $payload');
        payload1 = payload!;
        debugPrint('PAYLOAD1: $payload1');
        if (payload == "1") {
          debugPrint('======123=======');
        }
      }, */
    );

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('NOTIFICATIONDATA: ${message.data}');
      debugPrint('notification title-->: ${message.notification!.title ?? "title null Avyu"}');
      debugPrint('notification body-->: ${message.notification!.body ?? "body null Avyu"}');
      debugPrint('MESSAGE.DATA: ${message.collapseKey}');
      debugPrint('MESSAGE.DATA: ${message.messageId}');
      debugPrint('MESSAGE.DATA: ${message.messageType}');
      NotificationData notificationData2 = NotificationData.fromJson(message.data);
      debugPrint('NOTIFICATIONDATAmessage: ${notificationData2.message}');
      debugPrint('NOTIFICATIONDATAtitle: ${notificationData2.title}');
      debugPrint('NOTIFICATIONDATAapplicationDropdown: ${notificationData2.applicationDropdown}');
      debugPrint('orderId: ${notificationData2.orderId}');
      notiMessage = message.data["message"];
      debugPrint('NOTIMESSAGE: $notiMessage');
      title = message.data["title"];
    });

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('NOTIFICATIONDATA: ${message.data}');
        debugPrint('notification title-->: ${message.notification!.title ?? "title null Avyu"}');
        debugPrint('notification body-->: ${message.notification!.body ?? "body null Avyu"}');
        debugPrint('MESSAGE.DATA: ${message.collapseKey}');
        debugPrint('MESSAGE.DATA: ${message.messageId}');
        debugPrint('MESSAGE.DATA: ${message.messageType}');
        NotificationData notificationData3 = NotificationData.fromJson(message.data);
        debugPrint('NOTIFICATIONDATAmessage: ${notificationData3.message}');
        debugPrint('NOTIFICATIONDATAtitle: ${notificationData3.title}');
        notiMessage = message.data["message"];
        debugPrint('NOTIMESSAGE: $notiMessage');
        title = message.data["title"];
        isFromNotification(true);
      }
    });
    super.onInit();
  }

  Future registerFcmNotification() async {
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    //code for background notification channel
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'background_channel',
      'Back Ground Channel',
      importance: Importance.high,
      enableLights: true,
      playSound: true,
      vibrationPattern: vibrationPattern,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.getToken().then((token) {
      firebaseFcmToken = token.toString();
      debugPrint("FCM_token ==> $firebaseFcmToken \n");
      debugPrint('LOCALDATASTORAGE.READ(FCMTOKEN): ${localDataStorage.read(fcmToken)} \n');
      if (localDataStorage.read(fcmToken) == null) {
        localDataStorage.write(fcmToken, firebaseFcmToken);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('NOTIFICATIONDATA: ${message.data}');
      debugPrint('notification title-->: ${message.notification!.title ?? "title null Avyu"}');
      debugPrint('notification body-->: ${message.notification!.body ?? "body null Avyu"}');
      NotificationData notificationData = NotificationData.fromJson(message.data);
      debugPrint('NOTIFICATIONDATAmessage: ${notificationData.message}');
      debugPrint('NOTIFICATIONDATAtitle: ${notificationData.title}');
      debugPrint('NOTIFICATIONDATAapplicationDropdown: ${notificationData.applicationDropdown}');
      debugPrint('orderId: ${notificationData.orderId}');
      image = notificationData.image;
      notiMessage = message.data["message"];
      debugPrint('NOTIMESSAGE: $notiMessage');
      title = message.data["title"];
      payload1 = "1";
      showNotification(title.toString(), notiMessage.toString());
      // _showBigPictureNotificationHiddenLargeIcon(title.toString(), notiMessage.toString(), image);
    });
  }

  Future showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'forground_channel',
      'For Ground Channel',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      vibrationPattern: vibrationPattern,
    );
    var darwinPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: darwinPlatformChannelSpecifics, macOS: darwinPlatformChannelSpecifics);
    await flip!.show(0, title, body, platformChannelSpecifics, payload: "1");
  }

  Future<void> getforceUpdate() async {
    try {
      await database.child(latestAppVersionCodeKey).get().then((event) {
        debugPrint('latestAppVersionCodeKey EVENT.value: ${event.value}');
        versionCodeRemote = event.value.runtimeType == int ? event.value as int : 0;
        /* double currentVersion = double.parse(appVersion.trim().replaceAll(".", ""));

        String remoteVersionString = await SPHelper.getStringSP(SPHelper.appVersion);

        double remoteVersion = double.parse(remoteVersionString.trim().replaceAll(".", "")); */
        try {
          if (versionCodeRemote > versionCode) {
            forceUpdateAlign(true);
          }
        } catch (exception) {
          debugPrint('versionCheck EXCEPTION: $exception');
        }
      }, onError: (error) {
        debugPrint(' database.child(last20RecordList).get() ERROR: $error');
      });
    } catch (e) {
      debugPrint('last20RecordList E: $e');
    }
  }


  Future<void> getGuestLoginStatus() async {
    try {
      await database.child(playasgueststatus).get().then((event) {
        debugPrint('playasgueststatus EVENT.value: ${event.value}');
        if(event.value.runtimeType == bool){
          playasgueststatusData.value = event.value as bool;
          debugPrint('playasgueststatus EVENT.value: ${playasgueststatusData}');
        }
      }, onError: (error) {
        debugPrint(' database.child(last20RecordList).get() ERROR: $error');
      });
    } catch (e) {
      debugPrint('last20RecordList E: $e');
    }
  }

  Widget forceUpdateDialog(BuildContext context) {
    String forceUpdateTitle = "New Update Available";
    String forceUpdateMessage = "There is a newer version of app available please update it now.";
    String btnLabel = "Update Now";
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
          margin: EdgeInsets.all(forceUpdateAlign.value ? 0 : deviceHeight),
          duration: Duration(milliseconds: forceUpdateAlign.value ? 10 : 200),
          height: deviceHeight,
          width: deviceWidth,
          child: AnimatedContainer(
            alignment: Alignment.center,
            margin: EdgeInsets.all(forceUpdateAlign.value ? 0 : deviceHeight * 0.80),
            duration: const Duration(milliseconds: 200),
            height: deviceHeight * 0.5,
            width: deviceWidth * 0.5,
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
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.05, left: 25, right: 25),
                  child: Column(
                    children: [
                      Text(
                        forceUpdateTitle,
                        style: const TextStyle(color: ColorHelper.white, fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      Text(
                        forceUpdateMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: ColorHelper.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      forceUpdateBtns(
                        isEnable: true,
                        btnText: btnLabel,
                        onTap: () {
                          launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=$packageName"));
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forceUpdateBtns({void Function()? onTap, required String btnText, required bool isEnable}) {
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
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> _showBigPictureNotificationHiddenLargeIcon(String title, String body, String imgPath) async {
  final String largeIconPath = await _downloadAndSaveFile(dummyPlaceHolderImage, 'largeIcon');
  final String bigPicturePath = await _downloadAndSaveFile(dummyPlaceHolderImage, 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true, contentTitle: title, htmlFormatContentTitle: true, summaryText: body, htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('forground_channel', 'For Ground Channel',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      /* vibrationPattern: vibrationPattern, */ //TODO
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await FlutterLocalNotificationsPlugin().show(0, title, body, platformChannelSpecifics, payload: "1");
}

Future<void> getPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo.appName;
  debugPrint('APPNAME: $appName');
  packageName = packageInfo.packageName;
  debugPrint('PACKAGENAME: $packageName');
  appVersion = packageInfo.version;
  debugPrint('APPVERSION: $appVersion');
  versionCode = int.tryParse(packageInfo.buildNumber) ?? 1;
  debugPrint('VERSIONCODE: $versionCode');
}

Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';
  String imeiNo = '';
  String phoneCompany = '';
  String deviceModel = '';
  String deviceOS = '';
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // deviceId = androidInfo.
      debugPrint('DEVICEID: $deviceId');
      phoneCompany = androidInfo.brand;
      debugPrint('PHONECOMPANY: $phoneCompany');
      deviceModel = androidInfo.model;
      debugPrint('DEVICEMODEL: $deviceModel');
      deviceOS = androidInfo.version.release;
      debugPrint('DEVICEOS: $deviceOS');
      // setPhoneCompany(phoneCompany);
      // setDeviceId(deviceId);
      // setDeviceModel(deviceModel);
      // setDeviceOS(deviceOS);
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneCompany = iosInfo.model!;
      deviceModel = iosInfo.name!;
      deviceOS = iosInfo.utsname.version!;
      deviceId = iosInfo.identifierForVendor!;
      // setPhoneCompany(phoneCompany);
      // setDeviceId(deviceId);
      // setDeviceModel(deviceModel);
      // setDeviceOS(deviceOS);
    }
  } catch (e) {
    debugPrint('E: $e');
  }
}
