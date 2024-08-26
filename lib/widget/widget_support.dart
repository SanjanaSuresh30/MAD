import 'package:flutter/material.dart';

class AppWidget{

  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle headlineTextFieldStyle() {
    return const TextStyle(
        color:Colors.black,
        fontSize:26.0,
        fontWeight:FontWeight.bold,
        fontFamily: 'Poppins');
    }
  static TextStyle lightTextFieldStyle() {
    return const TextStyle(
        color: Colors.black38,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }
    static TextStyle semiBoldFieldStyle() {
      return const TextStyle(
          color:Colors.black,
          fontSize:18.0,
          fontWeight:FontWeight.w500,
          fontFamily: 'Poppins');
    }

  static TextStyle normalFieldStyle() {
    return const TextStyle(
        color:Colors.black,
        fontSize:16.0,
        fontWeight:FontWeight.normal,
        fontFamily: 'Sans-Serif');
  }
}