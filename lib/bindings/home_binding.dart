import 'package:get/get.dart';
import 'package:passify_admin/controllers/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
