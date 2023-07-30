import 'package:dubravka/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDropdownTextfield extends StatelessWidget {
  const MyDropdownTextfield(
      {super.key,
      required this.focusNode,
      required this.items,
      required this.name,
      this.label,
      this.onChanged,
      this.validator,
      this.initialValue,
      this.iconData});

  final FocusNode focusNode;
  final List<DropdownMenuItem> items;
  final String name;
  final String? label;
  final String? Function(dynamic)? validator;
  final Function? onChanged;
  final dynamic initialValue;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      onChanged: (_) => onChanged,
      name: name,
      items: items,
      validator: validator,
      borderRadius: BorderRadius.circular(20.r),
      dropdownColor: MyColors.white,
      iconDisabledColor: MyColors.themeLight,
      iconEnabledColor: MyColors.themeLight,
      decoration: InputDecoration(
        prefixIcon: iconData != null
            ? Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(iconData),
              )
            : null,
        contentPadding: EdgeInsets.fromLTRB(
            20, iconData != null ? 10 : 0, 10, iconData != null ? 10 : 0),
        // EdgeInsets.symmetric(
        //     horizontal: 10.w, vertical: iconData != null ? 20.h : 0),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            borderSide: BorderSide(color: Colors.black12)),
        labelText: label,
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: MyColors.red,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: MyColors.red,
          ),
        ),
        errorStyle: const TextStyle(color: MyColors.red),
        errorMaxLines: 2,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: MyColors.themeLight,
          ),
        ),
      ),
    );
  }
}
