import 'package:dubravka/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/material_color.dart';

class SingleCheckboxField extends StatelessWidget {
  const SingleCheckboxField({
    super.key,
    required this.name,
    required this.label,
    required this.initialValue,
    required this.focusNode,
  });

  final String name;
  final String label;
  final bool initialValue;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: createMaterialColor(MyColors.themeLight),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(6.0), // Set the desired border radius
            ),
          ),
        ),
        child: FormBuilderCheckbox(
          focusNode: focusNode,
          initialValue: initialValue,
          name: name,
          title: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
        ));
  }
}
