// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/helpers/snackbar_helper.dart';
import 'package:passify_admin/models/report.dart';
import 'package:passify_admin/models/user.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/services/service_notification.dart';
import 'package:passify_admin/services/service_preference.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference report = FirebaseFirestore.instance.collection('reports');
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  var dataReport = <ReportModel>[].obs;
  var dataReportUnread = <ReportModel>[].obs;
  var dataUserRequest = <UserModel>[].obs;
  final _isLoading = true.obs;
  final _hasUnread = false.obs;
  final hasRequest = false.obs;
  final hasNotification = false.obs;
  final countBadge = 0.obs;
  var reportProblem = [
    "Kekerasan, pelecehan, ancaman, pembakaran atau intimidasi terhadap orang atau organisasi.",
    "Terlibat dalam atau berkontribusi pada aktivitas ilegal apa pun yang melanggar hak orang lain.",
    "Penggunaan bahasa yang menghina, diskriminatif, atau terlalu vulgar.",
    "Memberikan informasi yang salah, menyesatkan atau tidak akurat."
  ];
  var categoryReport = ["Event", "Komunitas", "Postingan", "Akun/Pengguna"];
  var collectionReport = ["events", "communities", "post", "users"];
  var fieldReport = ["name", "name", "title", "name"];

  @override
  onInit() async {
    await FirebaseMessaging.instance.subscribeToTopic('admin');
    onOpenNotif();
    onGetData();
    super.onInit();
  }

  onOpenNotif() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.data != null) {
      final jsonPayload = initialMessage!.data;
      // final jsonPayload = json.decode(initialMessage.data);
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

  onGetData() async {
    onGetUser();
    // _isLoading.value = true;
    await report.get().then((QuerySnapshot snapshot) {
      dataReport.isNotEmpty ? dataReport.clear() : null;
      if (snapshot.size == 0) {
        _isLoading.value = false;
        hasNotification.value = false;
        countBadge.value = 0;
      }
      snapshot.docs.forEach((notif) {
        DateTime a = notif['date'].toDate();
        String sort = DateFormat("yyyyMMddHHmmss").format(a);
        dataReport.add(ReportModel(
          idReport: notif['idReport'],
          code: notif['code'],
          category: notif['category'],
          idFromUser: notif['idFromUser'],
          readAt: notif['readAt'],
          problem: notif['problem'] ?? 10,
          date: notif['date'],
          sort: int.parse(sort),
        ));
        dataReport.sort((a, b) => b.sort!.compareTo(a.sort!));
        dataReportUnread.value =
            dataReport.where((data) => data.readAt == null).toList();
        final _hasUnreadTemp =
            dataReport.where((element) => element.readAt == null).isNotEmpty;

        _hasUnread.value = _hasUnreadTemp;

        hasNotification.value = _hasUnreadTemp;
        if (_hasUnreadTemp) {
          countBadge.value =
              dataReport.where((element) => element.readAt == null).length;
        }
        update();
        if (snapshot.size == dataReport.length) {
          _isLoading.value = false;
        }
      });
    }).then((_) {});
  }

  onGetUser() async {
    if (dataUserRequest.isNotEmpty) dataUserRequest.clear();
    await user
        .where("status", isEqualTo: 3)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.size > 0 ? hasRequest.value = true : hasRequest.value = false;
      snapshot.docs.forEach((d) {
        dataUserRequest.assign(UserModel(
            name: d["name"],
            username: d["username"],
            date: d["date"],
            idUser: d["idUser"],
            email: d["email"],
            status: d["status"],
            photo: d["photoUser"],
            twitter: d["twitter"],
            hobby: d["hobby"],
            city: d["city"],
            instagram: d["instagram"]));
      });
    });
  }

  void onClickNotif(String idNotification, String code, int category) {
    onReadNotif(idNotification);
    Get.toNamed(AppPages.DETAIL_REPORT + idNotification,
        arguments: idNotification);

    // if (category == 1) {
    //   Get.toNamed(AppPages.COMMUNITY + code.toString(), arguments: code);
    // } else if (category == 2) {
    //   Get.toNamed(AppPages.DETAIL_POST + code.toString(), arguments: code);
    // } else if (category == 0) {
    //   Get.toNamed(AppPages.DETAIL_EVENT + code.toString(), arguments: code);
    // } else if (category == 3) {
    //   Get.toNamed(AppPages.PROFILE_PERSON + code.toString(), arguments: code);
    // }
  }

  onOpenContent(String code, int category) {
    if (category == 1) {
      Get.toNamed(AppPages.COMMUNITY + code.toString(), arguments: code);
    } else if (category == 2) {
      Get.toNamed(AppPages.DETAIL_POST + code.toString(), arguments: code);
    } else if (category == 0) {
      Get.toNamed(AppPages.DETAIL_EVENT + code.toString(), arguments: code);
    } else if (category == 3) {
      Get.toNamed(AppPages.PROFILE_PERSON + code.toString(), arguments: code);
    }
  }

  onReadNotif(var idReport) async {
    await report
        .doc(idReport)
        .update({"readAt": DateTime.now()}).then((_) => onGetData());
  }

  onDeleteNotif(var idReport) async {
    Get.back();
    await report.doc(idReport).delete().then((_) {
      onGetData();
    });
  }

  onAccRequest(var idUser) {
    Get.back();
    DialogHelper.showLoading();
    user.doc(idUser).update({"status": 2}).then((value) {
      user.doc(idUser).get().then((userData) {
        NotificationService.pushNotif(
            code: "code", registrationId: userData['fcmToken'], type: 0);
      });
      onGetData();
      Get.back();
      Get.back();
      SnackBarHelper.showSucces(description: "Berhasil menerima permintaan");
    });
  }

  onRejectRequest(var idUser) {
    Get.back();
    DialogHelper.showLoading();
    user.doc(idUser).update({"status": 1}).then((value) {
      user.doc(idUser).get().then((userData) {
        NotificationService.pushNotif(
            code: "code", registrationId: userData['fcmToken'], type: 1);
      });
      onGetData();
      Get.back();
      Get.back();
      SnackBarHelper.showSucces(description: "Berhasil menolak permintaan");
    });
  }

  Future<void> signOut() async {
    DialogHelper.showLoading();
    await FirebaseAuth.instance.signOut().then((_) async {
      Get.back();
      await FirebaseMessaging.instance.unsubscribeFromTopic('admin');
      PreferenceService.setStatus("unlog");
      Get.offAllNamed(AppPages.LOGIN);
    }).onError((error, stackTrace) {
      print(error);
      Get.back();
      Get.snackbar("Gagal", "Terjadi kesalahan saat mengeluarkan akun",
          colorText: Colors.white, backgroundColor: Colors.red.shade400);
    });
  }

  get isLoading => _isLoading.value;
}
