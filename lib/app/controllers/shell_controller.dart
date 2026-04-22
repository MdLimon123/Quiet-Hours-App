import 'package:get/get.dart';

class ShellController extends GetxController {
  final currentIndex = 0.obs;

  void changeIndex(int value) {
    currentIndex.value = value;
  }
}
