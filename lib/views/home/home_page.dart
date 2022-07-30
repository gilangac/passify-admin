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
import 'package:passify_admin/models/user.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:passify_admin/widgets/shimmer/home_shimmer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    return Obx(() => RefreshIndicator(
          onRefresh: () {
            HapticFeedback.lightImpact();
            return homeController.onGetData();
          },
          child: homeController.isLoading
              ? HomeShimmer()
              : SingleChildScrollView(
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
        ));
  }

  Widget _header() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Datang!',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
            Text('Admin',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const Spacer(),
        Obx(() => Badge(
              showBadge: homeController.hasRequest.value,
              badgeColor: Colors.red.shade300,
              position: BadgePosition.topEnd(top: -10, end: -6),
              badgeContent: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(homeController.dataUserRequest.length.toString(),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              animationType: BadgeAnimationType.scale,
              animationDuration: Duration(milliseconds: 300),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _bottomSheetContentProfile(),
                    child: Container(
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
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Widget _searchBox() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppPages.SEARCH),
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Layanan',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                        child: Image.asset(
                          "assets/images/bg1.png",
                          fit: BoxFit.cover,
                        ),
                      ),
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                        child: Image.asset(
                          "assets/images/bg2.png",
                          fit: BoxFit.cover,
                        ),
                      ),
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                        child: Image.asset(
                          "assets/images/bg3.png",
                          fit: BoxFit.cover,
                        ),
                      ),
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
                child: Obx(() => Badge(
                      showBadge: homeController.hasNotification.value,
                      badgeColor: AppColors.primaryColor,
                      position: BadgePosition.topEnd(top: -10, end: -6),
                      badgeContent: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(homeController.countBadge.value.toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                      animationType: BadgeAnimationType.scale,
                      animationDuration: Duration(milliseconds: 300),
                      child: Stack(
                        children: [
                          Container(
                            height: Get.height * 0.125,
                            width: (Get.width - 50) * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.orange),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                              child: Image.asset(
                                "assets/images/bg4.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                      ),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  void _bottomSheetContentProfile() {
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _listAction2(
                                icon: Feather.check_circle,
                                title: "Permintaan Verifikasi",
                                path: AppPages.CHANGE_PASSWORD,
                                type: "request"),
                            if (homeController.dataUserRequest.isNotEmpty)
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: Colors.red.shade300),
                                    child: Center(
                                        child: Text(
                                            homeController
                                                .dataUserRequest.length
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))),
                                  ))
                          ],
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        _listAction2(
                            icon: Feather.edit,
                            title: "Ganti Password",
                            path: AppPages.CHANGE_PASSWORD,
                            type: "change"),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        _listAction2(
                            icon: Feather.info,
                            title: "Tentang Aplikasi",
                            path: AppPages.HOME,
                            type: "about"),
                      ],
                    )),
                SizedBox(height: 13),
                _logoutAction()
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listAction2({
    IconData? icon,
    required String title,
    required String path,
    String? type,
  }) {
    return Container(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            type == "about"
                ? DialogHelper.showInfo()
                : type == "request"
                    ? _communityMembers(
                        homeController.dataUserRequest, "Permintaan Verifikasi")
                    : Get.toNamed(path);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              minLeadingWidth: 0,
              leading: Icon(icon),
              title: Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor),
              ),
              trailing: const Icon(Feather.chevron_right),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutAction() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            DialogHelper.showConfirm(
                title: "Logout",
                description: "Anda yakin akan keluar aplikasi?",
                titlePrimary: "Logout",
                titleSecondary: "Batal",
                action: () {
                  homeController.signOut();
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              minLeadingWidth: 0,
              leading: Icon(Feather.log_out, color: Colors.red.shade400),
              title: Text(
                "Keluar",
                style: GoogleFonts.poppins(color: Colors.red.shade400),
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  void _communityMembers(var dataMember, var title) {
    List<UserModel> member = dataMember;
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar(title),
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: member.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                              AppPages.PROFILE_PERSON +
                                  member[index].idUser.toString(),
                              arguments: member[index].idUser.toString()),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    circleAvatar(
                                        imageData: member[index].photo,
                                        nameData: member[index].name.toString(),
                                        size: 20),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: Get.width - 160,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member[index].name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color: AppColors.tittleColor,
                                                height: 1.2,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            member[index].username.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                height: 1.2,
                                                color: Colors.grey.shade500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    title == "Permintaan Verifikasi"
                                        ? Container(
                                            width: 60,
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Icon(Feather.check,
                                                        color: Colors
                                                            .green.shade300),
                                                    onTap: () {
                                                      DialogHelper.showConfirm(
                                                          title:
                                                              "Terima Permintaan",
                                                          description:
                                                              "Apakah anda yakin akan menerima permintaan verifikasi akun?",
                                                          action: () => homeController
                                                              .onAccRequest(
                                                                  member[index]
                                                                      .idUser),
                                                          titlePrimary:
                                                              "Terima",
                                                          titleSecondary:
                                                              "Batal");
                                                    }),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Icon(Feather.x,
                                                        color: Colors
                                                            .red.shade300),
                                                    onTap: () {
                                                      DialogHelper.showConfirm(
                                                          title:
                                                              "Tolak Permintaan",
                                                          description:
                                                              "Apakah anda yakin akan menolak permintaan verifikasi akun?",
                                                          action: () => homeController
                                                              .onRejectRequest(
                                                                  member[index]
                                                                      .idUser),
                                                          titlePrimary: "Tolak",
                                                          titleSecondary:
                                                              "Batal");
                                                    })
                                              ],
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 1,
                                  width: Get.width,
                                  color: Colors.grey.shade200,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  Widget _actionBar(var title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // eventC.onClearFC();
              Get.back();
            },
            child: Container(
                width: 35,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 4,
                        spreadRadius: 6)
                  ],
                ),
                child: Icon(Feather.x, size: 24)),
          ),
          Spacer(),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Container(
            width: 35,
          ),
        ],
      ),
    );
  }
}
