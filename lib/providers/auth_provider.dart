import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  SharedPreferences? sharedPreferences;
  
  get auth => null;

  Future<UserCredential> emailSignUp(
      {@required String? email, @required String? pass}) async {
    final userRegister = await auth.createUserWithEmailAndPassword(
        email: email!, password: pass!);

    return userRegister;
  }

  Future<UserCredential> emailSignIn(
      {@required String? email, @required String? pass}) async {
    final user =
        await auth.signInWithEmailAndPassword(email: email!, password: pass!);

    return user;
  }

  Future<void> logout() async {
    await auth.signOut().then((value) async {
      //  await sharedPreferences.clear();
    });
  }
}