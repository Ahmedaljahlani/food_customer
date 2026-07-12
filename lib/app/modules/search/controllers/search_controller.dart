import 'package:get/get.dart';

import '../../../data/model/response/item_model.dart';
import '../../home/controllers/home_controller.dart';

class SearchController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  List<ItemData> searchDataList = <ItemData>[];
  List<ItemData> foundItem = [];
  List<ItemData> results = [];

  bool itemLoader = false;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    itemLoader = true;
    update();
    
    var homeCtrl = Get.find<HomeController>();
    if (homeCtrl.itemDataList.isEmpty) {
      await homeCtrl.getItemDataList();
    }
    
    searchDataList = homeCtrl.itemDataList;
    results = searchDataList;
    itemLoader = false;
    update();
  }

  filterItem(String itemName) async {
    if (searchDataList.isEmpty) {
      await getData();
    }
    
    itemLoader = true;
    update();
    
    if (itemName.isEmpty) {
      results = searchDataList;
    } else {
      results = searchDataList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(itemName.toLowerCase()))
          .toList();
    }
    foundItem = results;
    itemLoader = false;
    update();
  }
}
