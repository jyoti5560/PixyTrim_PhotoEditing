import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {

  final data = GetStorage();
  String storageKey = 'AllSessionStorageKey';
  late List<List<String>> mainList;


  storeMainList(List<String> subList) {
    print('subList : $subList');
    mainList.add(subList);
    data.write('$storageKey', mainList); // MainList Store in GetStorage
    print('Storage List = ${data.read('$storageKey')}');
  }


  getMainList() {
    List<List<String>> tempList = data.read('$storageKey');
    print('tempList : $tempList');
    Fluttertoast.showToast(msg: '$tempList');
    mainList = tempList; // Get All Session List From GetStorage & Store In Local
  }

}