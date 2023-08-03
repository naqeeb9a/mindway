// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindway/utils/api.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {
        "APP_AUTH_TOKEN": appAuth,
      },
    ),
  );

  Future<Response> logInUser(String email, String password) async {
    return await dio.post('$apiURL/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> signUp({
    required String name,
    required String email,
    required String password,
    required String goal_id,
  }) async {
    return await dio.post(
      '$apiURL/signup',
      data: {
        "email": email,
        "name": name,
        "password": password,
        "password_confirmation": password,
        "goal_id": goal_id,
      },
    );
  }

  Future<Response> verification(
      {required String email, required String verificationCode}) async {
    return await dio.post(
      '$apiURL/verify-signup',
      data: {
        "email": email,
        "verification_code": verificationCode,
      },
    );
  }

  Future<Response> updateUserTimeAndDay({
    required String email,
    required String time,
    required String day,
  }) async {
    return await dio.post(
      '$apiURL/get-notify',
      data: {
        "email": email,
        "notify_time": time,
        "notify_day": day,
      },
    );
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }
}
