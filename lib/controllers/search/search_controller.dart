// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify_admin/models/community.dart';
import 'package:passify_admin/models/community_member.dart';
import 'package:passify_admin/models/event.dart';
import 'package:passify_admin/models/user.dart';

class SearchController extends GetxController {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');
  final searchFC = TextEditingController();
  late final searchText = ''.obs;
  final currentCarousel = 0.obs;
  final searchView = false.obs;
  var _isLoading = true.obs;
  var _isLoadingPerson = true.obs;
  var _isLoadingEvent = true.obs;
  var _isLoadingCommunity = true.obs;
  final personData = <UserModel>[].obs;
  final eventData = <EventModel>[].obs;
  final communityData = <CommunityModel>[].obs;
  final personDataSearch = <UserModel>[].obs;
  final eventDataSearch = <EventModel>[].obs;
  final communityDataSearch = <CommunityModel>[].obs;
  var dataMember = <CommunityMemberModel>[].obs;

  @override
  void onInit() {
    onRefresh();
    ever(searchText, (_) {
      _isLoadingPerson.value = true;
      _isLoadingEvent.value = true;
      _isLoadingCommunity.value = true;
    });
    debounce(searchText, (_) {
      onSearch();
      _isLoadingPerson.value = false;
      _isLoadingEvent.value = false;
      _isLoadingCommunity.value = false;
    }, time: Duration(milliseconds: 1100));
    super.onInit();
  }

  onRefresh() async {
    onGetPerson();
    onGetEvent();
    onGetCommunity();
  }

  onSearch() {
    personDataSearch.isNotEmpty ? personDataSearch.clear() : null;
    eventDataSearch.isNotEmpty ? eventDataSearch.clear() : null;
    communityDataSearch.isNotEmpty ? communityDataSearch.clear() : null;
    if (searchText.value != '') {
      personData.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
      personData.removeWhere((element) => element.name == "");
      personDataSearch.value = personData
          .where((data) =>
              data.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()) ||
              data.username!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()))
          .toList();
      eventDataSearch.value = eventData
          .where((data) =>
              data.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()) ||
              data.location!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()))
          .toList();
      communityDataSearch.value = communityData
          .where((data) =>
              data.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()) ||
              data.city!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()))
          .toList();
    }
  }

  onGetPerson() async {
    // print(capitalize(searchText.value));
    personData.isNotEmpty ? personData.clear() : null;
    // if (searchText.value != '') {
    await user
        .where("username", isNotEqualTo: "")
        // .where("name".toLowerCase(),
        //     isGreaterThanOrEqualTo: searchText.value.toTitleCase())
        // .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((d) {
        personData.add(UserModel(
            name: d["name"],
            username: d["username"],
            date: d["date"],
            idUser: d["idUser"],
            email: d["email"],
            photo: d["photoUser"],
            twitter: d["twitter"],
            hobby: d["hobby"],
            city: d["city"],
            instagram: d["instagram"]));
      });
      _isLoadingPerson.value = false;
    });
    // }
  }

  onGetEvent() async {
    // print(capitalize(searchText.value));
    eventData.isNotEmpty ? eventData.clear() : null;
    // if (searchText.value != '') {
    event
        // .where('name', isGreaterThanOrEqualTo: searchText.value.toTitleCase())
        .get()
        .then((snapshot) {
      print("jumlah event adal;ah : ${snapshot.size}");
      snapshot.docs.forEach((d) async {
        await eventMember
            .where("idEvent", isEqualTo: d['idEvent'])
            .get()
            .then((member) async {
          await eventComment
              .where('idEvent', isEqualTo: d['idEvent'])
              .get()
              .then((comment) {
            eventData.add(EventModel(
                name: d["name"],
                category: d["category"],
                date: d["date"],
                idUser: d["idUser"],
                idEvent: d["idEvent"],
                description: d["description"],
                location: d["location"],
                time: d["time"],
                dateEvent: d["dateEvent"],
                comment: comment.size,
                member: member.size));
          });
        });
      });
      _isLoadingEvent.value = false;
    });
    // }
  }

  onGetCommunity() async {
    // print(capitalize(searchText.value));
    communityData.isNotEmpty ? communityData.clear() : null;
    dataMember.isNotEmpty ? dataMember.clear() : null;
    // print(searchText.value.toTitleCase());
    // if (searchText.value != '') {
    community
        // .where('name', isGreaterThanOrEqualTo: searchText.value.toTitleCase())
        .get()
        .then((snapshot) {
      print("jumlah komunitas adal;ah : ${snapshot.size}");
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
          });
          communityData.add(CommunityModel(
            name: d["name"],
            category: d["category"],
            date: d["date"],
            idUser: d["idUser"],
            idCommunity: d["idCommunity"],
            description: d["description"],
            city: d["city"],
            province: d["province"],
            photo: d["photo"],
            member: dataMember
                .where((data) => data.idCommunity == d["idCommunity"])
                .toList(),
          ));
        });
      });
      _isLoadingCommunity.value = false;
    });
    // }
  }

  get isLoading => _isLoading.value;
  get isLoadingPerson => _isLoadingPerson.value;
  get isLoadingEvent => _isLoadingEvent.value;
  get isLoadingCommunity => _isLoadingCommunity.value;
}
