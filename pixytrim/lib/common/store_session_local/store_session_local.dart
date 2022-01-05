import 'package:get_storage/get_storage.dart';

class LocalStorage {

  final data = GetStorage();
  String storageKey = 'AllSessionStorageKey';
  // List<List<String>> mainList = [[]];
  List<String> mainList = [];


  storeMainList(List<String> subList) {
    print('subList : $subList');
    data.write('$storageKey', subList);
    print('Storage List = ${data.read('$storageKey')}');

    // List<String> checkList = data.read('$storageKey') ?? [];
    // print('checkList : $checkList');
    // if(checkList.isNotEmpty){
    //   mainList = checkList;
    // }
    // // mainList.add(subList);
    // data.write('$storageKey', mainList); // MainList Store in GetStorage
  }


  List<String> getMainList() {
    List<String> tempList = data.read('$storageKey') ?? [];
    print('tempList : $tempList');
    // Fluttertoast.showToast(msg: '$tempList');
    mainList = tempList; // Get All Session List From GetStorage & Store In Local
    return mainList;
  }

}