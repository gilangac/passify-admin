// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_unnecessary_containers

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/community/detail_community_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:passify_admin/widgets/general/dotted_separoator.dart';
import 'package:passify_admin/widgets/general/post_card_widget.dart';
import 'package:passify_admin/widgets/shimmer/detail_community_shimmer.dart';
import 'package:passify_admin/widgets/shimmer/post_shimmer.dart';

class DetailCommunityPage extends StatelessWidget {
  DetailCommunityPage({Key? key}) : super(key: key);

  DetailCommunityController detailCommunityC =
      Get.put(DetailCommunityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: detailCommunityC.isLoadingDetail.value ? _appBar() : null,
          body: _body(),
          floatingActionButton: _fab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "");
  }

  Widget _fab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: detailCommunityC.isLoadingDetail.value
          ? SizedBox()
          : Container(
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
                        detailCommunityC.hasReport == 0
                            ? "Belum Pernah dilaporkan"
                            : "${detailCommunityC.hasReport} kali dilaporkan",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
    );
  }

  void handleClick(int value, {String? idUser}) {
    switch (value) {
      case 0:
        _communityMembers(
            detailCommunityC.memberWaiting, "Permintaan Bergabung");
        break;
      case 1:
        DialogHelper.showConfirm(
            title: "Hapus Komunitas",
            description: "Apakah anda yakin akan menghapus komunitas?",
            action: () => detailCommunityC.onDeleteCommunity(),
            titlePrimary: "Hapus",
            titleSecondary: "Batal");

        break;
      case 2:
        break;
    }
  }

  Widget _popUpMenu() {
    return Stack(children: [
      Container(
        child: PopupMenuButton<int>(
          child: Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(right: 10, top: 14, bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Feather.more_horizontal,
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (item) => handleClick(item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Badge(
                      showBadge:
                          detailCommunityC.memberWaiting.isEmpty ? false : true,
                      position: BadgePosition.topEnd(top: -8, end: -17),
                      badgeContent: Text(
                          detailCommunityC.memberWaiting.length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10)),
                      child: Text('Permintaan Gabung'),
                      animationType: BadgeAnimationType.scale,
                      animationDuration: Duration(milliseconds: 300),
                    ),
                  ],
                )),
            PopupMenuItem<int>(
                value: 1,
                child: Text('Hapus Komunitas',
                    style: GoogleFonts.poppins(color: Colors.red.shade300))),
          ],
        ),
      )
    ]);
  }

  Widget _body() {
    return Obx(() => !detailCommunityC.isLoadingDetail.value
        ? NestedScrollView(
            controller: detailCommunityC.controller,
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leadingWidth: 60,
                actions: [_popUpMenu()],
                leading: AnimatedOpacity(
                  duration: Duration(milliseconds: 100),
                  opacity: 1,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, top: 14, bottom: 14, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Feather.arrow_left,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: const [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                      },
                      child: Obx(
                        () => detailCommunityC.detailCommunity[0].photo == ""
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                      AppColors.primaryColor,
                                      AppColors.accentColor.withOpacity(0.8)
                                    ])),
                                child: Center(
                                  child: Image(
                                      image: AssetImage(
                                          "assets/images/logo_icon.png")),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: detailCommunityC
                                    .detailCommunity[0].photo
                                    .toString(),
                                width: Get.width,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Center(child: Icon(Icons.error)),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      color: AppColors.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                      )),
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Obx(() => AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        child: Padding(
                          padding: detailCommunityC.isExtends.value
                              ? EdgeInsets.symmetric(horizontal: 0)
                              : EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            detailCommunityC.detailCommunity[0].name.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),
                ),
                automaticallyImplyLeading: true,
                toolbarHeight: 70,
                elevation: 1,
                expandedHeight: 230,
                backgroundColor: Colors.white,
                pinned: true,
              ),
            ],
            body: Obx(() => RefreshIndicator(
                  onRefresh: () {
                    HapticFeedback.vibrate();
                    return detailCommunityC.onRefresh();
                  },
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            _infoCommunity(),
                            Divider(
                              height: 5,
                              thickness: 5,
                              color: Colors.grey.shade200,
                            ),
                            _description(),
                            Divider(
                              height: 5,
                              thickness: 5,
                              color: Colors.grey.shade200,
                            ),
                            _content(),
                          ],
                        )),
                  ),
                )),
          )
        : Center(child: DetailCommunityShimmer()));
  }

  Widget _infoCommunity() {
    var data = detailCommunityC.detailCommunity[0];
    var member = detailCommunityC.memberCommunity;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Feather.map_pin,
                color: AppColors.primaryColor,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                data.city.toString() + ", " + data.province.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Feather.user,
                color: AppColors.primaryColor,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Row(
                children: [
                  Text(
                    "Ketua Komunitas : ",
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    detailCommunityC.nameUser.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Feather.users,
                color: AppColors.primaryColor,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                detailCommunityC.memberCommunity.length.toString() + " Anggota",
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w400),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _communityMembers(
                    detailCommunityC.memberCommunity, "Anggota Komunitas"),
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 30,
                child: Row(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: member.length > 7 ? 7 : member.length,
                      itemBuilder: (context, index) {
                        return Align(
                          widthFactor: 0.7,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.inputBoxColor,
                            child: circleAvatar(
                                imageData: member[index].photo.toString(),
                                nameData: member[index].name.toString(),
                                size: 15),
                          ),
                        );
                      },
                    ),
                    if (member.length > 7)
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          '+${member.length - 7}',
                          style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          dotSeparator(
            color: Colors.grey.shade400,
          ),
          Text(
            detailCommunityC.detailCommunity[0].description.toString(),
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.red,
                  onTap: () => detailCommunityC.isDiscusion.value = true,
                  child: Ink(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: detailCommunityC.isDiscusion.value
                              ? Colors.grey.shade700
                              : Colors.grey.shade200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 20),
                        child: Center(
                          child: Text(
                            "Diskusi",
                            style: GoogleFonts.poppins(
                                color: detailCommunityC.isDiscusion.value
                                    ? Colors.white
                                    : AppColors.textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => detailCommunityC.isDiscusion.value = false,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: detailCommunityC.isDiscusion.value
                          ? Colors.grey.shade200
                          : Colors.grey.shade700),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    child: Center(
                      child: Text(
                        "Jual - beli",
                        style: GoogleFonts.poppins(
                            color: detailCommunityC.isDiscusion.value
                                ? AppColors.textColor
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          detailCommunityC.isDiscusion.value ? _disccusion() : _fjb()
        ],
      ),
    );
  }

  List post = [
    {'foto': "", 'name': 'Taesei Marukawa'},
    {'foto': "ada", 'name': 'Gilang Ahmad Chaeral'},
    {'foto': "", 'name': 'Leonel Messi'},
    {'foto': "ada", 'name': 'Adama Traore'},
    {'foto': "", 'name': 'Mark Marques'},
    {'foto': "ada", 'name': 'Valentino Jebret'}
  ];

  Widget _disccusion() {
    return Column(
      children: [
        detailCommunityC.isLoadingPost.value
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    PostShimmer(),
                  ],
                ),
              )
            : detailCommunityC.dataDisccusion.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Belum ada postingan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Silahkan refresh halaman atau buat postingan anda",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(height: 400)
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    itemCount: detailCommunityC.dataDisccusion.length,
                    itemBuilder: (context, index) {
                      var data = detailCommunityC.dataDisccusion[index];
                      return postCard(
                          idPost: data.idPost,
                          idUser: data.idUser,
                          title: data.title,
                          price: data.price,
                          status: data.status,
                          name: data.name,
                          username: data.username,
                          photoUser: data.photoUser,
                          idCommunity: data.idCommunity.toString(),
                          caption: data.caption,
                          photo: data.photo,
                          category: data.category,
                          date: data.date!.toDate(),
                          comment: data.comment);
                    }),
      ],
    );
  }

  Widget _fjb() {
    return Column(
      children: [
        SizedBox(
          height: 0,
        ),
        detailCommunityC.isLoadingPost.value
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    PostShimmer(),
                  ],
                ),
              )
            : detailCommunityC.dataFjb.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Belum ada postingan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Silahkan refresh halaman atau buat postingan anda",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(height: 400)
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    itemCount: detailCommunityC.dataFjb.length,
                    itemBuilder: (context, index) {
                      var data = detailCommunityC.dataFjb[index];
                      var number = "";
                      if (data.noHp.toString() != "" &&
                          data.noHp.toString()[0] == "0") {
                        number = (data.noHp)!.substring(1);
                      } else {
                        number = data.noHp.toString();
                      }
                      return postCard(
                          idPost: data.idPost,
                          idUser: data.idUser,
                          title: data.title,
                          price: data.price,
                          status: data.status,
                          name: data.name,
                          username: data.username,
                          photoUser: data.photoUser,
                          caption: data.caption,
                          idCommunity: data.idCommunity.toString(),
                          category: data.category,
                          photo: data.photo,
                          number: number,
                          date: data.date!.toDate(),
                          comment: data.comment);
                    }),
      ],
    );
  }

  void _communityMembers(var dataMember, var title) {
    var member = dataMember;
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
                                    Obx(() => detailCommunityC
                                                .detailCommunity[0].idUser ==
                                            member[index].idUser
                                        ? Text(
                                            "Pembuat",
                                            style: GoogleFonts.poppins(
                                                height: 1.2,
                                                color: Colors.grey.shade500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : detailCommunityC.isCreator.value &&
                                                title != "Permintaan Bergabung"
                                            ? PopupMenuButton<int>(
                                                child: Container(
                                                  child: Center(
                                                    child: Icon(
                                                      Feather.more_vertical,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                onSelected: (item) =>
                                                    handleClick(item,
                                                        idUser: member[index]
                                                            .idUser),
                                                itemBuilder: (context) => [
                                                      PopupMenuItem<int>(
                                                          value: 6,
                                                          child: Text(
                                                            'Keluarkan dari komunitas',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .red
                                                                        .shade300),
                                                          )),
                                                    ])
                                            : SizedBox()),
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
