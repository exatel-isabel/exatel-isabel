import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isabel/pages/schedule.dart';
import 'package:isabel/pages/task.dart';

class DrawerProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late String _title = "Agenda";
  late bool _isAddTarefa = false;

  String get title => _title;
  bool get isAddTarefa => _isAddTarefa;

  void updateTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void mudarAddTarefa(bool estado) {
    _isAddTarefa = estado;
    notifyListeners();
  }

  Widget pagesChild() {
    switch (_title) {
      case "Agenda":
        return const SchedulePage();
      case "Nova Tarefa":
        return const TaskPage();
      default:
        return Container(color: Colors.white);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<bool>('isAddTarefa', isAddTarefa));
  }
}
