// ignore_for_file: unnecessary_this

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/services/service_preference.dart';

class LoginController extends GetxController {
  final _isObscure = true.obs;
  final _isLoading = false.obs;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final emailFC = TextEditingController();
  final passwordFC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  onLogin() {
    if (this.formKey.currentState!.validate()) {
      handleSignInEmail(emailFC.text, passwordFC.text).then((_) {
        Get.back();
        PreferenceService.setStatus("logged");
        Get.offAllNamed(AppPages.HOME);
      }).catchError((error) {
        var errorMessage = "";
        print(error.code);
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Email yang anda masukkan salah.";
            break;
          case "wrong-password":
            errorMessage = "Kata sandi yang anda masukkan salah.";
            break;
          case "user-not-found":
            errorMessage = "Email tidak ditemukan.";
            break;
          case "user-disabled":
            errorMessage = "Pengguna dengan email ini dinonaktifkan.";
            break;
          // case "too-many-requests":
          //   errorMessage = "Too many requests. Try again later.";
          //   break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage =
                "Maaf anda tidak dapat login sekarang, coba lagi nanti.";
        }
        print(errorMessage);
        Get.back();
        Get.snackbar("Gagal", errorMessage,
            colorText: Colors.white, backgroundColor: Colors.red.shade400);
      });
    }
  }

  Future<User> handleSignInEmail(String email, String password) async {
    DialogHelper.showLoading();
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;

    return user;
  }

  void showPassword() {
    this._isObscure.value = !this._isObscure.value;
  }

  get isObscure => this._isObscure.value;
  get isLoading => this._isLoading.value;
}
