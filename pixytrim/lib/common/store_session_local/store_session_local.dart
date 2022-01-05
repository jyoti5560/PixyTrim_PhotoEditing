import 'package:shared_preferences/shared_preferences.dart';



class LocalStorage {

  // final data = GetStorage();

  String storageKey = 'AllSessionStorageKey';
  List<String> mainList = [];
  List<String> subList = [];


  Future storeMainList(List<String> subList) async {
    print('subList : $subList');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('$storageKey', subList);

    print('Sublist New : ${prefs.getStringList('$storageKey')}');
  }

  Future<List<String>> getMainList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    subList = prefs.getStringList('$storageKey') ?? [];
    mainList = subList;
    print('mainList : $mainList');
    return mainList;
  }


  /*storeMainList(List<String> subList) {
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
  }*/


  /*List<String> getMainList() {
    List<String> tempList = data.read('$storageKey') ?? [];
    print('tempList : $tempList');
    // Fluttertoast.showToast(msg: '$tempList');
    mainList = tempList; // Get All Session List From GetStorage & Store In Local
    return mainList;
  }*/

}