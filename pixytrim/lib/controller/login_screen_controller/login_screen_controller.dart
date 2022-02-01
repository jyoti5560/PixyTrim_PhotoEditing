import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixytrim/screens/index_screen/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController extends GetxController {
  RxBool isLoading = false.obs;
  final FacebookLogin  plugin = FacebookLogin(debug: true);
  FacebookAccessToken? _token;
  FacebookUserProfile? profile1;
  FacebookUserProfile? profile;
  String? _imageUrl;
  String? _email;
  String ? login;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    updateLoginInfo();
  }

  Future googleAuthentication(context) async {
    // try {
    //   googleSignInManager.signOut();
    //   final result = await googleSignInManager.signIn();
    //   if (result != null) {
    //     if (result.email != "") {
    //       Map params = {
    //         "userName": result.displayName ?? "",
    //         "emailId": result.email,
    //         "serviceName": 'GOOGLE',
    //         "uniqueId": "",
    //         "loginPassword": "",
    //       };
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => IndexScreen()),
    //       );
    //       // _socialLoginAPI(params, state.context);
    //       print("userName");
    //     } else {
    //       // commonMessageDialog(state.context,
    //       //     title: "Error",
    //       //     message:
    //       //     "Your Google account is not linked with email. Please signup and login with email and password.");
    //     }
    //   }
    // } catch (error) {
    //   print(error);
    // }
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      print("Email: ${result.user!.email}");
      print("Username: ${result.user!.displayName}");
      print("User Id: ${result.user!.uid}");
      // todo - Set UserId

      //login = prefs.getString('userId');
      //print(login);
      if (result != null) {
        prefs.setString('userId', result.user!.uid);
        prefs.setString('userName', result.user!.displayName!);
        prefs.setString('email', result.user!.email!);
        prefs.setString('photo', result.user!.photoURL!);
        prefs.setBool('isLoggedIn', false);

        Get.to(() => IndexScreen(result: result));
      }
    }
    isLoading(false);
  }

  Future<void> updateLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final plugin1 = plugin;
    final token = await plugin1.accessToken;

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
      if(profile != null) {
        if(profile!.userId.isNotEmpty){
          prefs.setString('userId', profile!.userId);
          prefs.setString('userName', profile!.firstName!);
          prefs.setString('email', email!);
          prefs.setString('photo', imageUrl!.toString());

          String ? userId = prefs.getString('userId');
          String ? uName = prefs.getString('userName');
          String ? uEmail = prefs.getString('email');
          String ? uPhotoUrl = prefs.getString('photo');
          print('id: $userId, username : $uName, email : $uEmail, photo : $uPhotoUrl');
        }
      }


     //
    }

    //setState(() {
      _token = token;
      profile1 = profile;
      _email = email;
      _imageUrl = imageUrl;
    //});
  }
}