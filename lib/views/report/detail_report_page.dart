import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:get/get.dart';
import 'package:passify_admin/widgets/shimmer/detail_report_shimmer.dart';

class DetailReportPage extends StatelessWidget {
  DetailReportPage({Key? key}) : super(key: key);
  HomeController controller = Get.find();
  var idKonten = Get.arguments;
  final Stream<QuerySnapshot> report = FirebaseFirestore.instance
      .collection('reports')
      .where("idReport", isEqualTo: Get.arguments)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(
      title: "Detail Laporan",
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: report,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Container();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DetailReportShimmer();
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
          Container();
        }
        var data = snapshot.data!.docs[0];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Container(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pelapor',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(data['idFromUser'])
                                .snapshots(),
                            builder: (context, snapshotUser) {
                              if (snapshotUser.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              return Text(snapshotUser.data!.get("name"),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400));
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Kategori',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              controller.categoryReport[data['category']]
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Konten yang dilaporkan',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection(controller
                                      .collectionReport[data['category']]
                                      .toString())
                                  .doc(data['code'])
                                  .snapshots(),
                              builder: (context, snapshotContent) {
                                if (snapshotContent.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox();
                                }
                                return Text(
                                    snapshotContent.data!.get(controller
                                        .fieldReport[data['category']]
                                        .toString()),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400));
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Masalah',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              controller.reportProblem[data['problem']]
                                  .toString(),
                              maxLines: null,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      controller.onOpenContent(data['code'], data['category']);
                    },
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Lihat Konten',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
