import 'package:flutter/material.dart';
import 'package:isabel/providers/calendar_provider.dart';
import 'package:isabel/providers/drawer_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  floatingWidgets() {
    return FloatingActionButton.extended(
      onPressed: () {
        setState(() {
          context.read<CalendarProvider>().dateDafault();
          context.read<DrawerProvider>().updateTitle("Nova Tarefa");
          context.read<DrawerProvider>().mudarAddTarefa(true);
        });
      },
      label: const Text("Nova Tarefa"),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingWidgets(),
      body: SafeArea(
        child: Container(
          padding: (Theme.of(context).platform == TargetPlatform.android)
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(30, 0, 30, 30),
          color: Colors.grey.shade100,
          child: SfCalendar(
            appointmentTimeTextFormat: 'HH:mm',
            timeSlotViewSettings: const TimeSlotViewSettings(
              timeFormat: 'H:mm ',
              timeInterval: Duration(hours: 1),
              minimumAppointmentDuration: Duration(hours: 1),
            ),
            selectionDecoration: const BoxDecoration(color: Colors.transparent),
            cellEndPadding: 0,
            view: CalendarView.month,
            backgroundColor: Colors.white,
            dataSource: context.watch<CalendarProvider>().exatelDataSource,
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              appointmentDisplayCount: 2,
              showTrailingAndLeadingDates: false,
            ),
            showNavigationArrow:
                (Theme.of(context).platform == TargetPlatform.android)
                    ? false
                    : true,
            onTap: (calendarTapDetails) {
              switch (calendarTapDetails.targetElement) {
                case CalendarElement.calendarCell:
                  if (Provider.of<CalendarProvider>(context, listen: false)
                          .controllerCalendar
                          .view ==
                      CalendarView.month) {
                    context
                        .read<CalendarProvider>()
                        .goToDate(calendarTapDetails.date);
                  } else {
                    context
                        .read<CalendarProvider>()
                        .updateDate(calendarTapDetails.date!);
                    context.read<DrawerProvider>().updateTitle("Nova Tarefa");
                    context.read<DrawerProvider>().mudarAddTarefa(true);
                  }
                  break;
                case CalendarElement.viewHeader:
                  if (Provider.of<CalendarProvider>(context, listen: false)
                          .controllerCalendar
                          .view ==
                      CalendarView.week) {
                    context
                        .read<CalendarProvider>()
                        .goToDate(calendarTapDetails.date);
                  }
                  break;
                case CalendarElement.appointment:
                  context
                      .read<CalendarProvider>()
                      .updateTarefa(calendarTapDetails.appointments![0]);
                  context.read<DrawerProvider>().updateTitle("Nova Tarefa");
                  context.read<DrawerProvider>().mudarAddTarefa(true);
                  break;
                case CalendarElement.moreAppointmentRegion:
                  context
                      .read<CalendarProvider>()
                      .goToDate(calendarTapDetails.date);
                  break;
                default:
                  null;
              }
            },
            controller: context.watch<CalendarProvider>().controllerCalendar,
            allowedViews: const [
              CalendarView.month,
              CalendarView.week,
            ],
          ),
        ),
      ),
    );
  }
}
