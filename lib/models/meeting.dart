// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Meeting {
  String cliente;
  List<String> funcExecutar;
  String funcAddTarefa;
  String descricao;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String recurrenceRule;

  Meeting({
    required this.cliente,
    required this.funcExecutar,
    this.funcAddTarefa = "",
    this.descricao = "",
    required this.from,
    required this.to,
    required this.background,
    this.isAllDay = false,
    this.recurrenceRule = "",
  });
}

class MeetingDataSource extends CalendarDataSource<Meeting> {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getSubject(int index) {
    return appointments![index].cliente;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String? getNotes(int index) {
    return appointments![index].descricao;
  }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }
}
