// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/routes/pages.dart';

class NotificationService extends GetxService {
  static late FirebaseMessaging _fcm;
  static late FlutterLocalNotificationsPlugin _localNotification;

  static AndroidInitializationSettings _androidInitLN =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  static IOSInitializationSettings _iosInitLN = IOSInitializationSettings();
  static InitializationSettings _initSettingLN =
      InitializationSettings(android: _androidInitLN, iOS: _iosInitLN);

  static Future init() async {
    await Firebase.initializeApp();
    _fcm = FirebaseMessaging.instance;

    // final token = await _fcm.getToken();
    // print(token);

    if (GetPlatform.isIOS) {
      _fcm.requestPermission();
    }

    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onBackgroundMessage(_onBackground);
    // FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedFromBackground);
  }

  static Future<String?> getFcmToken() async {
    final token = await _fcm.getToken();
    return token;
  }

  static Future<String?> deleteFcmToken() async {
    await _fcm.deleteToken();
  }

  static Future<void> pushNotif(
      {required String code,
      required List registrationId,
      required int type}) async {
    List titleNotif = [
      "Yeay, permintaan anda disetujui",
      "Permintaan ditolak",
    ];

    List messageNotif = [
      "Admin telah menyetujui permintaan anda sebagai akun terverifikasi",
      "Admin menolak permintaan anda sebagai akun terverifikasi",
    ];

    String titleBody = titleNotif[type].toString();
    String messageBody = messageNotif[type].toString();
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAArjUtLY:APA91bEW6WwuUon_D1J3ym66LRSWm3_axedChbkkE06zWsOmcVqliiUSRy8dSui4JTc50ldZ3bgiic4ayzdhCzo7Y2SSa4W7DjK5VcnGikaaewvGSEYNOjvAx8PKKfyB0u2aPaB69n0X'
    };
    Map<String, dynamic> body = {
      "notification": {
        "title": titleBody,
        "body": messageBody,
      },
      "data": {
        "code": code,
        "type": 9,
      },
      "registration_ids": registrationId,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    var response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    print(response.body);
  }

  static Future _showNotification(RemoteMessage message) async {
    _localNotification = FlutterLocalNotificationsPlugin();
    await _localNotification.initialize(_initSettingLN,
        onSelectNotification: _onOpenedNotification);

    if (message.notification != null) {
      try {
        final androidDetails = AndroidNotificationDetails('1', 'Specific',
            channelDescription: 'Notification for specific user',
            fullScreenIntent: true,
            timeoutAfter: 4000,
            importance: Importance.max,
            priority: Priority.high);
        final iosDetails = IOSNotificationDetails();
        final generalNotificationDetails =
            NotificationDetails(android: androidDetails, iOS: iosDetails);

        await _localNotification.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          generalNotificationDetails,
          payload: json.encode(message.data),
        );
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  static void _onForeground(RemoteMessage message) async {
    HomeController controller = Get.put(HomeController());
    controller.onGetData();
    _showNotification(message);
    // notificationController.onGetNotifications();
  }

  static Future<void> _onBackground(RemoteMessage message) async {
    HomeController controller = Get.put(HomeController());
    controller.onGetData();
    // final notificationController = Get.put(NotificationController());

    // await _showNotification(message);
    // _showNotification(message);
    // NotificationController notificationController = Get.find();
    // notificationController.onGetData();
    print("Handling a background message: ${message.messageId}");
    // notificationController.onGetNotifications();
  }

  static Future<void> _onOpenedNotification(String? payload) async {
    // final notificationController = Get.put(NotificationController());
    print(payload);

    if (payload != null) {
      final jsonPayload = json.decode(payload);
      Get.toNamed(AppPages.DETAIL_REPORT + jsonPayload['code'].toString(),
          arguments: jsonPayload['code'].toString());
      // if (jsonPayload['type'].toString() == "1") {
      //   print(jsonPayload['type']);
      //   Get.toNamed(AppPages.COMMUNITY + jsonPayload['code'].toString(),
      //       arguments: jsonPayload['code']);
      // } else if (jsonPayload['type'].toString() == "2") {
      //   print(jsonPayload['type']);
      //   Get.toNamed(AppPages.DETAIL_POST + jsonPayload['code'].toString(),
      //       arguments: jsonPayload['code']);
      // } else if (jsonPayload['type'].toString() == "0") {
      //   print(jsonPayload['type']);
      //   Get.toNamed(AppPages.DETAIL_EVENT + jsonPayload['code'].toString(),
      //       arguments: jsonPayload['code']);
      // } else if (jsonPayload['type'].toString() == "3") {
      //   print(jsonPayload['type']);
      //   Get.toNamed(AppPages.PROFILE_PERSON + jsonPayload['code'].toString(),
      //       arguments: jsonPayload['code']);
      // }
    }
  }
}
