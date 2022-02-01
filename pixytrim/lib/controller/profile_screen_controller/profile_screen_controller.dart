import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenController extends GetxController{

  String ? userId;
  String ? uName;
  String ? uEmail;
  String ? uPhotoUrl;
  RxBool isLoading = false.obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await getUserDetails();
  }

  getUserDetails() async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    uName = prefs.getString('userName') ?? "";
    uEmail = prefs.getString('email') ?? "";
    uPhotoUrl = prefs.getString('photo') ?? "";
    print("Username: $uPhotoUrl");
    isLoading(false);
  }

  clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userName');
    print('usename: ${prefs.remove('userName')}');
    prefs.remove('email');
    prefs.remove('photo');
    prefs.setBool('isLoggedIn', false);
  }
}