import 'package:shared_preferences/shared_preferences.dart';

List<List<String>> allSessionStoreList = [];

// allSessionStore(List<String> singleSessionList) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // Old List get from SharedPreference
//   allSessionStoreList = prefs.getStringList('AllSessionList');
//   allSessionStoreList.add(singleSessionList);
//   // New List set in SharedPreference
//   prefs.setStringList('AllSessionList', allSessionStoreList);
// }