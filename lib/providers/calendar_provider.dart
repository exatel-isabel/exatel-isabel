import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isabel/models/meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final CalendarController _controllerCalendar = CalendarController();
  late Meeting _task = Meeting(
    cliente: "",
    funcExecutar: [],
    descricao: "",
    from: DateTime.now(),
    to: DateTime.now(),
    background: Colors.green,
  );
  final MeetingDataSource _exatelDataSource = MeetingDataSource([
    Meeting(
      cliente: "Doctor",
      funcExecutar: ["Welinton"],
      funcAddTarefa: "Felipe",
      descricao: "Teste de descricao",
      from: DateTime(2023, 8, 3, 12),
      to: DateTime(2023, 8, 3, 15),
      background: Colors.red,
    ),
    Meeting(
      cliente: "Doctor 2",
      funcExecutar: ["Welinton"],
      funcAddTarefa: "Felipe",
      descricao: "Teste de descricao",
      from: DateTime(2023, 8, 3, 12),
      to: DateTime(2023, 8, 3, 15),
      background: Colors.green,
    ),
    Meeting(
      cliente: "Doctor 3",
      funcExecutar: ["Welinton"],
      funcAddTarefa: "Felipe",
      descricao: "Teste de descricao",
      from: DateTime(2023, 8, 3, 12),
      to: DateTime(2023, 8, 3, 15),
      background: Colors.yellow,
    ),
  ]);

  CalendarController get controllerCalendar => _controllerCalendar;
  MeetingDataSource get exatelDataSource => _exatelDataSource;
  Meeting get task => _task;

  void addTarefa(Meeting tarefa) {
    _task = tarefa;
    _exatelDataSource.appointments!.add(tarefa);
    _exatelDataSource
        .notifyListeners(CalendarDataSourceAction.add, <Meeting>[tarefa]);
    notifyListeners();
    _task = Meeting(
      cliente: "",
      funcExecutar: [],
      descricao: "",
      from: DateTime.now(),
      to: DateTime.now(),
      background: Colors.green,
    );
  }

  void goSelectedDate(DateTime? date) {
    _controllerCalendar.selectedDate = date;
    notifyListeners();
  }

  void goSelectedView(CalendarView? view) {
    _controllerCalendar.view = view;
    notifyListeners();
  }

  void goToDate(DateTime? date) {
    _controllerCalendar.selectedDate = date;
    _controllerCalendar.displayDate = date;
    _controllerCalendar.view = CalendarView.day;
    notifyListeners();
  }

  void goToHoje() {
    _controllerCalendar.selectedDate = DateTime.now();
    _controllerCalendar.displayDate = DateTime.now();
    _controllerCalendar.view = CalendarView.month;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CalendarController>(
        'controllerCalendar', controllerCalendar));
    properties.add(DiagnosticsProperty<MeetingDataSource>(
        'exatelDataSource', exatelDataSource));
  }
}
