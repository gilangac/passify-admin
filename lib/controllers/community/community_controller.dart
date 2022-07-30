import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify_admin/models/community.dart';
import 'package:passify_admin/models/community_member.dart';
import 'package:intl/intl.dart';

class CommunityController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');

  final _isLoading = true.obs;
  final formKeyCommunity = GlobalKey<FormState>();
  var dataCommunity = <CommunityModel>[].obs;
  var communityData = <CommunityModel>[].obs;
  var dataMember = <CommunityMemberModel>[].obs;
  var category = "".obs;
  var categoryHobies = [].obs;

  @override
  void onInit() async {
    category.value = "Sepakbola";
    onReadJson();
    onGetDataCommunity();
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
    onGetDataCommunity();
  }

  Future<void> onGetDataCommunity() async {
    _isLoading.value = true;
    try {
      await community
          .where("category", isEqualTo: category.value)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) {
          _isLoading.value = false;
          dataCommunity.isNotEmpty ? dataCommunity.clear() : null;
        }
        communityData.isNotEmpty ? communityData.clear() : null;
        dataMember.isNotEmpty ? dataMember.clear() : null;
        snapshot.docs.forEach((d) {
          communityMember
              .where("idCommunity", isEqualTo: d["idCommunity"])
              .where("status", isEqualTo: "verified")
              .get()
              .then((QuerySnapshot snapshotMember) {
            snapshotMember.docs.forEach((member) {
              dataMember.add(CommunityMemberModel(
                date: member["date"],
                idCommunity: member["idCommunity"],
                idUser: member["idUser"],
                status: member["status"],
              ));
              dataMember.length == snapshotMember.size
                  ? _isLoading.value = false
                  : null;
            });
            DateTime a = d['date'].toDate();
            String sort = DateFormat("yyyyMMddHHmmss").format(a);
            communityData.add(CommunityModel(
              name: d["name"],
              photo: d["photo"],
              category: d["category"],
              date: d["date"],
              idUser: d["idUser"],
              idCommunity: d["idCommunity"],
              description: d["description"],
              province: d["province"],
              city: d["city"],
              member: dataMember
                  .where((data) => data.idCommunity == d["idCommunity"])
                  .toList(),
              sort: int.parse(sort),
            ));
            dataCommunity.assignAll(communityData);
            dataCommunity.sort((a, b) => b.sort!.compareTo(a.sort!));
          });
        });
      });
    } catch (e) {
      print(e);
      _isLoading.value = false;
    }
  }

  get isLoading => this._isLoading.value;
}
