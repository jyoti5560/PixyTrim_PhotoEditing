import 'package:get/get.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';

class PreviousSessionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  LocalStorage localStorage = LocalStorage();
  List<String> localSessionList = [];

  getLocalSessionList() {
    isLoading(true);
    localSessionList = localStorage.getMainList();
    if(localSessionList.isEmpty){
      localSessionList = [];
    }
    isLoading(false);
  }


  @override
  void onInit() {
    getLocalSessionList();
    super.onInit();
  }


}