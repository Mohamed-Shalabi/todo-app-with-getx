import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class Task {
  int? id;
  String? title;
  String? body;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Color get realColor => color == 0
      ? pinkColor
      : color == 1
          ? primaryColor
          : orangeColor;

  Task({this.id, this.title, this.body, this.isCompleted, this.date, this.startTime, this.endTime, this.color, this.remind, this.repeat});

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    isCompleted = map['is_completed'];
    date = map['date'];
    startTime = map['start_time'];
    endTime = map['end_time'];
    color = map['color'];
    remind = map['remind'];
    repeat = map['repeat'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'is_completed': isCompleted,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'color': color,
        'remind': remind,
        'repeat': repeat,
      };
}
