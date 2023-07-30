import 'package:dubravka/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyRegularTextfield extends StatelessWidget {
  const MyRegularTextfield(
      {Key? key,
      this.focusNode,
      required this.name,
      required this.label,
      this.iconData,
      this.validator,
      this.onChanged,
      this.controller,
      this.initialValue})
      : super(key: key);

  final FocusNode? focusNode;
  final String name;
  final String label;
  final IconData? iconData;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final TextEditingController? controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      name: name,
      decoration: InputDecoration(
        prefixIcon: iconData != null
            ? Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(iconData),
              )
            : null,
        prefixIconColor: MyColors.themeLight,
        // prefixIconConstraints: iconData != null
        //     ? BoxConstraints(minWidth: 40.w)
        //     : const BoxConstraints(minWidth: 0, maxWidth: 0),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: iconData != null ? 20.h : 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        labelText: label,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: MyColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: MyColors.red),
        ),
        errorStyle: const TextStyle(color: MyColors.red),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: MyColors.themeLight),
        ),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
