import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:passify_admin/controllers/event/event_controller.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/models/event.dart';
import 'package:passify_admin/models/event_comment.dart';
import 'package:passify_admin/models/user.dart';
import 'package:passify_admin/routes/pages.dart';

class DetailEventController extends GetxController {
  HomeController homeController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notifications');
  CollectionReference report = FirebaseFirestore.instance.collection('reports');

  String dateee = DateFormat("yyyy").format(DateTime.now());
  late final commentText = ''.obs;
  var isFollow = false.obs;
  final _isLoadingDetail = true.obs;
  var detailEvent = <EventModel>[].obs;
  var myProfile = <UserModel>[].obs;
  var userEvent = <UserModel>[].obs;
  var memberEvent = <UserModel>[].obs;
  var commentEvent = <EventCommentModel>[].obs;
  var dataComment = <EventCommentModel>[].obs;
  final commentFC = TextEditingController();
  var idEvent = Get.arguments;
  var hasReport = 0.obs;
  var myAccountId = ''.obs;
  var selectedDropdown = 'WIB'.obs;
  var selectedTime = '00.00 '.obs;
  final formKeyEditEvent = GlobalKey<FormState>();
  DateTime dateEvent = DateTime.now();

  final nameFC = TextEditingController();
  final descriptionFC = TextEditingController();
  final locationFC = TextEditingController();
  final dateFC = TextEditingController();
  final timeFC = TextEditingController();

  @override
  void onInit() async {
    OnRefresh();
    super.onInit();
  }

  Future<void> OnRefresh() async {
    onGetReport();
    await onGetDetailEvent();
  }

  onGetReport() {
    report.where("code", isEqualTo: idEvent).get().then((value) {
      hasReport.value = value.size;
    });
  }

  onGetDetailEvent() async {
    myAccountId.value = (auth.currentUser?.uid).toString();
    // memberEvent.clear();
    memberEvent.isNotEmpty ? memberEvent.clear() : null;
    await event
        .where("idEvent", isEqualTo: idEvent)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size == 0) Get.offAndToNamed(AppPages.NOT_FOUND);
      // detailEvent.clear();
      snapshot.docs.forEach((d) {
        eventMember
            .where("idEvent", isEqualTo: d["idEvent"])
            .get()
            .then((QuerySnapshot snapshotMember) {
          snapshotMember.docs.forEach((member) {
            detailEvent.isNotEmpty ? detailEvent.clear() : null;
            detailEvent.add(EventModel(
                name: d["name"],
                category: d["category"],
                date: d["date"],
                idUser: d["idUser"],
                idEvent: d["idEvent"],
                description: d["description"],
                location: d["location"],
                time: d["time"],
                dateEvent: d["dateEvent"],
                member: snapshotMember.size));

            user
                .where("idUser", isEqualTo: member["idUser"])
                .get()
                .then((value) {
              value.docs.forEach((u) {
                u['idUser'] == auth.currentUser?.uid
                    ? isFollow.value = true
                    : null;
                memberEvent.add(UserModel(
                    name: u["name"],
                    username: u["username"],
                    fcmToken: u["fcmToken"],
                    date: u["date"],
                    idUser: u["idUser"],
                    email: u["email"],
                    photo: u["photoUser"],
                    twitter: u["twitter"],
                    hobby: u["hobby"],
                    city: u["city"],
                    instagram: u["instagram"]));
              });
            });
          });
        });

        user.where("idUser", isEqualTo: d["idUser"]).get().then((value) {
          value.docs.forEach((u) {
            userEvent.assign(UserModel(
                name: u["name"],
                username: u["username"],
                date: u["date"],
                idUser: u["idUser"],
                email: u["email"],
                photo: u["photoUser"],
                twitter: u["twitter"],
                hobby: u["hobby"],
                city: u["city"],
                instagram: u["instagram"]));

            OnGetComment(Get.arguments);
          });
        });
      });
    });
  }

  OnGetComment(String idEvent) {
    dataComment.isNotEmpty ? dataComment.clear() : null;
    // userComment.clear();

    eventComment
        .where("idEvent", isEqualTo: idEvent)
        .orderBy("date", descending: true)
        .get()
        .then((value) {
      value.size > 0
          ? value.docs.forEach((u) {
              user.where("idUser", isEqualTo: u["idUser"]).get().then((value) {
                value.docs.forEach((user) {
                  DateTime a = u['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataComment.add(EventCommentModel(
                      date: u["date"],
                      idUser: u["idUser"],
                      idEvent: u["idEvent"],
                      comment: u["comment"],
                      name: user["name"],
                      username: user["username"],
                      photo: user["photoUser"],
                      sort: int.parse(sort)));
                });
                commentEvent.assignAll(dataComment);
                commentEvent.sort((a, b) => a.sort!.compareTo(b.sort!));
                dataComment.length == value.size
                    ? _isLoadingDetail.value = false
                    : null;
              });
            })
          : _isLoadingDetail.value = false;
    });
  }

  onDeleteEvent() async {
    Get.back();
    DialogHelper.showLoading();
    event.doc(idEvent).delete().then((_) {
      eventMember
          .where("idEvent", isEqualTo: idEvent)
          .get()
          .then((QuerySnapshot snapshotMember) {
        snapshotMember.docs.forEach((element) {
          eventMember.doc(element['idMember']).delete();
        });
      });
      eventComment
          .where("idEvent", isEqualTo: idEvent)
          .get()
          .then((QuerySnapshot snapshotComment) {
        snapshotComment.docs.forEach((element) {
          eventComment.doc(element['idComment']).delete();
        });
      });
      notification
          .where("code", isEqualTo: idEvent)
          .get()
          .then((snapshotNotif) {
        snapshotNotif.docs.forEach((element) {
          notification.doc(element['idNotification']).delete();
        });
      });
      report.where("code", isEqualTo: idEvent).get().then((snapshotReport) {
        snapshotReport.docs.forEach((element) {
          report.doc(element['idReport']).delete();
        });
      });
      homeController.onGetData();
      EventController eventController = Get.put(EventController());
      eventController.onGetDataEvent();
      Get.back();
      Get.back();
      Get.back();
    });
  }

  get isLoadingDetail => this._isLoadingDetail.value;
}
