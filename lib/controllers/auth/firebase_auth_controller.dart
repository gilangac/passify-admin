// ignore_for_file: prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/services/service_notification.dart';
import 'package:passify_admin/services/service_preference.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  List dataUser = [];
  List listFcmToken = [];

  Stream<User?> authStatus() {
    return auth.authStateChanges();
  }


  onSuccessLogin() async {
    List listFcmToken = [];
    final fcmToken = await NotificationService.getFcmToken();
    listFcmToken.add(fcmToken);
    user.doc(auth.currentUser?.uid).update({
      "fcmToken": listFcmToken,
    });
  }

  onGetUser() async {
    final fcmToken = await NotificationService.getFcmToken();
    final email = auth.currentUser?.email;
    final userId = auth.currentUser?.uid;
    user
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) async {
      print("jumlah : " + snapshot.size.toString());
      if (snapshot.size == 1) {
        user.doc(snapshot.docs[0]['idUser']).get().then((value) {
          if (value['username'] != '') {
            snapshot.docs.forEach((element) {
              listFcmToken.assignAll(element['fcmToken']);
            });
            print("1 : $listFcmToken");
            listFcmToken.add(fcmToken);
            user.doc(auth.currentUser?.uid).update({
              "fcmToken": listFcmToken,
            });
            print("2 : $listFcmToken");
            print("token : $fcmToken");
            PreferenceService.setUserId(userId!);
            PreferenceService.setFcmToken(fcmToken!);
            PreferenceService.setStatus("logged");
            // onSuccessLogin();
            Get.offNamed(AppPages.NAVIGATOR);
          } else {
            onSuccessLogin();
          }
        });
      } else {
        onSuccessLogin();
        List initHobby = [];
        await user.doc(auth.currentUser?.uid).set({
          "email": auth.currentUser?.email,
          "idUser": auth.currentUser?.uid,
          "fcmToken": [],
          "name": '',
          "photoUser": '',
          "username": '',
          "city": '',
          "province": '',
          "hobby": initHobby,
          "instagram": '',
          "twitter": '',
          "date": DateTime.now()
        });
      }
    });
  }

  void logout() async {
    Get.back();
    DialogHelper.showLoading();
    var myToken = PreferenceService.getFcmToken();
    List fcmTokenList = [];
    user.doc(auth.currentUser?.uid).get().then((value) {
      fcmTokenList.assignAll(value['fcmToken']);
      fcmTokenList.removeWhere((token) => token == myToken);
      user.doc(auth.currentUser?.uid).update({
        "fcmToken": fcmTokenList,
      }).then((value) async {
        FirebaseMessaging.instance.deleteToken();
        await auth.signOut();
        PreferenceService.clear();
        PreferenceService.setStatus("unlog");
      });
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
