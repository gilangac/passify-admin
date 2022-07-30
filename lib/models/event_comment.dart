import 'package:cloud_firestore/cloud_firestore.dart';

class EventCommentModel {
  String? idUser;
  String? idEvent;
  Timestamp? date;
  String? comment;
  String? name;
  String? username;
  String? photo;
  int? sort;

  EventCommentModel(
      {this.idUser,
      this.idEvent,
      this.date,
      this.comment,
      this.name,
      this.username,
      this.photo,
      this.sort});
}
