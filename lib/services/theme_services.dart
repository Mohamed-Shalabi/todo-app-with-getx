import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  ThemeServices._();

  static final GetStorage _box = GetStorage();
  static const _key = 'isDarkMode';

  static void _saveThemeFromBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  static bool get _themeFromBox => _box.read<bool>(_key) ?? false;

  static ThemeMode get themeMode => _themeFromBox ? ThemeMode.dark : ThemeMode.light;

  static void switchTheme() {
    _saveThemeFromBox(!_themeFromBox);
    Get.changeThemeMode(themeMode);
  }
}
