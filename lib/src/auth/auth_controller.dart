import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/auth/auth_service.dart';
import 'package:mindway/src/auth/user.dart';
import 'package:mindway/src/auth/views/signup_form_screen.dart';
import 'package:mindway/src/entry_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/network_manager.dart';

import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/custom_snack_bar.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class AuthController extends NetworkManager {
  final AuthService _authService = AuthService();

  UserDataModel? user;

  bool isObscure = true;

  @override
  void onInit() async {
    user = getSavedUser();
    super.onInit();
  }

  void toggleObscure() {
    isObscure = !isObscure;
    update();
  }

   String goalIdForLogin = '';

  Future<void> checkGoalId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isGoalIdSet = prefs.containsKey("goal_id");
    if (isGoalIdSet) {
      goalIdForLogin = prefs.getString("goal_id").toString();
    } else {
      print("goal_id is not set");
    }
  }

  Future<void> handleLogIn(String email, String password) async {
    if (connectionType != 0) {
      try {
        dio.Response response = await _authService.logInUser(email, password);
        log('${response.data}', name: 'Log In Response');
        if (response.data['code'] == 200) {
          print(response.data['data'][0]['bearer_token']);
      var token =    response.data['data'][0]['bearer_token'];
          // await    checkGoalId();
          // if (goalIdForLogin.isNotEmpty) {
          //   int gId = int.parse(goalIdForLogin);
          //   await updateCustomerGoalId(email, gId, token);
          // }

          await logInFirebaseUser(response.data['data'][0], email, password);
        } else {
          displayToastMessage('Invalid Credentials!');
        }
      } on dio.DioError catch (e) {
        log('${e.response}', name: 'Dio Error Log In');
        displayToastMessage('${e.response?.data['error']}');
      } catch (e) {
        log('$e', name: 'Error Log In');
        displayToastMessage('Try again with google');
      }
    } else {
      customSnackBar('Network error', 'Please try again later');
    }
  }



  Future<void> handleSignUp({
    required String name,
    required String email,
    required String password,
    required DateTime time,
    required String gender,
    required String goal_id,
    required List<String> days,
    String? referralCode,
  }) async {
    if (connectionType != 0) {
      try {
        dio.Response response = await _authService.signUp(
            name: name, email: email, password: password, goal_id: goal_id);
        log('${response.data}', name: 'API Sign Up');
        if (response.data['code'] == 200) {
          await signUpFirebaseUser(
              id: response.data['data']['id'],
              name: name,
              email: email,
              password: password,
              gender: gender,
              time: Timestamp.fromDate(time),
              days: days,
              goal_id: goal_id);
          String data = json.encode(response.data['data']);
          await sharedPreferences.setString('user', data);
          user = getSavedUser();
          //Get.offAllNamed(OnboardingScreen1.routeName);
          //Get.toNamed(UploadProfilePicScreen.routeName);
          final goalIds =goal_id;
          int gId = int.parse(goalIds);
          List<Map<String, dynamic>> everydayRecordForTile2 = [
            {
              'course': gId,
              'date': DateTime.now(),
              'day': 1,
              'is_completed': 'no'
            },
          ];

          User? firebaseUser = FirebaseAuth.instance.currentUser;
          final users = firebaseUser?.uid;
          await tile2CountCourseDays(users.toString(), everydayRecordForTile2);
          Get.offAllNamed(MainScreen.routeName);
        } else {
          displayToastMessage('Authentication Failed!');
        }
      } on dio.DioError catch (e) {
        log('${e.response}', name: 'Dio Error Sign Up');
        displayToastMessage('Email is already exist');
      } catch (e) {
        log('$e', name: 'Error Sign Up');
        displayToastMessage('Something went wrong');
      }
    } else {
      customSnackBar('Network error', 'Please try again later');
    }
  }

  Future<void> signUpFirebaseUser({
    required int id,
    required String name,
    required String email,
    required String password,
    required Timestamp time,
    required String gender,
    required String goal_id,
    required List<String> days,
  }) async {
    try {
      UserCredential? userCred =
          await _authService.createUserWithEmailAndPassword(email, password);
      await saveUserDataToFirebase(
          credential: userCred,
          id: id,
          name: name,
          gender: gender,
          email: email,
          time: time,
          days: days,
          goal_id: goal_id,
          gmail: "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        displayToastMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        displayToastMessage('The account already exists for that email.');
      }
    } catch (e) {
      log('signUpFirebaseUser $e');
    }
  }

  Future<void> verifyGoogleEmail(
      {required Timestamp time, required List<String> days}) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().catchError((e) {
      log('googleUserError $e');
    });
    if (googleUser != null) {
      Get.toNamed(
        SignUpFormScreen.routeName,
        arguments: {
          'googleUser': googleUser,
          'time': time.toDate(),
          'days': days,
        },
      );
    }
  }

  Future<void> verifyGoogleEmailNew(
      {required BuildContext context,
      required Timestamp time,
      required List<String> days,
      required String userName,
      required String goal_id,
      required String gender}) async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().catchError((e) {
      log('googleUserError $e');
    });
    if (googleUser != null) {
      debugPrint('googleUserError success');
      Fluttertoast.showToast(
          msg: "Success, redirecting to home in few seconds");

      await signUpGoogleAuth(
          name: userName,
          email: googleUser.email,
          password: generatePassword(8),
          time: Timestamp.fromDate(time.toDate()),
          days: days,
          googleUser: googleUser,
          goal_id: goal_id,
          gender: gender);
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String generatePassword(int passLength) {
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '1234567890';
    String symbols = '!@#\$%^&*()<>,./';
    String seed = upper + lower + numbers + symbols;
    String password = '';
    List list = seed.split('').toList();
    math.Random rand = math.Random();

    for (int i = 0; i < passLength; i++) {
      int index = rand.nextInt(list.length);
      password += list[index];
    }
    return password;
  }

  Future<void> signUpGoogleAuth({
    required String name,
    required String email,
    required String password,
    required Timestamp time,
    required List<String> days,
    required String goal_id,
    required gender,
    required GoogleSignInAccount googleUser,
  }) async {
    dio.Response response = await _authService
        .signUp(
      name: name,
      email: email,
      password: password,
      goal_id: goal_id,
    )
        .catchError((e) {
      if (e is dio.DioError) {
        log('Dio error ${e.response?.data}');
        displayToastMessage('Email has already been registered');
      } else {
        log('error $e');
      }
    });
    // log('${response.data}', name: 'API Sign Up');
    if (response.data['code'] == 200) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await saveUserDataToFirebase(
          credential: userCredential,
          id: response.data['data']['id'],
          name: name,
          gender: gender,
          email: email,
          time: time,
          days: days,
          goal_id: goal_id,
          gmail: userCredential.user!.email!);
      String data = json.encode(response.data['data']);
      await sharedPreferences.setString('user', data);
      user = getSavedUser();
      //Get.offAllNamed(OnboardingScreen1.routeName);
      //Get.toNamed(UploadProfilePicScreen.routeName);
      final goalIds =goal_id;
      int gId = int.parse(goalIds);
      List<Map<String, dynamic>> everydayRecordForTile2 = [
        {
          'course': gId,
          'date': DateTime.now(),
          'day': 1,
          'is_completed': 'no'
        },
      ];

      User? firebaseUser = FirebaseAuth.instance.currentUser;
      final users = firebaseUser?.uid;
      await tile2CountCourseDays(users.toString(), everydayRecordForTile2);
      Get.offAllNamed(MainScreen.routeName);
    } else {
      displayToastMessage('Authentication Failed!');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final query =
        userCollection.where('email', isEqualTo: googleUser?.email).limit(1);
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      log('${snapshot.docs.first}');
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      log('signInMethod ${credential.signInMethod}');
      // String data = json.encode(response.data['data']);
      // await sharedPreferences.setString('user', data);
      // user = getSavedUser();

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      return null;
    }
  }

  Future<void> verifyAppleEmail(
      {required Timestamp time, required List<String> days}) async {
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    if (appleCredential.userIdentifier != null) {
      Get.toNamed(
        SignUpFormScreen.routeName,
        arguments: {
          'appleUser': appleCredential,
          'time': time.toDate(),
          'days': days,
        },
      );
    }
  }

  Future<void> verifyAppleEmailNew(
      {required Timestamp time,
      required List<String> days,
      required userName,
      required goal_id,
      required gender}) async {
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    if (appleCredential.userIdentifier != null) {
      Fluttertoast.showToast(
          msg: "Success, redirecting to home in few seconds");
      await signUpAppleAuth(
          name: userName,
          email: appleCredential.email ?? "",
          password: generatePassword(8),
          time: Timestamp.fromDate(time.toDate()),
          days: days,
          appleUser: appleCredential,
          goal_id: goal_id,
          gender: gender);
    }
  }

  Future<void> signUpAppleAuth({
    required String name,
    required String email,
    required String password,
    required Timestamp time,
    required String gender,
    required String goal_id,
    required List<String> days,
    required AuthorizationCredentialAppleID appleUser,
  }) async {
    dio.Response response = await _authService
        .signUp(name: name, email: email, password: password, goal_id: goal_id)
        .catchError((e) {
      if (e is dio.DioError) {
        log('Dio error ${e.response?.data}');
        displayToastMessage('Email has already been registered');
      } else {
        log('error $e');
      }
    });
    // log('${response.data}', name: 'API Apple Sign Up');
    if (response.data['code'] == 200) {
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleUser.identityToken,
        rawNonce: generateNonce(),
      );

      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      await saveUserDataToFirebase(
        credential: userCredential,
        id: response.data['data']['id'],
        name: name,
        email: email,
        gender: gender,
        time: time,
        days: days,
        goal_id: goal_id,
        gmail: "",
      );
      String data = json.encode(response.data['data']);
      await sharedPreferences.setString('user', data);
      user = getSavedUser();
      //Get.offAllNamed(OnboardingScreen1.routeName);
      // Get.toNamed(UploadProfilePicScreen.routeName);
      final goalIds =goal_id;
      int gId = int.parse(goalIds);
      List<Map<String, dynamic>> everydayRecordForTile2 = [
        {
          'course': gId,
          'date': DateTime.now(),
          'day': 1,
          'is_completed': 'no'
        },
      ];

      User? firebaseUser = FirebaseAuth.instance.currentUser;
      final users = firebaseUser?.uid;
      await tile2CountCourseDays(users.toString(), everydayRecordForTile2);
      Get.offAllNamed(MainScreen.routeName);
    } else {
      displayToastMessage('Authentication Failed!');
    }
  }

  Future<UserCredential?> signInWithApple() async {
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final query = userCollection
        .where('email', isEqualTo: appleCredential.email)
        .limit(1);
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    }
    return null;
  }

  Future<void> logInFirebaseUser(
      Map<String, dynamic> resData, String email, String password) async {
    try {
      UserCredential? userCred =
          await _authService.signInWithEmailAndPassword(email, password);
      if (userCred != null && userCred.user != null) {
        userCred.user?.updateEmail(email);
        String data = json.encode(resData);
        await sharedPreferences.setString('user', data);
        user = getSavedUser();
        log('FirebaseAuth.instance.currentUser?.uid ${userCred.user?.uid}');
        Get.offAllNamed(MainScreen.routeName);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayToastMessage('No user found for that email');
      } else if (e.code == 'wrong-password') {
        displayToastMessage('Wrong password provided for that user');
      }
    } catch (e) {
      log('Log In $e');
    }
  }

  Future<void> saveUserDataToFirebase({
    UserCredential? credential,
    required int id,
    required String name,
    required String email,
    required Timestamp time,
    required String gmail,
    required String gender,
    required String goal_id,
    required List<String> days,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {
      "uid": user!.uid,
      "id": id,
      "name": name,
      "email": email,
      "time": time,
      "gmail": gmail,
      "gender": gender,
      "goal_id": goal_id,
      "days": days,
      'token': await FirebaseMessaging.instance.getToken(),
    };
    log('FirebaseAuth.instance.currentUser?.uid ${user.uid}');
    if (credential != null && credential.user != null) {
      await userCollection.doc(user.uid).set(data);
      emotionTrackerCollection.doc(user.uid).set({
        'emotion_days': [],
      });
      credential.user?.updateDisplayName(name);
      credential.user?.updateEmail(email);
    }
  }

  UserDataModel? getSavedUser() {
    String? data = sharedPreferences.getString('user');
    if (data != null) {
      log(data, name: "Saved User");
      return UserDataModel.fromJson(json.decode(data));
    } else {
      FirebaseAuth.instance.signOut();
      return null;
    }
  }

  Future<void> logOutUser(context) async {
    try {
      await sharedPreferences.remove('user');
      await sharedPreferences.remove('fav');
      await sharedPreferences.remove('goal_id');
    } catch (e) {
      log('$e', name: 'Logout');
    }
    if (GoogleSignIn().currentUser != null) {
      await GoogleSignIn().signOut();
    } else if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }

    Navigator.of(context).pop();
    Get.offAllNamed(EntryScreen.routeName);
  }
}
Future<void> tile2CountCourseDays(
    String email, List<Map<String, dynamic>> records) async {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('tile2_count_course_days');

  final DocumentSnapshot document = await collection.doc(email).get();
  if (document.exists) {
    final List<Map<String, dynamic>> existingRecords =
    List<Map<String, dynamic>>.from(document['tile2']);

    // Check if a record with the same date already exists
    final String currentDate =
    DateFormat('yyyy-MM-dd').format(DateTime.now());
    final bool recordExistsForToday = existingRecords.any((record) {
      final String recordDate = record['date'] as String;
      return recordDate == currentDate;
    });

    if (!recordExistsForToday) {
      final int lastDay =
      existingRecords.isNotEmpty ? existingRecords.last['day'] as int : 0;
      final int newDay = lastDay + 1;

      for (var record in records) {
        record['day'] = newDay;
        record['date'] = currentDate; // Add the current date to the record
      }

      existingRecords.addAll(records);

      await collection.doc(email).update({'tile2': existingRecords});
      print('Record inserted for $currentDate');
    } else {
      // Update the course field for the existing record
      final Map<String, dynamic> existingRecord = existingRecords
          .firstWhere((record) => record['date'] == currentDate);

      final int updatedCourse = records.first['course'] as int;

      existingRecord['course'] = updatedCourse;
      existingRecord['day'] = 1;

      await collection.doc(email).update({'tile2': existingRecords});

      print('Record updated for $currentDate');
    }
  } else {
    final String currentDate =
    DateFormat('yyyy-MM-dd').format(DateTime.now());
    for (var record in records) {
      record['day'] = 1;
      record['date'] = currentDate; // Add the current date to the record
    }

    await collection.doc(email).set({'tile2': records});
    print('Record inserted for $currentDate');
  }
}