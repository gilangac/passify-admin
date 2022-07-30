// ignore_for_file: must_be_immutable, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/profile/account_controller.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:passify_admin/widgets/shimmer/search_person_shimmer.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key}) : super(key: key);
  AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Akun Pengguna");
  }

  Widget _body() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: accountController.isLoading
          ? SearchPersonShimmer()
          : accountController.personData.isEmpty
              ? RefreshIndicator(
                  onRefresh: () {
                    HapticFeedback.lightImpact();
                    return accountController.onGetPerson();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Text(
                            'Tidak Ada Data Akun',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black),
                          ),
                          Text(
                            'Tidak ada data akun yang terdaftar',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.black45),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          HapticFeedback.lightImpact();
                          return accountController.onGetPerson();
                        },
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: accountController.personData.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            itemBuilder: ((context, index) {
                              var data = accountController.personData[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                        AppPages.PROFILE_PERSON +
                                            data.idUser.toString(),
                                        arguments: data.idUser.toString());
                                  },
                                  child: Row(
                                    children: [
                                      circleAvatar(
                                          imageData: data.photo,
                                          nameData: data.name.toString(),
                                          size: 25),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.name.toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            data.username.toString(),
                                            style: GoogleFonts.poppins(
                                                color: Colors.grey.shade500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                      ),
                    ),
                  ],
                ),
    );
  }
}
