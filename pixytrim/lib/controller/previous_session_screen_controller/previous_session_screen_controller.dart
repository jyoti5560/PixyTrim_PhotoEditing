import 'package:get/get.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';

class PreviousSessionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  LocalStorage localStorage = LocalStorage();
  List<String> localSessionList = [];
  List<String> localSessionListNew = [];

  getLocalSessionList() async {
    isLoading(true);
    localSessionList = await localStorage.getMainList();
    if(localSessionList.isEmpty){
      localSessionList = [];
    }
    for(int i = (localSessionList.length-1); i>=0 ; i--) {
      localSessionListNew.add(localSessionList[i]);
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
    super.onInit();
  }


}