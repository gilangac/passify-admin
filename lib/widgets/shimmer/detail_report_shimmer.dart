// ignore_for_file: sized_box_for_whitespace, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class DetailReportShimmer extends StatelessWidget {
  DetailReportShimmer({Key? key}) : super(key: key);
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    _header(),
                    const SizedBox(
                      height: 20,
                    ),
                    _header(),
                    const SizedBox(
                      height: 20,
                    ),
                    _header(),
                    const SizedBox(
                      height: 20,
                    ),
                    _header(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _searchBox(),
        ),
      ],
    );
  }

  Widget _header() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width * 0.2,
            height: 12,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: Get.width * 0.4,
            height: 13,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      width: Get.width,
      height: 50,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.inputBoxColor),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: Get.width * 0.3,
              height: 12,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}
