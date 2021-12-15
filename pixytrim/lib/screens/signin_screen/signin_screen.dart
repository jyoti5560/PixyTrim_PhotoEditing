import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:http/http.dart' as http;
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';

class SignInScreen extends StatefulWidget {
  //const SignInScreen({Key? key}) : super(key: key);
  final FacebookLogin  plugin = FacebookLogin(debug: true);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn googleSignInManager = GoogleSignIn(
    scopes: ['email'],
  );

  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _imageUrl;
  String? _email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateLoginInfo();
  }


  @override
  Widget build(BuildContext context) {
    //print("file====${widget.file}");
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MainBackgroundWidget(),

          SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      "Pixy Trim",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.22,
                    //margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: ()async{
                              await googleAuthentication();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: Get.width/1.3,
                                decoration: borderGradientDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: containerBackgroundGradient(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          Images.ic_google,
                                          scale: 2.5,
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        Text(
                                          "Login With Google",
                                          style: TextStyle(
                                            fontFamily: "",
                                            fontSize: 20,
                                              color: Colors.black
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              facebookAuthentication();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: Get.width/1.3,
                                decoration: borderGradientDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: containerBackgroundGradient(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          Images.ic_facebook,
                                          scale: 2.5,
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        Text(
                                          "Login With Facebook",
                                          style: TextStyle(
                                            fontFamily: "",
                                            fontSize: 20,
                                            color: Colors.black
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],);

 // FacebookLogin fbAuthManager = FacebookLogin();
  Connectivity connectivity = Connectivity();

  googleAuthentication() async {
    // try {
    //   googleSignInManager.signOut();
    //   final GoogleSignInAccount ? result = await googleSignInManager.signIn();
    //   if (result != null) {
    //     if (result.email != "") {
    //       Map params = {
    //         "userName": result.displayName ?? "",
    //         "emailId": result.email,
    //         "serviceName": 'GOOGLE',
    //         "uniqueId": "",
    //         "loginPassword": "",
    //       };
    //       Get.back();
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(builder: (context) => CameraScreen(file: widget.file!,)),
    //       // );
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

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
        Get.back();
       // Get.to(() => CameraScreen(file: widget.file!,));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    } else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Your Google account is not linked with email. Please signup and login with email and password."),
      ));
    }

    return user;
  }

  facebookAuthentication() async {
    // await fbAuthManager.logOut();
    // final result = await fbAuthManager.logIn(['email']);
    // print(result);
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final token = result.accessToken.token;
    //     String url =
    //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token';
    //     // APIManager manager = APIManager(state.context);
    //
    //
    //     Map<String, dynamic> response =  await getFacebookDetails(url);
    //     print(response);
    //     print('Facebook Login Success');
    //     String email = response['email'] ?? "";
    //     String name = response['name'] ?? "";
    //     if (email != "") {
    //       Map params = {
    //         "userName": name,
    //         "emailId": email,
    //         "serviceName": 'FACEBOOK',
    //         "uniqueId": "",
    //         "loginPassword": "",
    //       };
    //     } else {
    //     }
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     print('Facebook Login cancelled By User');
    //     break;
    //   case FacebookLoginStatus.error:
    //     print(result.errorMessage);
    //     //commonMessageDialog(state.context, title: "Error", message: result.errorMessage);
    //     break;
    // }

    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
    await widget.plugin.logOut();
  }

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      print("token===$token");
      profile = await plugin.getUserProfile();
      print("profile===$profile");
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }

  Future<Map<String, dynamic>> getFacebookDetails(String url) async {
    bool isConnect = await isConnectNetworkWithMessage(context);
    if (!isConnect){

    }
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    return jsonDecode(data);
  }



  Future<bool> isConnectNetworkWithMessage(BuildContext context) async {
    var connectivityResult = await connectivity.checkConnectivity();
    bool isConnect = getConnectionValue(connectivityResult);
    if (!isConnect) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Network connection required to fetch data."),
      ));
    }
    return isConnect;
  }

  bool getConnectionValue(var connectivityResult) {
    bool status = false;
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = true;
        break;
      case ConnectivityResult.wifi:
        status = true;
        break;
      case ConnectivityResult.none:
        status = false;
        break;
      default:
        status = false;
        break;
    }
    return status;
  }
}
