import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:passify_admin/constant/color_constant.dart';

Widget formInputPassword(
    {required String placeholder,
    required controller,
    required TextInputAction inputAction,
    required bool secureText,
    required onShowPassword,
    required validator}) {
  return Column(
    children: [
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: inputAction,
        obscureText: secureText,
        decoration: InputDecoration(
          hintText: placeholder,
          focusedBorder: myfocusborder(),
          suffixIcon: IconButton(
            splashRadius: 1,
            padding: const EdgeInsets.only(right: 20),
            iconSize: 22,
            color: Colors.grey,
            onPressed: onShowPassword,
            icon: secureText
                ? const Icon(Feather.eye)
                : const Icon(Feather.eye_off),
          ),
        ),
        validator: validator,
      ),
    ],
  );
}

OutlineInputBorder myfocusborder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: AppColors.primaryColor,
        width: 1,
      ));
}

Widget formInputPassword2(
    {required String title,
    required String placeholder,
    required controller,
    required TextInputAction inputAction,
    required bool secureText,
    required onShowPassword,
    required validator}) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Get.textTheme.subtitle2),
      ),
      SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: inputAction,
        obscureText: secureText,
        decoration: InputDecoration(
          hintText: placeholder,
          suffixIcon: IconButton(
            padding: EdgeInsets.only(right: 20),
            iconSize: 22,
            color: Colors.grey,
            onPressed: onShowPassword,
            icon: secureText ? Icon(Feather.eye) : Icon(Feather.eye_off),
          ),
        ),
        validator: validator,
      ),
    ],
  );
}
