import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:passify_admin/models/event.dart';
import 'package:passify_admin/models/user.dart';

class EventController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');

  final formKeyEvent = GlobalKey<FormState>();
  var dataEvent = <EventModel>[].obs;
  var eventData = <EventModel>[].obs;
  var userEvent = <UserModel>[].obs;
  var dataEventMembers = [].obs;
  final _isLoading = true.obs;
  var selectedDropdown = 'WIB'.obs;
  var selectedTime = '00.00 '.obs;
  DateTime dateEvent = DateTime.now();
  var category = "".obs;
  var categoryHobies = [].obs;

  final nameFC = TextEditingController();
  final descriptionFC = TextEditingController();
  final locationFC = TextEditingController();
  final dateFC = TextEditingController();
  final timeFC = TextEditingController();

  @override
  void onInit() async {
    category.value = "Sepakbola";
    onReadJson();
    onGetDataEvent();
    super.onInit();
  }

  onReadJson() async {
    categoryHobies.clear();
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    categoryHobies.value = data["categories"];
  }

  onSelectCategory(String categorySelected) {
    Get.back();
    category.value = categorySelected;
    _isLoading.value = true;
    onGetDataEvent();
  }

  Future<void> onGetDataEvent() async {
    _isLoading.value = true;
    eventData.isNotEmpty ? eventData.clear() : null;
    dataEvent.isNotEmpty ? dataEvent.clear() : null;
    int i = 0;
    await event
        .where("category", isEqualTo: category.toString())
        .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size == 0) {
        _isLoading.value = false;
      }
      snapshot.docs.forEach((d) async {
        i++;
        await eventMember
            .where("idEvent", isEqualTo: d["idEvent"])
            .get()
            .then((QuerySnapshot snapshotMember) async {
          await eventComment
              .where("idEvent", isEqualTo: d["idEvent"])
              .get()
              .then((QuerySnapshot snapshotComment) {
            DateTime a = d['date'].toDate();
            String sort = DateFormat("yyyyMMddHHmmss").format(a);
            dataEvent.add(EventModel(
                name: d["name"],
                category: d["category"],
                date: d["date"],
                idUser: d["idUser"],
                idEvent: d["idEvent"],
                description: d["description"],
                location: d["location"],
                time: d["time"],
                dateEvent: d["dateEvent"],
                sort: int.parse(sort),
                member: snapshotMember.size,
                comment: snapshotComment.size));
            dataEvent.sort((a, b) => b.sort!.compareTo(a.sort!));
            if (i == snapshot.size) {
              _isLoading.value = false;
            }
          });
        });
      });
    });
  }

  onClearFC() {
    nameFC.clear();
    descriptionFC.clear();
    locationFC.clear();
    dateFC.clear();
    timeFC.clear();
  }

  get isLoading => this._isLoading.value;
}
