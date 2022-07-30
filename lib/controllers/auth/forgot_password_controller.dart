// ignore_for_file: unnecessary_this

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/routes/pages.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailFC = TextEditingController();
  final passwordFC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final formKeyForgot = GlobalKey<FormState>();

  void forgotPassword() async {
    if (this.formKey.currentState!.validate()) {
      try {
        await auth.sendPasswordResetEmail(email: emailFC.text);
        Get.back();
        Get.snackbar("Berhasil",
            "Berhasil mengirim permintaan reset password, Periksa email anda!",
            colorText: Colors.white, backgroundColor: Colors.green.shade400);
      } catch (e) {
        Get.back();
        Get.snackbar("Gagal", "Terjadi kesalahan",
            colorText: Colors.white, backgroundColor: Colors.red.shade400);
      }
    }
  }

  void goToLogin() {
    this.formKeyForgot.currentState!.reset();
    this.passwordFC.text = '';
    Get.toNamed(AppPages.LOGIN);
  }
}
