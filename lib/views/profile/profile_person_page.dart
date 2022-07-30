// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/profile/profile_person_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:passify_admin/widgets/general/community_widget.dart';
import 'package:passify_admin/widgets/general/event_widget.dart';
import 'package:intl/intl.dart';
import 'package:passify_admin/widgets/shimmer/profile_shimmer.dart';

class ProfilePersonPage extends StatelessWidget {
  ProfilePersonPage({Key? key}) : super(key: key);
  ProfilePersonController profileC = Get.put(ProfilePersonController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _body(),
          backgroundColor: Colors.white,
          floatingActionButton: _fab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }

  Widget _fab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: profileC.isLoading
          ? SizedBox()
          : Column(
              children: [
                Spacer(),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.95),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Feather.info, size: 30, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            profileC.hasReport == 0
                                ? "Belum pernah dilaporkan"
                                : "${profileC.hasReport} kali dilaporkan",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                profileC.dataUser[0].status == 1
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          _bottomSheetContent();
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red.shade500.withOpacity(0.9),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Feather.alert_circle,
                                    size: 30, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Pengguna dinonaktifkan",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
    );
  }

  List<Widget> _action() {
    return [
      GestureDetector(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Feather.more_horizontal, size: 24)),
        onTap: () {
          _bottomSheetContent();
        },
      )
    ];
  }

  Widget _body() {
    return profileC.isLoading
        ? ProfileShimmer()
        : DefaultTabController(
            length: 2,
            child: NestedScrollView(
                physics: BouncingScrollPhysics(),
                headerSliverBuilder: (context, index) {
                  return <Widget>[
                    SliverAppBar(
                      title: Text(
                          '@${profileC.dataUser[0].username.toString()}',
                          style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      actions: _action(),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      pinned: true,
                      elevation: 1,
                      forceElevated: true,
                      primary: true,
                      expandedHeight: 325,
                      flexibleSpace:
                          FlexibleSpaceBar(background: _profileInfo()),
                      bottom: TabBar(
                        isScrollable: false,
                        indicatorColor: AppColors.primaryColor,
                        indicatorWeight: 2.0,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
                        labelColor: AppColors.primaryColor,
                        unselectedLabelColor: AppColors.textColor,
                        tabs: [
                          Tab(
                            height: 50,
                            child: Column(
                              children: [
                                Text(profileC.dataCommunity.length.toString(),
                                    style: GoogleFonts.poppins(
                                        color: AppColors.tittleColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                Text("Komunitas",
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Tab(
                            height: 50,
                            child: Column(
                              children: [
                                Text(profileC.dataEvent.length.toString(),
                                    style: GoogleFonts.poppins(
                                        color: AppColors.tittleColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                Text("Event",
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ];
                },
                body: _content()),
          );
  }

  Widget _profileInfo() {
    final dataUser = profileC.dataUser[0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () => profileC.onRefresh(),
          child: circleAvatar(
              imageData: dataUser.photo.toString(),
              nameData: dataUser.name.toString(),
              size: 45),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          profileC.name.toString(),
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.tittleColor),
        ),
        Text(
          dataUser.hobby!.length == 1
              ? dataUser.hobby![0].toString()
              : dataUser.hobby!.length == 2
                  ? dataUser.hobby![0].toString() +
                      " | " +
                      dataUser.hobby![1].toString()
                  : dataUser.hobby![0].toString() +
                      " | " +
                      dataUser.hobby![1].toString() +
                      " | " +
                      dataUser.hobby![2].toString(),
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileC.dataUser[0].instagram == ''
                ? SizedBox(
                    height: 0,
                  )
                : GestureDetector(
                    onTap: () => profileC.onLaunchUrl(
                        'instagram', profileC.dataUser[0].instagram.toString()),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Icon(
                            Feather.instagram,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              width: 10,
            ),
            profileC.dataUser[0].twitter == ''
                ? SizedBox(
                    height: 0,
                  )
                : GestureDetector(
                    onTap: () => profileC.onLaunchUrl(
                        'twitter', profileC.dataUser[0].twitter.toString()),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Feather.twitter,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _content() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return profileC.onRefresh();
      },
      child: TabBarView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [_community(), _event()]),
    );
  }

  Widget _event() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return profileC.onRefresh();
      },
      child: profileC.dataEvent.isEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    LottieBuilder.asset("assets/json/empty_data.json",
                        height: 180),
                    Text(
                      "Belum ada event yang diikuti",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(height: 100)
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: profileC.dataEvent.length,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.all(25),
              itemBuilder: (context, index) {
                var data = profileC.dataEvent[index];
                return eventCard(
                    idEvent: data.idEvent,
                    name: data.name,
                    description: data.description,
                    date: DateFormat("EEEE, dd MMMM yyyy", "id")
                        .format(data.dateEvent!.toDate())
                        .toString(),
                    location: data.location,
                    time: data.time,
                    category: data.category,
                    commentCount: data.comment.toString(),
                    membersCount: data.member?.toString());
              }),
    );
  }

  Widget _community() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return profileC.onRefresh();
      },
      child: profileC.dataCommunity.isEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    LottieBuilder.asset("assets/json/empty_data.json",
                        height: 180),
                    Text(
                      "Belum ada komunitas yang diikuti",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(height: 100)
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: profileC.dataCommunity.length,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              padding: EdgeInsets.all(25),
              itemBuilder: (context, index) {
                var data = profileC.dataCommunity[index];
                return communityCard(
                    idCommunity: data.idCommunity,
                    category: data.category,
                    city: data.city,
                    name: data.name,
                    photo: data.photo,
                    membere: data.member);
              }),
    );
  }

  void _bottomSheetContent() {
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
                        profileC.dataUser[0].status == 0
                            ? _listAction(
                                title: "Aktifkan Pengguna", type: "enable")
                            : _listAction(
                                title: "Nonaktifkan Pengguna", type: "disable"),
                      ],
                    )),
                SizedBox(height: 13),
                _cancelAction()
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listAction({
    required String title,
    String? type,
  }) {
    return Container(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (type == 'enable') {
              Get.back();
              DialogHelper.showConfirm(
                  title: "Aktifkan Pengguna",
                  description:
                      "Apakah anda yakin akan mengaktifkan pengguna ini?",
                  action: () {
                    Get.back();
                    profileC.onEnableUser();
                  },
                  titlePrimary: "Aktifkan",
                  titleSecondary: "Batal");
            } else if (type == 'disable') {
              Get.back();
              DialogHelper.showConfirm(
                  title: "Nonaktifkan Pengguna",
                  description:
                      "Apakah anda yakin akan menonaktifkan pengguna ini?",
                  action: () {
                    Get.back();
                    profileC.onDisableUser();
                  },
                  titlePrimary: "Nonaktifkan",
                  titleSecondary: "Batal");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.red.shade300),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelAction() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
      child: Material(
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor),
                textAlign: TextAlign.center,
              ),
            )),
        color: Colors.transparent,
      ),
    );
  }
}
