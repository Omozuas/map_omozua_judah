import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt navIndex = 0.obs;

  int get tabsIndex => navIndex.value;

  set setnavIndex(int newValue) {
    navIndex.value = newValue;
  }
}
