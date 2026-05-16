import 'package:flutter/material.dart';

class ReservationDateModel {
  DateTime date;
  TimeOfDay from;
  TimeOfDay to;

  ReservationDateModel({
    required this.date,
    required this.from,
    required this.to,
  });
}
