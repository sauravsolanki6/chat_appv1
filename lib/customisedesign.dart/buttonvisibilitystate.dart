import 'package:flutter/material.dart';

class ButtonVisibilityState extends ChangeNotifier {
  ValueNotifier<bool> isTextNotEmpty = ValueNotifier<bool>(false);

  void updateTextVisibility(bool value) {
    isTextNotEmpty.value = value;
  }
}
