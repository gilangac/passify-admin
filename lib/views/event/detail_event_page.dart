import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/event/detail_event_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:passify_admin/widgets/general/comment_widget.dart';
import 'package:passify_admin/widgets/general/dotted_separoator.dart';
import 'package:intl/intl.dart';
import 'package:passify_admin/widgets/shimmer/detail_event_shimmer.dart';

class DetailEventPage extends StatelessWidget {
  DetailEventPage({Key? key}) : super(key: key);
  final DetailEventController detailEventController =
      Get.put(DetailEventController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
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
      child: detailEventController.isLoadingDetail
          ? const SizedBox()
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
                    const Icon(Feather.info, size: 30, color: Colors.white),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        detailEventController.hasReport == 0
                            ? "Belum Pernah dilaporkan"
                            : "${detailEventController.hasReport} kali dilaporkan",
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

  PreferredSizeWidget _appBar() {
    return appBar(title: "Detail Event", actions: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
        child: Container(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () => _bottomSheetContent(
                    detailEventController.detailEvent[0].idUser),
                child: const Icon(Feather.more_horizontal))),
      )
    ]);
  }

  Widget _body() {
    return Obx(() => detailEventController.isLoadingDetail
        ? DetailEventShimmer()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => detailEventController.OnRefresh(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profile(),
                        Divider(
                          height: 5,
                          thickness: 5,
                          color: Colors.grey.shade200,
                        ),
                        _aboutEvent(),
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
                        _comment()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
  }

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(
                AppPages.PROFILE_PERSON +
                    detailEventController.userEvent[0].idUser.toString(),
                arguments:
                    detailEventController.userEvent[0].idUser.toString()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circleAvatar(
                    imageData: detailEventController.userEvent[0].photo,
                    nameData:
                        detailEventController.userEvent[0].name.toString(),
                    size: 22),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detailEventController.userEvent[0].name.toString(),
                      style: GoogleFonts.poppins(
                          height: 1.2,
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      detailEventController.userEvent[0].username.toString(),
                      style: GoogleFonts.poppins(
                          height: 1.2,
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            detailEventController.detailEvent[0].name.toString(),
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _aboutEvent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tentang Event',
                style: GoogleFonts.poppins(
                    color: AppColors.tittleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              dotSeparator(
                color: Colors.grey.shade400,
              ),
              Row(
                children: [
                  const Icon(
                    Feather.map_pin,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    detailEventController.detailEvent[0].location.toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Feather.calendar,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    DateFormat("EEEE, dd MMMM yyyy", "id")
                        .format(detailEventController.detailEvent[0].dateEvent!
                            .toDate())
                        .toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Feather.clock,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    detailEventController.detailEvent[0].time.toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Feather.users,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: Get.width - 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailEventController.detailEvent[0].member!
                                  .toString() +
                              " Partisipan",
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => _participantEvent(),
                          child: Text(
                            'Lihat Partisipan',
                            style: GoogleFonts.poppins(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
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
            detailEventController.detailEvent[0].description.toString(),
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

  Widget _comment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Komentar (' +
                    detailEventController.commentEvent.length.toString() +
                    ')',
                style: GoogleFonts.poppins(
                    color: AppColors.tittleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
            ],
          ),
          dotSeparator(
            color: Colors.grey.shade400,
          ),
          detailEventController.commentEvent.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: detailEventController.commentEvent.length,
                  itemBuilder: ((context, index) {
                    return commentWidget(
                        comment: detailEventController
                            .commentEvent[index].comment
                            .toString(),
                        idUser:
                            detailEventController.commentEvent[index].idUser,
                        date: detailEventController.commentEvent[index].date,
                        nama: detailEventController.commentEvent[index].name,
                        photo: detailEventController.commentEvent[index].photo,
                        sort: detailEventController.commentEvent[index].sort,
                        username:
                            detailEventController.commentEvent[index].username);
                  }))
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Belum ada komentar",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: AppColors.tittleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Jadilah yang pertama mengomentari event ini",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(height: 400)
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _participantEvent() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar(),
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: detailEventController.memberEvent.length,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                              AppPages.PROFILE_PERSON +
                                  detailEventController
                                      .memberEvent[index].idUser
                                      .toString(),
                              arguments: detailEventController
                                  .memberEvent[index].idUser
                                  .toString()),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    circleAvatar(
                                        imageData: detailEventController
                                            .memberEvent[index].photo
                                            .toString(),
                                        nameData: detailEventController
                                            .memberEvent[index].name
                                            .toString(),
                                        size: 20),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: Get.width * 0.55,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            detailEventController
                                                .memberEvent[index].name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                color: AppColors.tittleColor,
                                                height: 1.2,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            detailEventController
                                                .memberEvent[index].username
                                                .toString(),
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
                                    const Spacer(),
                                    Obx(() => detailEventController
                                                .memberEvent[index].idUser ==
                                            detailEventController
                                                .detailEvent[0].idUser
                                        ? Text(
                                            "Pembuat",
                                            style: GoogleFonts.poppins(
                                                height: 1.2,
                                                color: Colors.grey.shade500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : const SizedBox(height: 0)),
                                  ],
                                ),
                                const SizedBox(
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
      shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: Radius.circular(20))),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  Widget _actionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                padding: const EdgeInsets.all(6),
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
                child: const Icon(Feather.x, size: 24)),
          ),
          const Spacer(),
          const Text(
            "Partisipan Event",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            width: 35,
          ),
        ],
      ),
    );
  }

  void _bottomSheetContent(var idUser) {
    String myId = detailEventController.myAccountId.value;
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                const SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Divider(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                            _deleteAction(),
                          ],
                        )
                      ],
                    )),
                const SizedBox(height: 13),
                _cancelAction()
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

  Widget _listAction({
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
            if (type == "edit") {
            } else if (type == 'report') {
              DialogHelper.showConfirm(
                  title: "Laporkan Event",
                  description: "Apakah anda yakin akan melaporkan event ini?",
                  // action: () => detailEventController.onReportEvent(),
                  titlePrimary: "Laporkan",
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
                  color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteAction({String? title, String? path}) {
    return Container(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            DialogHelper.showConfirm(
                title: "Hapus Event",
                description:
                    "Apa anda yakin menghapus event ini? Dengan menghapus event semua data event akan terhapus dan tidak dapat dikembalikan lagi.",
                titlePrimary: "Hapus",
                titleSecondary: "Batal",
                action: () => detailEventController.onDeleteEvent());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Hapus Event",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.red.shade500),
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
