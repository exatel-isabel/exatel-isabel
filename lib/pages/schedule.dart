import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/scheduler.dart';
import 'package:isabel/pages/task.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final CalendarController _controller = CalendarController();
  DateTime? datePicked = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: datePicked!,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100))
                .then((DateTime? date) {
              if (date != null) {
                setState(() {
                  _controller.selectedDate = date;
                  _controller.displayDate = date;
                  _controller.view = CalendarView.day;
                });
              }
            });
          },
          child: const Text(
            "Selecione o dia",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),*/
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showMaterialModalBottomSheet(
          context: context,
          builder: (context) => const TaskPage(),
        ),
        label: const Text("Nova Tarefa"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          padding: (Theme.of(context).platform == TargetPlatform.android)
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(30, 0, 30, 30),
          color: Colors.grey.shade100,
          child: SfCalendar(
            selectionDecoration: const BoxDecoration(color: Colors.transparent),
            cellEndPadding: 0,
            view: (Theme.of(context).platform == TargetPlatform.android)
                ? CalendarView.day
                : CalendarView.month,
            backgroundColor: Colors.white,
            dataSource: MeetingDataSource(getDataSource()),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            showNavigationArrow:
                (Theme.of(context).platform == TargetPlatform.android)
                    ? false
                    : true,
            onTap: (calendarTapDetails) {
              if (_controller.view == CalendarView.month &&
                      calendarTapDetails.targetElement ==
                          CalendarElement.calendarCell ||
                  CalendarElement.appointment ==
                      calendarTapDetails.targetElement) {
                _controller.view = CalendarView.day;
              }
            },
            controller: _controller,
            allowedViews: (Theme.of(context).platform == TargetPlatform.android)
                ? []
                : [CalendarView.month],
            onViewChanged: (viewChangedDetails) {
              SchedulerBinding.instance.addPostFrameCallback((duration) {
                datePicked = viewChangedDetails
                    .visibleDates[viewChangedDetails.visibleDates.length ~/ 2];
              });
            },
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
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
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

List<Meeting> getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false));
  return meetings;
}
