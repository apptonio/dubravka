import 'package:dubravka/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideButton extends StatelessWidget {
  const WideButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.width,
      this.height});

  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: MyColors.themeLight),
          child: Text(
            title,
            style: const TextStyle(color: MyColors.white)
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(fontSize: 16.sp),
          )),
    );
  }
}
