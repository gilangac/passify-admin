// ignore_for_file: must_be_immutable, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/controllers/profile/change_password_controller.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/form_input_password.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({Key? key}) : super(key: key);
  ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Ganti Kata Sandi'),
      body: _body(),
    );
  }

  Widget _body() {
    return Obx(() => Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Form(
              key: changePasswordController.formKeyPassword,
              child: Column(
                children: [
                  _oldPassword(),
                  SizedBox(height: 20),
                  _newPassword(),
                  SizedBox(height: 20),
                  _confirmPassword(),
                  SizedBox(height: 40),
                  _changePasswordBtn(),
                  SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _oldPassword() {
    return formInputPassword2(
      title: 'Kata Sandi Lama',
      placeholder: 'Ketikkan Kata Sandi Lama',
      secureText: changePasswordController.isObscure,
      onShowPassword: () => changePasswordController.showPassword(),
      controller: changePasswordController.oldPasswordFC,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan sandi lama terlebih dahulu';
        }
        return null;
      },
    );
  }

  Widget _newPassword() {
    return formInputPassword2(
      title: 'Kata Sandi Baru',
      placeholder: 'Ketikkan Kata Sandi Baru',
      controller: changePasswordController.newPasswordFC,
      onShowPassword: () => changePasswordController.showPassword1(),
      secureText: changePasswordController.isObscure1,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan sandi baru terlebih dahulu';
        }
        if (value.length < 6) {
          return 'Kata sandi minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _confirmPassword() {
    return formInputPassword2(
      title: 'Ulangi Sandi Baru',
      placeholder: 'Ketikkan Kata Sandi Baru',
      controller: changePasswordController.reNewPasswordFC,
      onShowPassword: () => changePasswordController.showPassword2(),
      secureText: changePasswordController.isObscure2,
      inputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan sandi baru terlebih dahulu';
        }
        if (value != changePasswordController.newPasswordFC.text) {
          return 'Konfirmasi sandi tidak cocok';
        }
        return null;
      },
    );
  }

  Widget _changePasswordBtn() {
    return Container(
      width: Get.width / 1.4,
      child: ElevatedButton(
        onPressed: () => changePasswordController.changePassword(),
        child: Text("Simpan"),
      ),
    );
  }
}
