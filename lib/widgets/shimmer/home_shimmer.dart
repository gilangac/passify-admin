// ignore_for_file: sized_box_for_whitespace, must_be_immutable, prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  HomeShimmer({Key? key}) : super(key: key);
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return homeController.onGetData();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                _searchBox(),
                const SizedBox(
                  height: 20,
                ),
                _content(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width * 0.4,
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: Get.width * 0.2,
                height: 13,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.inputBoxColor),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Icon(
                  Feather.menu,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: Get.width,
        height: 50,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.inputBoxColor),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text('Cari ...',
              style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  Widget _content() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width * 0.25,
            height: 13,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(AppPages.ACCOUNT),
                child: Stack(
                  children: [
                    Container(
                      height: Get.height * 0.125,
                      width: (Get.width - 50) * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.green),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        top: 10,
                        child: Center(
                          child: Text('AKUN',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ))
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed(AppPages.EVENT),
                child: Stack(
                  children: [
                    Container(
                      height: Get.height * 0.125,
                      width: (Get.width - 50) * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.yellow),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        top: 10,
                        child: Center(
                          child: Text('EVENT',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(AppPages.COMMUNITY),
                child: Stack(
                  children: [
                    Container(
                      height: Get.height * 0.125,
                      width: (Get.width - 50) * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.tosca),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        top: 10,
                        child: Center(
                          child: Text('KOMUNITAS',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ))
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () => Get.toNamed(AppPages.REPORT),
                  child: Stack(
                    children: [
                      Container(
                        height: Get.height * 0.125,
                        width: (Get.width - 50) * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.orange),
                      ),
                      Positioned(
                          bottom: 10,
                          right: 10,
                          left: 10,
                          top: 10,
                          child: Center(
                            child: Text('LAPORAN',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                          ))
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
