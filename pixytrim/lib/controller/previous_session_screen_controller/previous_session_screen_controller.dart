import 'dart:io';

import 'package:get/get.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';

class PreviousSessionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  LocalStorage localStorage = LocalStorage();
  RxList<String> localSessionList = RxList();
  RxList<String> localSessionListNew = RxList();
  RxList<String> searchResult = RxList();
  //File localSessionName = Get.arguments[0];
  RxList<String> localCollageList = RxList();

  getLocalSessionList() async {
    isLoading(true);
    localSessionList.value = await localStorage.getMainList();
    if(localSessionList.isEmpty){
      localSessionList.value = [];
    }
    print("local session list: $localSessionList");

    // renameImage();
    // for(int i = (localSessionList.length-1); i>=0 ; i--) {
    //   //renameImage();
    //   localSessionListNew.add(localSessionList[i]);
    // }
    isLoading(false);
  }

  // Future renameImage() async {
  //   String ogPath = localSessionList.path;
  //   String frontPath = ogPath.split('cache')[0];
  //   print('frontPath: $frontPath');
  //   List<String> ogPathList = ogPath.split('/');
  //   print('ogPathList: $ogPathList');
  //   String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
  //   print('ogExt: $ogExt');
  //   DateTime today = new DateTime.now();
  //   String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
  //   localSessionList = await localSessionList.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
  //   //print('File : ${widget.file}');
  //  // print('File Path : ${widget.file.path}');
  // }

  getLocalCollageSessionList() async {
    isLoading(true);
    localCollageList.value = await localStorage.getCollageMainList();
    if(localCollageList.isEmpty){
      localCollageList.value = [];
    }
    isLoading(false);
  }

  deleteLocalSessionList() async {
    await localStorage.deleteImage();
    Get.back();
    Get.back();
  }

  updateLocalSessionList(int i) async {
    print("index: $i");
    isLoading(true);
    localSessionList.removeAt(i);
    localStorage.updateImageList(localSessionList);
    getLocalSessionList();
    isLoading(false);
  }


  @override
  void onInit() async {
    await getLocalSessionList();
    await getLocalCollageSessionList();
    super.onInit();
  }


}