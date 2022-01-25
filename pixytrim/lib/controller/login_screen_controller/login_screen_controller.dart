import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  RxBool isLoading = false.obs;
  final FacebookLogin  plugin = FacebookLogin(debug: true);
  FacebookAccessToken? _token;
  FacebookUserProfile? profile1;
  String? _imageUrl;
  String? _email;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    updateLoginInfo();
  }

  Future<void> updateLoginInfo() async {
    final plugin1 = plugin;
    final token = await plugin1.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      print("token===$token");
      profile = await plugin1.getUserProfile();
      print("profile===$profile");
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin1.getUserEmail();
      }
      imageUrl = await plugin1.getProfileImageUrl(width: 100);
    }

    //setState(() {
      _token = token;
      profile1 = profile;
      _email = email;
      _imageUrl = imageUrl;
    //});
  }
}