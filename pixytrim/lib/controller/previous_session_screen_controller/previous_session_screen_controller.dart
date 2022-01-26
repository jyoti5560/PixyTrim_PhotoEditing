import 'package:get/get.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';

class PreviousSessionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  LocalStorage localStorage = LocalStorage();
  RxList<String> localSessionList = RxList();
  RxList<String> localSessionListNew = RxList();

  List<String> localCollageList = [];

  getLocalSessionList() async {
    isLoading(true);
    localSessionList.value = await localStorage.getMainList();
    if(localSessionList.isEmpty){
      localSessionList.value = [];
    }
    for(int i = (localSessionList.length-1); i>=0 ; i--) {
      localSessionListNew.add(localSessionList[i]);
    }
    isLoading(false);
  }

  getLocalCollageSessionList() async {
    isLoading(true);
    localCollageList = await localStorage.getCollageMainList();
    if(localCollageList.isEmpty){
      localCollageList = [];
    }
    isLoading(false);
  }

  deleteLocalSessionList() async {
    await localStorage.deleteImage();
    Get.back();
    Get.back();
  }

  updateLocalSessionList(int i) async {
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