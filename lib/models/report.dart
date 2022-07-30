import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? idReport;
  Timestamp? date;
  String? idFromUser;
  String? code;
  int? category;
  int? problem;
  Timestamp? readAt;
  int? sort;

  ReportModel(
      {this.idReport,
      this.date,
      this.idFromUser,
      this.code,
      this.category,
      this.problem,
      this.readAt,
      this.sort});
}
