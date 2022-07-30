import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:passify_admin/controllers/community/community_controller.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/helpers/snackbar_helper.dart';
import 'package:passify_admin/models/community.dart';
import 'package:passify_admin/models/post.dart';
import 'package:passify_admin/models/user.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class DetailCommunityController extends GetxController {
  HomeController homeController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notifications');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');
  CollectionReference report = FirebaseFirestore.instance.collection('reports');

  ScrollController? controller;
  var isExtends = true.obs;
  var isDiscusion = true.obs;
  var isMember = false.obs;
  var isCreator = false.obs;
  var isRequestJoin = false.obs;
  var nameUser = "".obs;
  final isLoadingDetail = true.obs;
  final isLoadingPost = true.obs;
  var hasReport = 0.obs;
  final tokenLeader = [].obs;
  String idCommunity = Get.arguments;
  var detailCommunity = <CommunityModel>[].obs;
  var userCommunity = <UserModel>[].obs;
  var memberCommunity = <UserModel>[].obs;
  var memberWaiting = <UserModel>[].obs;
  var dataDisccusion = <PostModel>[].obs;
  var dataFjb = <PostModel>[].obs;
  var disccusionData = <PostModel>[].obs;
  var fjbData = <PostModel>[].obs;

  @override
  void onInit() {
    onGetData();
    onGetReport();
    onScrollControlled();
    super.onInit();
  }

  Future<void> onRefresh() async {
    await onGetData();
    onGetReport();
    onScrollControlled();
  }

  onGetReport() {
    report.where("code", isEqualTo: idCommunity).get().then((value) {
      hasReport.value = value.size;
    });
  }

  onScrollControlled() {
    controller = ScrollController();
    controller?.addListener(() {
      if (controller!.position.pixels == controller!.position.minScrollExtent) {
        isExtends.value = true;
      } else if (controller!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isExtends.value = false;
      }
    });
  }

  onGetData() async {
    if (auth.currentUser == null) Get.offAndToNamed(AppPages.NOT_FOUND);
    try {
      await community
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) Get.offAndToNamed(AppPages.NOT_FOUND);
        // detailEvent.clear();
        memberCommunity.isNotEmpty ? memberCommunity.clear() : null;
        memberWaiting.isNotEmpty ? memberWaiting.clear() : null;
        snapshot.docs.forEach((d) {
          communityMember
              .where("idCommunity", isEqualTo: d["idCommunity"])
              .get()
              .then((QuerySnapshot snapshotMember) {
            snapshotMember.docs.forEach((member) {
              detailCommunity.isNotEmpty ? detailCommunity.clear() : null;
              detailCommunity.add(CommunityModel(
                name: d["name"],
                category: d["category"],
                date: d["date"],
                idUser: d["idUser"],
                idCommunity: d["idCommunity"],
                description: d["description"],
                city: d["city"],
                province: d["province"],
                photo: d["photo"],
              ));

              if (member["status"] == "verified") {
                user
                    .where("idUser", isEqualTo: member["idUser"])
                    .get()
                    .then((QuerySnapshot value) {
                  value.docs.forEach((u) {
                    memberCommunity.add(UserModel(
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
                    memberCommunity.sort((a, b) =>
                        a.name!.toString().compareTo(b.name!.toString()));
                    if (u["idUser"] == d["idUser"]) {
                      nameUser.value = u["name"];
                      tokenLeader.assignAll(u["fcmToken"]);
                    }
                  });
                });
              }
              if (member["status"] == "waiting") {
                user
                    .where("idUser", isEqualTo: member["idUser"])
                    .get()
                    .then((QuerySnapshot value) {
                  value.docs.forEach((u) {
                    memberWaiting.add(UserModel(
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

                    memberWaiting.sort((a, b) => b.name!.compareTo(a.name!));
                  });
                });
              }
              isLoadingDetail.value = false;
            });
            onGetPost();
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  onGetPost() async {
    isLoadingPost.value = true;
    try {
      await post
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) {
          isLoadingPost.value = false;
          dataDisccusion.isNotEmpty ? dataDisccusion.clear() : null;
          dataFjb.isNotEmpty ? dataFjb.clear() : null;
        }
        int i = 0;
        snapshot.docs.forEach((post) {
          i++;
          user
              .where("idUser", isEqualTo: post["idUser"])
              .get()
              .then((QuerySnapshot userSnapshot) {
            dataDisccusion.isNotEmpty ? dataDisccusion.clear() : null;
            dataFjb.isNotEmpty ? dataFjb.clear() : null;
            userSnapshot.docs.forEach((user) {
              postComment
                  .where("idPost", isEqualTo: post["idPost"])
                  .get()
                  .then((QuerySnapshot snapshotComment) {
                if (post["category"] == "disccusion") {
                  DateTime a = post['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataDisccusion.add(PostModel(
                      caption: post["caption"],
                      category: post["category"],
                      date: post["date"],
                      idUser: post["idUser"],
                      idCommunity: post["idCommunity"],
                      photo: post["photo"],
                      idPost: post["idPost"],
                      title: post["title"],
                      noHp: post["noHp"],
                      price: post["price"],
                      status: post["status"],
                      name: user["name"],
                      username: user["username"],
                      photoUser: user["photoUser"],
                      comment: snapshotComment.size,
                      sort: int.parse(sort)));
                  // dataDisccusion = (disccusionData);
                  dataDisccusion.sort((a, b) => b.sort!.compareTo(a.sort!));
                  if (i == snapshot.size) {
                    isLoadingPost.value = false;
                  }
                } else if (post["category"] == "fjb") {
                  DateTime a = post['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataFjb.add(PostModel(
                      caption: post["caption"],
                      category: post["category"],
                      date: post["date"],
                      idUser: post["idUser"],
                      idCommunity: post["idCommunity"],
                      photo: post["photo"],
                      idPost: post["idPost"],
                      title: post["title"],
                      noHp: post["noHp"],
                      price: post["price"],
                      status: post["status"],
                      name: user["name"],
                      username: user["username"],
                      photoUser: user["photoUser"],
                      comment: snapshotComment.size,
                      sort: int.parse(sort)));
                  // dataFjb.assignAll(fjbData);
                  dataFjb.sort((a, b) => b.sort!.compareTo(a.sort!));
                  if (i == snapshot.size) {
                    isLoadingPost.value = false;
                  }
                }
              });
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void onConfirmDelete(String idPost) {
    Get.back();
    DialogHelper.showConfirm(
        title: "Hapus Postingan",
        description: "Anda yakin akan menghapus postingan ini?",
        titlePrimary: "Hapus",
        titleSecondary: "Batal",
        action: () {
          Get.back();
          onDeletePost(idPost);
        });
  }

  onDeleteCommunity() async {
    Get.back();
    DialogHelper.showLoading();
    if (detailCommunity[0].photo != "") {
      var fileUrl =
          Uri.decodeFull(Path.basename(detailCommunity[0].photo.toString()))
              .replaceAll(new RegExp(r'(\?alt).*'), '');

      final firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
    }

    community.doc(idCommunity).delete().then((_) {
      communityMember
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshotMember) {
        snapshotMember.docs.forEach((element) {
          communityMember.doc(element['idMember']).delete();
        });
      });
      post
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshotPost) {
        snapshotPost.docs.forEach((element) async {
          if (element['photo'] != "") {
            var fileUrl =
                Uri.decodeFull(Path.basename(element['photo'].toString()))
                    .replaceAll(new RegExp(r'(\?alt).*'), '');

            final firebase_storage.Reference firebaseStorageRef =
                firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
            await firebaseStorageRef.delete();
          }

          post.doc(element['idPost']).delete();
        });
      });
      postComment
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshotComment) {
        snapshotComment.docs.forEach((element) {
          postComment.doc(element['idComment']).delete();
        });
      });
      notification
          .where("code", isEqualTo: idCommunity)
          .get()
          .then((snapshotNotif) {
        snapshotNotif.docs.forEach((element) {
          notification.doc(element['idNotification']).delete();
        });
      });
      report.where("code", isEqualTo: idCommunity).get().then((snapshotReport) {
        snapshotReport.docs.forEach((element) {
          report.doc(element['idReport']).delete();
        });
      });
      homeController.onGetData();
      CommunityController communityController = Get.put(CommunityController());
      communityController.onGetDataCommunity();
      Get.back();
      Get.back();
      Get.back();
    });
  }

  onDeletePost(String idPost) async {
    DialogHelper.showLoading();
    dataDisccusion.removeWhere((data) => data.idPost == idPost);
    dataFjb.removeWhere((data) => data.idPost == idPost);
    dataDisccusion.refresh();
    dataFjb.refresh();
    post.doc(idPost).get().then((value) async {
      var fileUrl = Uri.decodeFull(Path.basename(value['photo'].toString()))
          .replaceAll(new RegExp(r'(\?alt).*'), '');
      if (value['photo'] != "") {
        final firebase_storage.Reference firebaseStorageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
        await firebaseStorageRef.delete();
      }
    }).then((_) async {
      await post.doc(idPost).delete().then((_) {
        onGetPost();
        postComment.where("idPost", isEqualTo: idPost).get().then((snapPost) {
          snapPost.docs.forEach((element) {
            postComment.doc(element["idComment"]).delete();
          });
        });
        notification
            .where("code", isEqualTo: idPost)
            .get()
            .then((snapshotNotif) {
          snapshotNotif.docs.forEach((element) {
            notification.doc(element['idNotification']).delete();
          });
        });
        report.where("code", isEqualTo: idPost).get().then((snapshotReport) {
          snapshotReport.docs.forEach((element) {
            report.doc(element['idReport']).delete();
          });
        });
        homeController.onGetData();
        Get.back();
        dataDisccusion.refresh();
        dataFjb.refresh();
      });
    }).onError((error, stackTrace) {
      Get.back();
    });
  }

  Future<void> onLaunchUrl(String number) async {
    String url = "https://wa.me/+62$number-?text=";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      SnackBarHelper.showError(description: "Tidak dapat menghubungkan");
    }
  }
}
