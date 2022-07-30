// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:passify_admin/models/user.dart';

class AccountController extends GetxController {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  final personData = <UserModel>[].obs;
  var _isLoading = true.obs;

  @override
  onInit() {
    onGetPerson();
    super.onInit();
  }

  onGetPerson() async {
    _isLoading.value = true;
    personData.isNotEmpty ? personData.clear() : null;
    await user
        .where("username", isNotEqualTo: "")
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
        personData
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        personData.removeWhere((element) => element.name == "");
      });
      _isLoading.value = false;
    });
  }

  get isLoading => _isLoading.value;
}
