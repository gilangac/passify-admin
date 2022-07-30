// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/auth/login_controller.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/widgets/general/form_input.dart';
import 'package:passify_admin/widgets/general/form_input_password.dart';

class LoginPage extends StatelessWidget {
  final loginController = Get.put(LoginController());
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
        child: Form(
          key: loginController.formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              _logo(),
              _emailInput(),
              const SizedBox(height: 20),
              _passwordInput(),
              const SizedBox(height: 20),
              _goToForgotPassword(),
              const SizedBox(height: 40),
              _loginBtn(),
              const SizedBox(height: 50),
              // _goToRegisterBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
        margin: const EdgeInsets.only(top: 50, bottom: 50),
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text('ADMIN',
                  style: GoogleFonts.poppins(
                      color: AppColors.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/images/title_passify.png",
                width: Get.width * 0.40,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ));
  }

  Widget _goToForgotPassword() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppPages.FORGOT_PASSWORD),
      child: Container(
          alignment: Alignment.centerRight,
          child: Text('Lupa kata sandi ?',
              style: GoogleFonts.poppins(color: AppColors.primaryColor))),
    );
  }

  Widget _emailInput() {
    return formInput(
      placeholder: 'Email',
      controller: loginController.emailFC,
      inputType: TextInputType.emailAddress,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan email terlebih dahulu';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Masukkan email dengan benar';
        }
        return null;
      },
    );
  }

  Widget _passwordInput() {
    return Obx(
      () => formInputPassword(
        placeholder: 'Masukkan kata sandi',
        controller: loginController.passwordFC,
        inputAction: TextInputAction.done,
        secureText: loginController.isObscure,
        onShowPassword: () {
          loginController.showPassword();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan kata sandi terlebih dahulu';
          }
          return null;
        },
      ),
    );
  }

  Widget _loginBtn() {
    return SizedBox(
      width: Get.width / 1.4,
      child: GetPlatform.isIOS
          ? CupertinoButton.filled(
              borderRadius: BorderRadius.circular(12),
              onPressed: () {
                loginController.onLogin();
              },
              child: const Text("Masuk"),
            )
          : ElevatedButton(
              onPressed: () {
                loginController.onLogin();
              },
              child: const Text("Masuk"),
            ),
    );
  }

  Widget _goToRegisterBtn() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Belum punya akun?",
            style: Get.textTheme.subtitle1,
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              // Get.toNamed(AppPages.REGISTER);
            },
            child: Text(
              "Daftar",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
