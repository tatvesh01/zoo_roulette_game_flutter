import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoo_zimba/globles.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'models/notificationdata_model.dart';
import 'screens/splash_screen.dart';
import 'package:sizer/sizer.dart';

String payload1 = "";
String image = "";
String title = "";
RxBool isFromNotification = false.obs;
String notiMessage = "";
String notificationTitle = "";
int notificationId = 0;
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('NOTIFICATIONDATA: ${message.data}');
  debugPrint('notification body-->: ${message.notification}');
  debugPrint('notification title-->: ${message.notification!.title}');
  debugPrint('notification body-->: ${message.notification!.body}');
  NotificationData notificationData2 = NotificationData.fromJson(message.data);
  debugPrint('NOTIFICATIONDATAmessage: ${notificationData2.message}');
  debugPrint('NOTIFICATIONDATAtitle: ${notificationData2.title}');
  debugPrint('NOTIFICATIONDATAapplicationDropdown: ${notificationData2.applicationDropdown}');
  notiMessage = message.data["message"];
  debugPrint('NOTIMESSAGE: $notiMessage');
  title = message.data["title"];
  payload1 = "1";
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  /*await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  await GetStorage.init();
  await Firebase.initializeApp();
  /*  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  ); */
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zoo Zimba',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      );
    });
  }
}
