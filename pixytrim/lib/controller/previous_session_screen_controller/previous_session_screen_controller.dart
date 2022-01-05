import 'package:get/get.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';

class PreviousSessionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  LocalStorage localStorage = LocalStorage();
  List<String> localSessionList = [];

  getLocalSessionList() async {
    isLoading(true);
    localSessionList = await localStorage.getMainList();
    if(localSessionList.isEmpty){
      localSessionList = [];
    }
    isLoading(false);
  }


  @override
  void onInit() async {
    await getLocalSessionList();
    super.onInit();
  }


}