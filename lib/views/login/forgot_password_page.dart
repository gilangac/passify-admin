// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/auth/forgot_password_controller.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/form_input.dart';

class ForgotPasswordPage extends StatelessWidget {
  final forgotPasswordController = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(title: 'Bantuan Lupa Kata Sandi'),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(30, 80, 30, 30),
      child: Form(
        key: forgotPasswordController.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(),
            SizedBox(height: 16),
            _subtitle(),
            SizedBox(height: 50),
            _emailInput(),
            SizedBox(height: 30),
            _sendBtn(),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text("LUPA KATA SANDI",
        style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20));
  }

  Widget _subtitle() {
    return Text('Masukkan email untuk menerima token verifikasi dari kami.',
        textAlign: TextAlign.center, style: Get.textTheme.bodyText2);
  }

  Widget _emailInput() {
    return formInput(
      placeholder: 'Masukkan email',
      controller: forgotPasswordController.emailFC,
      inputType: TextInputType.emailAddress,
      inputAction: TextInputAction.done,
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

  _sendBtn() {
    return Container(
      width: Get.width / 1.4,
      child: GetPlatform.isIOS
          ? CupertinoButton.filled(
              borderRadius: BorderRadius.circular(12),
              onPressed: () => forgotPasswordController.forgotPassword(),
              child: Text("Kirim"),
            )
          : ElevatedButton(
              onPressed: () => forgotPasswordController.forgotPassword(),
              child: Text("Kirim"),
            ),
    );
  }
}
