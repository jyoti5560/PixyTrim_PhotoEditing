import 'package:shared_preferences/shared_preferences.dart';



class LocalStorage {
  String storageKey = 'AllSessionStorageKey';
  List<String> mainList = [];
  List<String> subList = [];


  Future storeMainList(List<String> subList) async {
    print('subList : $subList');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempList = prefs.getStringList('$storageKey') ?? [];
    for(int i =0; i< subList.length; i++){
      tempList.add(subList[i]);
    }
    prefs.setStringList('$storageKey', tempList);

    print('Sublist New : ${prefs.getStringList('$storageKey')}');
  }

  Future<List<String>> getMainList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    subList = prefs.getStringList('$storageKey') ?? [];
    mainList = subList;
    print('mainList : $mainList');
    return mainList;
  }

  Future deleteImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('$storageKey');
  }

  Future updateImageList(List<String> localSessionList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('$storageKey');
    prefs.setStringList('$storageKey', localSessionList);
  }

}