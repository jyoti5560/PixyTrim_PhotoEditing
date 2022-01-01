import 'package:shared_preferences/shared_preferences.dart';


singleSessionStore(List<String> imgList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('SSSKey');
  prefs.setStringList('SSSKey', imgList);
}

allSessionStore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? allSessionList = prefs.getStringList('SSSKey');
}