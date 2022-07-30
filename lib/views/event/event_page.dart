// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify_admin/constant/color_constant.dart';
import 'package:passify_admin/controllers/event/event_controller.dart';
import 'package:passify_admin/models/event.dart';
import 'package:passify_admin/widgets/general/app_bar.dart';
import 'package:passify_admin/widgets/general/bottomsheet_widget.dart';
import 'package:passify_admin/widgets/general/event_widget.dart';
import 'package:passify_admin/widgets/shimmer/search_event_shimmer.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  EventPage({Key? key}) : super(key: key);
  EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Event");
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
                            Text(eventController.category.value,
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
              child: eventController.isLoading
                  ? Center(
                      child: SearchEventShimmer(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: eventController.dataEvent.isEmpty
                          ? RefreshIndicator(
                              onRefresh: () {
                                HapticFeedback.lightImpact();
                                return eventController.onGetDataEvent();
                              },
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 150,
                                    ),
                                    Text(
                                      'Tidak Ada Data Event',
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black),
                                    ),
                                    Text(
                                      'Tidak ada data event dengan kategori ${eventController.category.value}',
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
                            )
                          : RefreshIndicator(
                              onRefresh: () {
                                HapticFeedback.lightImpact();
                                return eventController.onGetDataEvent();
                              },
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemCount: eventController.dataEvent.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(1),
                                  itemBuilder: ((context, index) {
                                    EventModel data =
                                        eventController.dataEvent[index];
                                    return eventCard(
                                        idEvent: data.idEvent,
                                        name: data.name,
                                        description: data.description,
                                        date: DateFormat(
                                                "EEEE, dd MMMM yyyy", "id")
                                            .format(data.dateEvent!.toDate())
                                            .toString(),
                                        location: data.location,
                                        time: data.time,
                                        category: data.category,
                                        commentCount: data.comment.toString(),
                                        membersCount: data.member?.toString());
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
            physics: BouncingScrollPhysics(),
            itemCount: eventController.categoryHobies.length,
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                highlightColor: Colors.grey.shade200,
                splashColor: Colors.grey.shade200,
                onTap: () => eventController.onSelectCategory(
                    eventController.categoryHobies[index]['name'].toString()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        eventController.categoryHobies[index]['name']
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
