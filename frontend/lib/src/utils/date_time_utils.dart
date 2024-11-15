import 'package:flutter/material.dart';

DateTime getTodayDate() {
  DateTime dateTime = DateTime.now();

  return DateUtils.dateOnly(dateTime);
}