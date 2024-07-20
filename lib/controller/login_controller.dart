import 'package:wixpod/constants/audio_constant.dart';
import 'package:wixpod/controller/user_controller.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/subscription_module/subscriptionApi.dart';
import 'package:wixpod/ui/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constants/constant.dart';
import '../model/user_model/login_model.dart';
import '../services/shared_preference.dart';
import '../ui/home/bottom_navigationbar.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  GlobalKey<FormState> regformKey = GlobalKey<FormState>();

  RxBool passwordVisible = true.obs;
  RxBool inAsyncCall = false.obs;
  RxBool conpasswordVisible = true.obs;
  TextEditingController useremail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController regname = TextEditingController();
  TextEditingController regemail = TextEditingController();
  TextEditingController regpass = TextEditingController();
  TextEditingController regconform = TextEditingController();
  TextEditingController regphone = TextEditingController();

  final UserController userController = Get.put(UserController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// register login
  Future<UserCredential?> register({String? email, String? password, String? name, String? type, String? phone, String? pn_countrycode}) async {
    inAsyncCall.value = true;
    final credential = await auth.createUserWithEmailAndPassword(email: email!, password: password!).whenComplete(() async {
      await AllServices()
          .registrationService(
              regemail: email, regpass: password, name: name, type: "normal", phone: phone, pn_countrycode: pn_countrycode, image: '')
          .then((value) {
        if (value != null) {
          if (value.audioBook[0].success == "1") {
            ShowSnackBar(message: value.audioBook[0].msg);
            Get.offAll(() => LoginScreen());
            regname.clear();
            regemail.clear();
            regpass.clear();
            regconform.clear();
            regphone.clear();
            inAsyncCall.value = false;
          } else {
            ShowSnackBar(message: value.audioBook[0].msg);
            inAsyncCall.value = false;
          }
        }
      });
    });
    return credential;
  }

  /// login
  Future<LoginModel?> signIn({String? email, String? loginpassword}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    inAsyncCall.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: loginpassword!).whenComplete(() async {
        await AllServices().Loginservice(email: email, pass: loginpassword).then((value) async {
          if (value != null) {
            if (value.onlineMp3[0].success == "1") {
              await SharedPrefService().setString(value.onlineMp3[0].userId, 'user_id');
              await userController.getuser();
              if (userid != null) {
                await Purchases.logIn(userid!);
                await getSubscriptionData();
                ShowSnackBar(message: value.onlineMp3[0].msg);
                Get.offAll(() => MyBottomNavigationBar());
                useremail.clear();
                password.clear();
              }
              inAsyncCall.value = false;
            } else {
              ShowSnackBar(message: value.onlineMp3[0].msg);
              inAsyncCall.value = false;
            }
          }
        });
      });
      return null;
    } catch (e) {
      inAsyncCall.value = false;
      print(e);
    }
    return null;
  }

  ///google login
  Future<UserCredential?> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential authCredential =
          GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      UserCredential result = await FirebaseAuth.instance.signInWithCredential(authCredential);
      await AllServices()
          .registrationService(
              regemail: result.user!.email,
              name: result.user!.displayName ?? result.user!.email!.split('@').first,
              type: "google",
              regpass: '',
              image: result.user!.photoURL ?? '',
              phone: result.user!.phoneNumber ?? '',
              pn_countrycode: 'US',
              authId: result.user!.uid)
          .then((value) async {
        if (value != null) {
          if (value.audioBook[0].success == "1") {
            await prefs.setString('user_id', value.audioBook[0].userId);
            await userController.getuser().whenComplete(() async {
              if (userid != null) {
                await Purchases.logIn(userid!);
                await getSubscriptionData();
                ShowSnackBar(message: value.audioBook[0].msg);
                Get.offAll(() => MyBottomNavigationBar());
              }
            });
            inAsyncCall.value = false;
          } else {
            ShowSnackBar(message: value.audioBook[0].msg);
            inAsyncCall.value = false;
          }
        }
      });

      return result;
    } else {
      inAsyncCall.value = false;
      if (kDebugMode) {
        print("Google SignIn Error There Is No Google Account Or No InterNet");
      }
      return null;
    }
  }

  /// apple login

  Future<void> doSignInApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final firebaseauth = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(firebaseauth);
      final firebaseUser = authResult.user;
      String? appleName = firebaseUser!.displayName ?? firebaseUser.email!.split("@").first;
      String? appleEmail = firebaseUser.email;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await AllServices()
          .registrationService(
              regemail: appleEmail,
              name: appleName.isNotEmpty ? appleName : '',
              regpass: '',
              type: "Apple",
              image: firebaseUser.photoURL ?? '',
              phone: firebaseUser.phoneNumber ?? '',
              pn_countrycode: 'US',
              authId: firebaseUser.uid)
          .then((value) async {
        if (value != null) {
          if (value.audioBook[0].success == "1") {
            await prefs.setString('user_id', value.audioBook[0].userId);
            await userController.getuser().whenComplete(() async {
              if (userid != null) {
                await Purchases.logIn(userid!);
                await getSubscriptionData();
                ShowSnackBar(message: value.audioBook[0].msg);
                Get.offAll(() => MyBottomNavigationBar());
              }
            });
            inAsyncCall.value = false;
          } else {
            ShowSnackBar(message: value.audioBook[0].msg);
            inAsyncCall.value = false;
          }
        }
      });
    } catch (e) {
      inAsyncCall.value = false;
      print('Apple login Error $e');
    }
  }

  /// delete account
  Future<String> deleteAccount() async {
    return (await AllServices().deleteAccountService())!.onlineMp3[0].msg;
  }

  /// signout
  Future signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userController.isguest.value) {
      prefs.clear();
      prefs.remove('guest');
      assetsAudioPlayer.stop();
      Get.offAll(() => LoginScreen());
    } else {
      await auth.signOut();
      await GoogleSignIn().signOut();
      await Purchases.logOut();
      isActivePlan.value = 0;
      prefs.remove('guest');
      prefs.remove('user_id');
      prefs.remove('email');
      assetsAudioPlayer.stop();
      prefs.clear();
      Get.offAll(LoginScreen());
    }
  }
}
