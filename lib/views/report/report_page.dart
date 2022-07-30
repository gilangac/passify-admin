// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/models/report.dart';
import 'package:passify_admin/services/service_additional.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:intl/intl.dart';
import 'package:passify_admin/widgets/general/slideable_panel.dart';
import 'package:passify_admin/widgets/shimmer/report_shimmer.dart';

class ReportPage extends StatelessWidget {
  ReportPage({Key? key}) : super(key: key);
  HomeController controller = Get.find();
  final Stream<QuerySnapshot> report = FirebaseFirestore.instance
      .collection('reports')
      .orderBy("idReport", descending: true)
      .snapshots();
  List messageReport = [
    "melaporkan event ",
    "melaporkan komunitas ",
    "melaporkan postingan ",
    "melaporkan akun ",
  ];
  List typeCode = ["events", "communities", "post", "users"];
  List typeName = ["name", "name", "title", "username"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Laporan");
  }

  Widget _body() {
    return StreamBuilder(
        stream: report,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Container();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ReportShimmer();
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Tidak ada koneksi internet',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black)));
          }
          if (!snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () {
                HapticFeedback.lightImpact();
                return controller.onGetData();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Text(
                          'Tidak Ada Data Laporan',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black),
                        ),
                        Text(
                          'Tidak ada data laporan yang diterima',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black45),
                          textAlign: TextAlign.center,
                        ),
                        Container(height: 300)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              HapticFeedback.lightImpact();
              return controller.onGetData();
            },
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 30),
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return Slidable(
                    enabled: true,
                    closeOnScroll: true,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableActionCustom(
                          flex: 2,
                          spacing: 1,
                          onPressed: (context) {
                            DialogHelper.showConfirm(
                                title: "Hapus Laporan",
                                description:
                                    "Anda yakin akan menghapus laporan?",
                                titlePrimary: "Hapus",
                                titleSecondary: "Batal",
                                action: () =>
                                    controller.onDeleteNotif(data['idReport']));
                          },
                          autoClose: true,
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Feather.trash,
                          label: 'Hapus',
                        ),
                        // SlidableActionCustom(
                        //   flex: 2,
                        //   spacing: 1,
                        //   onPressed: (context) {
                        //     data.readAt =
                        //         Timestamp.fromDate(DateTime.now());
                        //     notificationController
                        //         .onReadNotif(data.idNotification);
                        //   },
                        //   autoClose: true,
                        //   backgroundColor: Colors.grey,
                        //   foregroundColor: Colors.white,
                        //   icon: Feather.check,
                        //   label: 'Terbaca',
                        // ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => controller.onClickNotif(
                          data['idReport'].toString(),
                          data['code'].toString(),
                          data['category']!),
                      child: Container(
                        color: data['readAt'] == null
                            ? Colors.blue.shade50.withOpacity(0.6)
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  child: Container(
                                      width: Get.width,
                                      child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(data['idFromUser'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox();
                                          } else {
                                            return StreamBuilder<
                                                DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(typeCode[
                                                      data['category']!])
                                                  .doc(data['code'])
                                                  .snapshots(),
                                              builder: (context, typeSnapshot) {
                                                if (typeSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const SizedBox();
                                                } else {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      circleAvatar(
                                                          imageData: snapshot
                                                                  .hasData
                                                              ? snapshot.data!.get(
                                                                      "photoUser") ??
                                                                  ""
                                                              : "",
                                                          nameData: snapshot
                                                                  .hasData
                                                              ? snapshot.data!.get(
                                                                      "name") ??
                                                                  ""
                                                              : "",
                                                          size: 28),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: snapshot
                                                                            .hasData
                                                                        ? snapshot
                                                                            .data!
                                                                            .get("name")
                                                                        : "",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        " ${messageReport[data['category']!]} ",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: typeSnapshot
                                                                            .hasData
                                                                        ? typeSnapshot
                                                                            .data!
                                                                            .get(typeName[data['category']!])
                                                                        : "",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ]),
                                                          ),
                                                          Text(
                                                            TimeAgo.timeAgoSinceDate(DateFormat(
                                                                    "dd-MM-yyyy h:mma")
                                                                .format(data[
                                                                        'date']!
                                                                    .toDate())),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 10,
                                                              color: Colors.grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //     "Ahmad Menyetujui permintaan anda bergabung ke komunitas “Madiun Bal-balan",
                                                      //     maxLines: 5,
                                                      //     style: GoogleFonts.poppins(
                                                      //         fontSize: 12,
                                                      //         fontWeight: FontWeight.w400),
                                                      //   ),
                                                      // ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      // Text(
                                                      //   "19 Des 22",
                                                      //   style: GoogleFonts.poppins(
                                                      //       fontSize: 10,
                                                      //       fontWeight: FontWeight.w500,
                                                      //       color: Colors.grey),
                                                      // )
                                                    ],
                                                  );
                                                }
                                              },
                                            );
                                          }
                                        },
                                      ))),
                              Divider(
                                height: 0.5,
                                color: Colors.grey.shade200,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
    // child: Container(
    //     width: Get.width,
    //     height: Get.height,
    //     child: controller.isLoading
    //         ? Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : controller.dataReport.isEmpty
    //             ? RefreshIndicator(
    //                 onRefresh: () {
    //                   HapticFeedback.lightImpact();
    //                   return controller.onGetData();
    //                 },
    //                 child: SingleChildScrollView(
    //                   physics: BouncingScrollPhysics(
    //                       parent: AlwaysScrollableScrollPhysics()),
    //                   child: Center(
    //                     child: Container(
    //                       child: Column(
    //                         children: [
    //                           SizedBox(
    //                             height: 150,
    //                           ),
    //                           Text(
    //                             'Tidak Ada Data Laporan',
    //                             style: GoogleFonts.poppins(
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.bold,
    //                                 color: AppColors.black),
    //                           ),
    //                           Text(
    //                             'Tidak ada data laporan yang diterima',
    //                             style: GoogleFonts.poppins(
    //                                 fontSize: 12, color: Colors.black45),
    //                             textAlign: TextAlign.center,
    //                           ),
    //                           Container(height: 300)
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               )
    //             : RefreshIndicator(
    //                 onRefresh: () {
    //                   HapticFeedback.lightImpact();
    //                   return controller.onGetData();
    //                 },
    //                 child: ListView.builder(
    //                     padding: EdgeInsets.only(bottom: 30),
    //                     physics: BouncingScrollPhysics(
    //                         parent: AlwaysScrollableScrollPhysics()),
    //                     itemCount: controller.dataReport.length,
    //                     itemBuilder: (context, index) {
    //                       var data = controller.dataReport[index];
    //                       return Slidable(
    //                         enabled: true,
    //                         closeOnScroll: true,
    //                         endActionPane: ActionPane(
    //                           motion: ScrollMotion(),
    //                           children: [
    //                             SlidableActionCustom(
    //                               flex: 2,
    //                               spacing: 1,
    //                               onPressed: (context) {
    //                                 DialogHelper.showConfirm(
    //                                     title: "Hapus Laporan",
    //                                     description:
    //                                         "Anda yakin akan menghapus laporan?",
    //                                     titlePrimary: "Hapus",
    //                                     titleSecondary: "Batal",
    //                                     action: () => controller
    //                                         .onDeleteNotif(data.idReport));
    //                               },
    //                               autoClose: true,
    //                               backgroundColor: Color(0xFFFE4A49),
    //                               foregroundColor: Colors.white,
    //                               icon: Feather.trash,
    //                               label: 'Hapus',
    //                             ),
    //                             // SlidableActionCustom(
    //                             //   flex: 2,
    //                             //   spacing: 1,
    //                             //   onPressed: (context) {
    //                             //     data.readAt =
    //                             //         Timestamp.fromDate(DateTime.now());
    //                             //     notificationController
    //                             //         .onReadNotif(data.idNotification);
    //                             //   },
    //                             //   autoClose: true,
    //                             //   backgroundColor: Colors.grey,
    //                             //   foregroundColor: Colors.white,
    //                             //   icon: Feather.check,
    //                             //   label: 'Terbaca',
    //                             // ),
    //                           ],
    //                         ),
    //                         child: GestureDetector(
    //                           onTap: () => controller.onClickNotif(
    //                               data.idReport.toString(),
    //                               data.code.toString(),
    //                               data.category!),
    //                           child: Container(
    //                             color: data.readAt == null
    //                                 ? Colors.blue.shade50.withOpacity(0.6)
    //                                 : Colors.transparent,
    //                             child: Padding(
    //                               padding: const EdgeInsets.only(
    //                                   right: 20, left: 20),
    //                               child: Column(
    //                                 children: [
    //                                   Padding(
    //                                       padding: const EdgeInsets.only(
    //                                           bottom: 10, top: 10),
    //                                       child: Container(
    //                                           width: Get.width,
    //                                           child: StreamBuilder<
    //                                               DocumentSnapshot>(
    //                                             stream: FirebaseFirestore
    //                                                 .instance
    //                                                 .collection('users')
    //                                                 .doc(data.idFromUser)
    //                                                 .snapshots(),
    //                                             builder: (context, snapshot) {
    //                                               if (snapshot
    //                                                       .connectionState ==
    //                                                   ConnectionState.waiting) {
    //                                                 return SizedBox();
    //                                               } else {
    //                                                 return StreamBuilder<
    //                                                     DocumentSnapshot>(
    //                                                   stream: FirebaseFirestore
    //                                                       .instance
    //                                                       .collection(typeCode[
    //                                                           data.category!])
    //                                                       .doc(data.code)
    //                                                       .snapshots(),
    //                                                   builder: (context,
    //                                                       typeSnapshot) {
    //                                                     if (typeSnapshot
    //                                                             .connectionState ==
    //                                                         ConnectionState
    //                                                             .waiting) {
    //                                                       return SizedBox();
    //                                                     } else {
    //                                                       return Row(
    //                                                         mainAxisAlignment:
    //                                                             MainAxisAlignment
    //                                                                 .start,
    //                                                         crossAxisAlignment:
    //                                                             CrossAxisAlignment
    //                                                                 .center,
    //                                                         children: [
    //                                                           circleAvatar(
    //                                                               imageData: snapshot
    //                                                                       .hasData
    //                                                                   ? snapshot.data!.get(
    //                                                                           "photoUser") ??
    //                                                                       ""
    //                                                                   : "",
    //                                                               nameData: snapshot
    //                                                                       .hasData
    //                                                                   ? snapshot
    //                                                                           .data!
    //                                                                           .get("name") ??
    //                                                                       ""
    //                                                                   : "",
    //                                                               size: 28),
    //                                                           SizedBox(
    //                                                             width: 10,
    //                                                           ),
    //                                                           Expanded(
    //                                                               child: Column(
    //                                                             mainAxisAlignment:
    //                                                                 MainAxisAlignment
    //                                                                     .start,
    //                                                             crossAxisAlignment:
    //                                                                 CrossAxisAlignment
    //                                                                     .start,
    //                                                             children: [
    //                                                               RichText(
    //                                                                 text: TextSpan(
    //                                                                     children: [
    //                                                                       TextSpan(
    //                                                                         text: snapshot.hasData
    //                                                                             ? snapshot.data!.get("name")
    //                                                                             : "",
    //                                                                         style: GoogleFonts.poppins(
    //                                                                             fontSize: 12,
    //                                                                             color: Colors.black,
    //                                                                             fontWeight: FontWeight.w600),
    //                                                                       ),
    //                                                                       TextSpan(
    //                                                                         text:
    //                                                                             " ${messageReport[data.category!]} ",
    //                                                                         style:
    //                                                                             GoogleFonts.poppins(
    //                                                                           fontSize: 12,
    //                                                                           color: Colors.black,
    //                                                                         ),
    //                                                                       ),
    //                                                                       TextSpan(
    //                                                                         text: typeSnapshot.hasData
    //                                                                             ? typeSnapshot.data!.get(typeName[data.category!])
    //                                                                             : "",
    //                                                                         style: GoogleFonts.poppins(
    //                                                                             fontSize: 12,
    //                                                                             color: Colors.black,
    //                                                                             fontWeight: FontWeight.w600),
    //                                                                       ),
    //                                                                     ]),
    //                                                               ),
    //                                                               Text(
    //                                                                 TimeAgo.timeAgoSinceDate(DateFormat(
    //                                                                         "dd-MM-yyyy h:mma")
    //                                                                     .format(data
    //                                                                         .date!
    //                                                                         .toDate())),
    //                                                                 style: GoogleFonts
    //                                                                     .poppins(
    //                                                                   fontSize:
    //                                                                       10,
    //                                                                   color: Colors
    //                                                                       .grey
    //                                                                       .shade600,
    //                                                                 ),
    //                                                               ),
    //                                                             ],
    //                                                           )),
    //                                                           // Expanded(
    //                                                           //   child: Text(
    //                                                           //     "Ahmad Menyetujui permintaan anda bergabung ke komunitas “Madiun Bal-balan",
    //                                                           //     maxLines: 5,
    //                                                           //     style: GoogleFonts.poppins(
    //                                                           //         fontSize: 12,
    //                                                           //         fontWeight: FontWeight.w400),
    //                                                           //   ),
    //                                                           // ),
    //                                                           // SizedBox(
    //                                                           //   width: 10,
    //                                                           // ),
    //                                                           // Text(
    //                                                           //   "19 Des 22",
    //                                                           //   style: GoogleFonts.poppins(
    //                                                           //       fontSize: 10,
    //                                                           //       fontWeight: FontWeight.w500,
    //                                                           //       color: Colors.grey),
    //                                                           // )
    //                                                         ],
    //                                                       );
    //                                                     }
    //                                                   },
    //                                                 );
    //                                               }
    //                                             },
    //                                           ))),
    //                                   Divider(
    //                                     height: 0.5,
    //                                     color: Colors.grey.shade200,
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     }),
    //               )),
    // );
  }
}
