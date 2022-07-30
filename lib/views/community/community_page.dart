// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/community/community_controller.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/bottomsheet_widget.dart';
import 'package:passify_admin/widgets/general/community_widget.dart';
import 'package:passify_admin/widgets/shimmer/search_community_shimmer.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);
  CommunityController communityController = Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Komunitas");
  }

  Widget _body() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _bottomSheetCategory(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 0.8),
                          color: AppColors.primaryColor.withOpacity(0.1)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            const Icon(
                              Feather.filter,
                              color: AppColors.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(communityController.category.value,
                                style: GoogleFonts.poppins(
                                    color: AppColors.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: communityController.isLoading
                  ? Center(
                      child: SearchCommunityShimmer(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: communityController.dataCommunity.isEmpty
                          ? RefreshIndicator(
                              onRefresh: () {
                                HapticFeedback.lightImpact();
                                return communityController.onGetDataCommunity();
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 150,
                                    ),
                                    Text(
                                      'Tidak Ada Data Komunitas',
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black),
                                    ),
                                    Text(
                                      'Tidak ada data komunitas dengan kategori ${communityController.category.value}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: Colors.black45),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 200,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () {
                                HapticFeedback.lightImpact();
                                return communityController.onGetDataCommunity();
                              },
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemCount:
                                      communityController.dataCommunity.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(1),
                                  itemBuilder: ((context, index) {
                                    var data = communityController
                                        .dataCommunity[index];
                                    return communityCard(
                                        idCommunity: data.idCommunity,
                                        category: data.category,
                                        city: data.city,
                                        name: data.name,
                                        photo: data.photo,
                                        membere: data.member);
                                  })),
                            ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _bottomSheetCategory() {
    return BottomSheetList(
        ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: communityController.categoryHobies.length,
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                highlightColor: Colors.grey.shade200,
                splashColor: Colors.grey.shade200,
                onTap: () => communityController.onSelectCategory(
                    communityController.categoryHobies[index]['name']
                        .toString()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        communityController.categoryHobies[index]['name']
                            .toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 1,
                        width: Get.width,
                        color: Colors.grey.shade200,
                      ),
                    )
                  ],
                ),
              );
            }),
        "Hobi");
  }
}
