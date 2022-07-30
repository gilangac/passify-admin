// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/search/search_controller.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/widgets/general/circle_avatar.dart';
import 'package:passify_admin/widgets/general/community_widget.dart';
import 'package:passify_admin/widgets/general/event_widget.dart';
import 'package:passify_admin/widgets/shimmer/search_community_shimmer.dart';
import 'package:passify_admin/widgets/shimmer/search_event_shimmer.dart';
import 'package:passify_admin/widgets/shimmer/search_person_shimmer.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            appBar: _appBar(),
            body: _body(),
            backgroundColor: Colors.white,
          ),
        ));
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
        title: _searchBar(),
        elevation: 0.4,
        leading: GestureDetector(
            onTap: () => Get.back(), child: const Icon(Feather.arrow_left)),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size(Get.width, 35.0),
          child: TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: false,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 2.0,
            labelPadding: const EdgeInsets.only(top: 0),
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.textColor,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              _tabBar("Akun"),
              _tabBar("Event"),
              _tabBar("Komunitas"),
            ],
          ),
        ));
  }

  Widget _tabBar(String label) {
    return Tab(
      height: 40,
      child: Text(label,
          style:
              GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _body() {
    return TabBarView(
      // ignore: prefer_const_literals_to_create_immutables
      physics: BouncingScrollPhysics(),
      children: [
        _searchPerson(),
        _searchEvent(),
        _searchCommunity(),
      ],
    );
  }

  Widget _searchPerson() {
    return searchController.searchText.value == ''
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Masukkan Kata Kunci",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: AppColors.tittleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Masukkan kata kunci untuk melakukan pencarian",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        : searchController.isLoadingPerson
            ? SearchPersonShimmer()
            : searchController.personDataSearch.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Text(
                          "Tidak Ada Hasil",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tidak ada hasil untuk pencarian '${searchController.searchText.value}'",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: searchController.personDataSearch.length,
                    padding: EdgeInsets.all(25),
                    itemBuilder: (context, index) {
                      var data = searchController.personDataSearch[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: FadeInDown(
                          delay: Duration(milliseconds: 80 * index),
                          duration: Duration(milliseconds: 400),
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
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      );
                    });
  }

  Widget _searchEvent() {
    return searchController.searchText.value == ''
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Masukkan Kata Kunci",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: AppColors.tittleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Masukkan kata kunci untuk melakukan pencarian",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        : searchController.isLoadingEvent
            ? SearchEventShimmer()
            : searchController.eventDataSearch.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Text(
                          "Tidak Ada Hasil",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tidak ada hasil untuk pencarian event '${searchController.searchText.value}'",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: searchController.eventDataSearch.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(25),
                    itemBuilder: (context, index) {
                      var data = searchController.eventDataSearch[index];
                      return FadeInDown(
                        delay: Duration(milliseconds: 10 * index),
                        duration: Duration(milliseconds: 400),
                        child: eventCard(
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
                            membersCount: data.member?.toString()),
                      );
                    });
  }

  Widget _searchCommunity() {
    return searchController.searchText.value == ''
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Masukkan Kata Kunci",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: AppColors.tittleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Masukkan kata kunci untuk melakukan pencarian",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        : searchController.isLoadingCommunity
            ? SearchCommunityShimmer()
            : searchController.communityDataSearch.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Text(
                          "Tidak Ada Hasil",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tidak ada hasil untuk pencarian komunitas '${searchController.searchText.value}'",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: searchController.communityDataSearch.length,
                    padding: EdgeInsets.all(25),
                    itemBuilder: (context, index) {
                      var data = searchController.communityDataSearch[index];
                      return FadeInDown(
                        delay: Duration(milliseconds: 10 * index),
                        duration: Duration(milliseconds: 400),
                        child: communityCard(
                            idCommunity: data.idCommunity,
                            category: data.category,
                            city: data.city,
                            name: data.name,
                            photo: data.photo,
                            membere: data.member),
                      );
                    });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
      child: Container(
        width: Get.width,
        child: Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: Center(
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        onTap: () {
                          FocusManager.instance.primaryFocus;
                          searchController.onRefresh();
                        },
                        controller: searchController.searchFC,
                        onChanged: (value) {
                          searchController.searchText.value = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          fillColor: AppColors.lightGrey,
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w500),
                          hintText: 'Cari',
                          prefixIcon:
                              Icon(Feather.search, color: Colors.grey.shade400),
                          suffixIcon: searchController.searchFC.text.length >
                                      0 ||
                                  searchController.searchText.value != ''
                              ? GestureDetector(
                                  onTap: () {
                                    searchController.searchFC.clear();
                                    searchController.searchText.value = '';
                                  },
                                  child: Icon(Feather.x, color: Colors.black54),
                                )
                              : null,
                        ),
                        // validator: validator,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
