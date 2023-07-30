import 'package:dubravka/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MyDateTimeTextfield extends StatelessWidget {
  const MyDateTimeTextfield(
      {super.key,
      this.focusNode,
      required this.name,
      required this.label,
      required this.inputType,
      this.validator,
      this.onChanged,
      this.hasIcon = false});

  final FocusNode? focusNode;
  final String name;
  final String label;
  final String? Function(dynamic)? validator;
  final InputType inputType;
  final Function(DateTime?)? onChanged;
  final bool? hasIcon;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
      name: name,
      fieldLabelText: label,
      inputType: inputType,
      format: DateFormat('dd MMMM, yyyy'),
      initialDatePickerMode: DatePickerMode.year,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: hasIcon! ? 20.h : 0),
        prefixIcon: hasIcon!
            ? Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: const Icon(Icons.date_range_outlined),
              )
            : null,
        prefixIconColor: MyColors.themeLight,
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
        errorMaxLines: 2,
        errorStyle: const TextStyle(color: MyColors.red),
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
