import 'dart:io';

import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._();
  static IconData backButton =
      Platform.isIOS ? Icons.keyboard_arrow_left : Icons.arrow_back;
}
