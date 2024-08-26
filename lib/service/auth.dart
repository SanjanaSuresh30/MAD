import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods{
  final FirebaseAuth auth=FirebaseAuth.instance;

  getCurrentUser()async{
    return await auth.currentUser;
  }

  Future<void> SignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Successfully signed out');
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  Future deleteuser()async{
    User? user=await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}