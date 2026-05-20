import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay? time;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.time,
    this.isCompleted = false,
  });
}