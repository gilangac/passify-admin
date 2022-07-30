// ignore_for_file: constant_identifier_names, prefer_const_constructors

part of 'pages.dart';

class AppRoutes {
  static const INITIAL = AppPages.LOGIN;

  static final pages = [
    GetPage(
        name: _Paths.LOGIN,
        page: () => LoginPage(),
        binding: FirebaseBinding()),
    GetPage(name: _Paths.HOME, page: () => HomePage()),
    GetPage(name: _Paths.FORGOT_PASSWORD, page: () => ForgotPasswordPage()),
    GetPage(name: _Paths.EVENT, page: () => EventPage()),
    GetPage(name: _Paths.COMMUNITY, page: () => CommunityPage()),
    GetPage(name: _Paths.REPORT, page: () => ReportPage()),
    GetPage(name: _Paths.ACCOUNT, page: () => AccountPage()),
    GetPage(name: _Paths.SEARCH, page: () => SearchPage()),
    GetPage(name: _Paths.CHANGE_PASSWORD, page: () => ChangePasswordPage()),
    GetPage(
        name: _Paths.DETAIL_EVENT + ':event', page: () => DetailEventPage()),
    GetPage(
        name: _Paths.DETAIL_REPORT + ':report', page: () => DetailReportPage()),
    GetPage(
        name: _Paths.COMMUNITY + ':community',
        page: () => DetailCommunityPage()),
    GetPage(name: _Paths.DETAIL_POST + ':post', page: () => DetailPostPage()),
    GetPage(
        name: _Paths.PROFILE_PERSON + ':person',
        page: () => ProfilePersonPage()),
    GetPage(name: _Paths.NOT_FOUND, page: () => NotFoundPage()),
  ];
}
