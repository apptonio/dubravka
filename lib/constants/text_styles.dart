import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextStyles {
  static TextStyle screenTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle screenSubtitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18.sp,
    color: Colors.black54,
    fontWeight: FontWeight.w300,
  );

  static TextStyle titleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle subtitleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static const TextStyle light = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
  );
}
