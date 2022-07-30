// ignore_for_file: await_only_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordFC = TextEditingController();
  final newPasswordFC = TextEditingController();
  final reNewPasswordFC = TextEditingController();
  final _isObscure = true.obs;
  final _isObscure1 = true.obs;
  final _isObscure2 = true.obs;
  final _isLoading = true.obs;

  final formKeyPassword = GlobalKey<FormState>();

  void showPassword() {
    _isObscure.value = !_isObscure.value;
  }

  void showPassword1() {
    _isObscure1.value = !_isObscure1.value;
  }

  void showPassword2() {
    _isObscure2.value = !_isObscure2.value;
  }

  void changePassword() async {
    if (formKeyPassword.currentState!.validate()) {
      DialogHelper.showLoading();
      final user = await FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email!, password: oldPasswordFC.text);

      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPasswordFC.text).then((_) {
          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Berhasil mengubah kata sandi",
              colorText: Colors.white, backgroundColor: Colors.green.shade400);
        }).catchError((error) {
          Get.back();
          Get.snackbar("Gagal", "Terjadi kesalahan saat mengubah kata sandi",
              colorText: Colors.white, backgroundColor: Colors.red.shade400);
        });
      }).catchError((err) {
        var errorMessage = "";
        print(err.code);
        switch (err.code) {
          case "invalid-email":
            errorMessage = "Email yang anda masukkan salah.";
            break;
          case "wrong-password":
            errorMessage = "Kata sandi lama yang anda masukkan salah.";
            break;
          case "user-not-found":
            errorMessage = "Email tidak ditemukan.";
            break;
          case "user-disabled":
            errorMessage = "Pengguna dengan email ini dinonaktifkan.";
            break;
          default:
            errorMessage =
                "Maaf sedang anda tidak dapat login sekarang, coba lagi nanti.";
        }
        Get.back();
        Get.snackbar("Gagal", errorMessage,
            colorText: Colors.white, backgroundColor: Colors.red.shade400);
      });
    }
  }

  get isObscure => _isObscure.value;
  get isObscure1 => _isObscure1.value;
  get isObscure2 => _isObscure2.value;
  get isLoading => _isLoading.value;
}
