// ignore_for_file: constant_identifier_names, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:passify_admin/bindings/firebase_binding.dart';
import 'package:passify_admin/views/community/community_page.dart';
import 'package:passify_admin/views/community/detail_community_page.dart';
import 'package:passify_admin/views/community/detail_post_page.dart';
import 'package:passify_admin/views/error/not_found_page.dart';
import 'package:passify_admin/views/event/detail_event_page.dart';
import 'package:passify_admin/views/event/event_page.dart';
import 'package:passify_admin/views/home/home_page.dart';
import 'package:passify_admin/views/login/forgot_password_page.dart';
import 'package:passify_admin/views/login/login_page.dart';
import 'package:passify_admin/views/profile/account_page.dart';
import 'package:passify_admin/views/profile/change_password_page.dart';
import 'package:passify_admin/views/profile/profile_person_page.dart';
import 'package:passify_admin/views/report/detail_report_page.dart';
import 'package:passify_admin/views/report/report_page.dart';
import 'package:passify_admin/views/search/search_page.dart';

part 'routes.dart';

class AppPages {
  static const SPLASH = _Paths.SPLASH;
  static const NAVIGATOR = _Paths.NAVIGATOR;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const SEARCH = _Paths.SEARCH;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const DETAIL_EVENT = _Paths.DETAIL_EVENT;
  static const DETAIL_POST = _Paths.DETAIL_POST;
  static const DETAIL_TREND = _Paths.DETAIL_TREND;
  static const EDIT_POST = _Paths.EDIT_POST;
  static const COMMUNITY = _Paths.COMMUNITY;
  static const EVENT = _Paths.EVENT;
  static const DETAIL_COMMUNITY = _Paths.DETAIL_COMMUNITY;
  static const PROFILE_PERSON = _Paths.PROFILE_PERSON;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const REPORT = _Paths.REPORT;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const DETAIL_REPORT = _Paths.DETAIL_REPORT;
  static const NOT_FOUND = _Paths.NOT_FOUND;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const NAVIGATOR = '/';
  static const HOME = '/home';
  static const SEARCH = '/search';
  static const LOGIN = '/login';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const DETAIL_EVENT = '/detail-event/';
  static const DETAIL_POST = '/detail-post/';
  static const DETAIL_TREND = '/detail-trend/';
  static const EDIT_POST = '/edit-post/';
  static const DETAIL_COMMUNITY = '/detail-community/';
  static const COMMUNITY = '/community';
  static const EVENT = '/event';
  static const PROFILE_PERSON = '/profile-person/';
  static const EDIT_PROFILE = '/edit-profile';
  static const REPORT = '/report';
  static const ACCOUNT = '/account';
  static const CHANGE_PASSWORD = '/change-password';
  static const DETAIL_REPORT = '/detail-report/';
  static const NOT_FOUND = '/404';
}
