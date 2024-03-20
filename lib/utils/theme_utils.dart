import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

bool isDarkMode() {
  return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark
      ? true
      : false;
}
