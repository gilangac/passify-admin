// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';
import 'package:passify_admin/helpers/dialog_helper.dart';
import 'package:passify_admin/models/post.dart';
import 'package:passify_admin/models/post_comment.dart';
import 'package:passify_admin/models/user.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:url_launcher/url_launcher.dart';

class DetailPostController extends GetxController {
  var myAccountId = ''.obs;
  var myName = ''.obs;
  HomeController homeController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notifications');
  CollectionReference report = FirebaseFirestore.instance.collection('reports');

  final _isLoadingDetail = true.obs;
  final _isAvailable = true.obs;
  var detailPost = <PostModel>[].obs;
  var userPost = <UserModel>[].obs;
  var myProfile = <UserModel>[].obs;
  var commentPost = <PostCommentModel>[].obs;
  var dataComment = <PostCommentModel>[].obs;
  var idPost = Get.arguments;
  var hasReport = 0.obs;
  var idCommunity = ''.obs;
  var communityName = ''.obs;
  var isMemberCommunity = false.obs;
  var memberCommunity = [];

  @override
  void onInit() async {
    if (Get.arguments != null) {
      onGetReport();
      onGetDataDetail();
    } else {
      Get.offAndToNamed(AppPages.NOT_FOUND);
    }
    super.onInit();
  }

  Future<void> OnRefresh() async {
    onGetReport();
    await onGetDataDetail();
  }

  onGetReport() {
    report.where("code", isEqualTo: idPost).get().then((value) {
      hasReport.value = value.size;
    });
  }

  Future<void> onGetDataDetail() async {
    final User? users = auth.currentUser;
    final String? myId = users!.uid;
    myAccountId.value = myId.toString();

    try {
      await post
          .where("idPost", isEqualTo: idPost)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) Get.offAndToNamed(AppPages.NOT_FOUND);
        // detailEvent.clear();
        snapshot.docs.forEach((d) {
          detailPost.isNotEmpty ? detailPost.clear() : null;
          detailPost.add(PostModel(
            caption: d["caption"],
            category: d["category"],
            date: d["date"],
            idUser: d["idUser"],
            idCommunity: d["idCommunity"],
            photo: d["photo"],
            idPost: d["idPost"],
            noHp: d["noHp"],
            price: d["price"],
            title: d["title"],
            status: d["status"],
          ));
          idCommunity.value = detailPost[0].idCommunity.toString();
          detailPost[0].status != 'available'
              ? _isAvailable.value = false
              : _isAvailable.value = true;
          onGetDataCommunity();

          user.where("idUser", isEqualTo: d["idUser"]).get().then((value) {
            value.docs.forEach((u) {
              userPost.assign(UserModel(
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

              onGetComment(Get.arguments);
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  onGetDataCommunity() {
    memberCommunity.isNotEmpty ? memberCommunity.clear() : null;
    community.doc(detailPost[0].idCommunity).get().then((value) {
      communityName.value = value['name'];
    });
    communityMember
        .where("idCommunity", isEqualTo: detailPost[0].idCommunity)
        .where("status", isEqualTo: "verified")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        memberCommunity.add(element['idUser']);
        if (element['idUser'] == auth.currentUser!.uid) {
          isMemberCommunity.value = true;
        }
      });
    });
  }

  onGetComment(String idPost) {
    dataComment.isNotEmpty ? dataComment.clear() : null;
    // userComment.clear();

    postComment.where("idPost", isEqualTo: idPost).get().then((value) {
      value.size == 0 ? _isLoadingDetail.value = false : null;
      value.size > 0
          ? value.docs.forEach((u) {
              user.where("idUser", isEqualTo: u["idUser"]).get().then((value) {
                value.docs.forEach((user) {
                  DateTime a = u['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataComment.add(PostCommentModel(
                      date: u["date"],
                      idUser: u["idUser"],
                      idPost: u["idPost"],
                      idCommunity: u["idCommunity"],
                      comment: u["comment"],
                      name: user["name"],
                      username: user["username"],
                      photo: user["photoUser"],
                      sort: int.parse(sort)));
                });
                commentPost.assignAll(dataComment);
                commentPost.sort((a, b) => a.sort!.compareTo(b.sort!));
                dataComment.length == value.size
                    ? _isLoadingDetail.value = false
                    : null;
              });
            })
          : _isLoadingDetail.value = false;
    });
  }

  void onConfirmDelete() {
    Get.back();
    DialogHelper.showConfirm(
        title: "Hapus Postingan",
        description: "Anda yakin akan menghapus postingan ini?",
        titlePrimary: "Hapus",
        titleSecondary: "Batal",
        action: () {
          Get.back();
          onDeletePost();
        });
  }

  onDeletePost() async {
    DialogHelper.showLoading();
    var fileUrl = Uri.decodeFull(Path.basename(detailPost[0].photo.toString()))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    if (detailPost[0].photo != "") {
      final firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
    }

    await post.doc(detailPost[0].idPost).delete().then((value) {
      postComment
          .where("idPost", isEqualTo: detailPost[0].idPost)
          .get()
          .then((snapPost) {
        snapPost.docs.forEach((element) {
          postComment.doc(element["idComment"]).delete();
        });
        notification
            .where("code", isEqualTo: detailPost[0].idPost)
            .get()
            .then((snapshotNotif) {
          snapshotNotif.docs.forEach((element) {
            notification.doc(element['idNotification']).delete();
          });
        });
        report
            .where("code", isEqualTo: detailPost[0].idPost)
            .get()
            .then((snapshotReport) {
          snapshotReport.docs.forEach((element) {
            report.doc(element['idReport']).delete();
          });
        });
        // detailCommunityController.onGetData();
        homeController.onGetData();
        Get.back();
        Get.back();
        Get.back();
      });
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
      throw 'Could not launch $url';
    }
  }

  get isLoadingDetail => this._isLoadingDetail.value;
  get isAvailable => this._isAvailable.value;
}
