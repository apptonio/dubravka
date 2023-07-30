import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/utils/material_color.dart';
import 'package:flutter/material.dart';

final theme = ThemeData(
  fontFamily: 'Montserrat',
  useMaterial3: true,
  dialogTheme: const DialogTheme(backgroundColor: MyColors.white),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: createMaterialColor(MyColors.themeDark),
  ),
  scaffoldBackgroundColor: MyColors.white,
  cardTheme: const CardTheme(
    color: MyColors.white,
  ),
);
