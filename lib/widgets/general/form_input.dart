// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/constant/color_constant.dart';

Widget formInput(
    {String? initialValue,
    required String placeholder,
    required controller,
    required TextInputType inputType,
    required TextInputAction inputAction,
    bool secureText = false,
    bool enabled = true,
    required validator}) {
  return Column(
    children: [
      TextFormField(
        initialValue: initialValue,
        controller: controller,
        onChanged: (text) => {},
        keyboardType: inputType,
        textInputAction: inputAction,
        obscureText: secureText,
        enabled: enabled,
        decoration: InputDecoration(
            hintText: placeholder,
            focusedBorder: myfocusborder(),
            // errorBorder: myfocusErrorBorder(),
            focusedErrorBorder: myfocusErrorBorder()),
        autovalidateMode: AutovalidateMode.onUserInteraction,
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

OutlineInputBorder myfocusErrorBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.red.shade400,
        width: 1,
      ));
}

Widget formInput2(
    {required String title,
    String? initialValue,
    required String placeholder,
    FocusNode? focusNode,
    required dynamic controller,
    required TextInputType inputType,
    required TextInputAction inputAction,
    bool secureText = false,
    bool enabled = true,
    required dynamic validator}) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Get.textTheme.subtitle2),
      ),
      SizedBox(height: 8),
      TextFormField(
        initialValue: initialValue,
        focusNode: focusNode,
        controller: controller,
        onChanged: (text) => {},
        keyboardType: inputType,
        textInputAction: inputAction,
        obscureText: secureText,
        enabled: enabled,
        decoration: InputDecoration(hintText: placeholder),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      ),
    ],
  );
}
