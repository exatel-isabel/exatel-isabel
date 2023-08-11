import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:isabel/models/meeting.dart';
import 'package:isabel/providers/calendar_provider.dart';
import 'package:isabel/providers/drawer_provider.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  TextEditingController typeAheadController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  List<String> funcionariosExatel = ["Selecione..."];
  List<String> clientesExatel = [];
  List<String> carrosExatel = [];
  List<String> selected = [];
  late DateTime nowDay;
  Meeting? task;

  @override
  void initState() {
    task = Provider.of<CalendarProvider>(context, listen: false).task;
    typeAheadController = TextEditingController(text: task!.cliente);
    descricaoController = TextEditingController(text: task!.descricao);
    carrosExatel = [
      "Uno 4 portas",
      "Palio do Paulo",
      "Agile",
      "MIZ for you",
    ];
    nowDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    funcionariosExatel.addAll([
      "Welinton",
      "Alexandre",
      "Janaina Oliveira",
      "Anderson",
      "Felipe",
      "Janaina Farias",
      "Gabriel",
      "Paulo",
      "Vinicius",
      "Eduardo",
      "Leonardo",
    ]);
    clientesExatel.addAll([
      "PNX",
      "Doctor",
      "PMNH",
      "CauCakes",
      "Box 7",
      "Churras do Alemão",
      "Padaria da Vovo",
      "FNP",
      "CDL",
      "Servicom",
      "Ortobom",
    ]);
    super.initState();
  }

  @override
  void dispose() {
    typeAheadController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  floatingWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              context.read<DrawerProvider>().updateTitle("Agenda");
              context.read<DrawerProvider>().mudarAddTarefa(false);
            });
          },
          label: const Text("Cancelar"),
          icon: const Icon(Icons.close),
          backgroundColor: Colors.red,
        ),
        const SizedBox(width: 20),
        FloatingActionButton.extended(
          onPressed: () {
            context.read<CalendarProvider>().addTarefa(task!);
            context.read<DrawerProvider>().updateTitle("Agenda");
            context.read<DrawerProvider>().mudarAddTarefa(false);
            debugPrint(task!.descricao);
          },
          label: const Text("Salvar"),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ],
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade100,
          child: Container(
            color: Colors.white,
            child: FractionallySizedBox(
              widthFactor:
                  (Theme.of(context).platform == TargetPlatform.android)
                      ? 0.8
                      : 0.5,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    "Cliente:",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: typeAheadController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                        suffixIcon: typeAheadController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  typeAheadController.clear();
                                  setState(() {
                                    task!.cliente = "";
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      List<String> matches = <String>[];
                      matches.addAll(clientesExatel);
                      matches.retainWhere((s) =>
                          s.toLowerCase().contains(pattern.toLowerCase()));
                      return matches;
                    },
                    itemBuilder: (context, itemData) {
                      return ListTile(
                        title: Text(itemData),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      return Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(0.1),
                        child: const Text("Cliente não cadastrado!"),
                      );
                    },
                    itemSeparatorBuilder: (context, index) {
                      return const Divider();
                    },
                    transitionBuilder: (context, child, controller) {
                      return child;
                    },
                    onSuggestionSelected: (suggestion) {
                      typeAheadController.text = suggestion;
                      task!.cliente = suggestion;
                      setState(() {});
                    },
                    suggestionsBoxController: suggestionBoxController,
                  ),
                  const SizedBox(height: 15),
                  const Text("Tarefa será executada por:",
                      style: TextStyle(color: Colors.blue)),
                  DropDownMultiSelect<String>(
                    options: funcionariosExatel,
                    hint: const Text("Selecione..."),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                      suffixIcon: selected.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  selected.clear();
                                });
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                    selectedValues: selected,
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                        task!.funcExecutar = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded),
                      const SizedBox(width: 20),
                      const Text("Dia inteiro"),
                      const Expanded(child: SizedBox(width: 1)),
                      Checkbox(
                        value: task!.isAllDay,
                        onChanged: (value) {
                          setState(() {
                            task!.isAllDay = !task!.isAllDay;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(
                                          DateTime.now().year + 1, 12, 31))
                                  .then((DateTime? date) {
                                if (date != null &&
                                    date.compareTo(nowDay) == 0) {
                                  setState(() {
                                    task!.from = DateTime(
                                      nowDay.year,
                                      nowDay.month,
                                      nowDay.day,
                                      DateTime.now().hour,
                                      DateTime.now().minute,
                                    );
                                    task!.to = task!.from
                                        .add(const Duration(hours: 1));
                                  });
                                }
                                if (date != null &&
                                    DateTime.now().compareTo(date) < 0) {
                                  setState(() {
                                    task!.from = date;
                                    task!.to =
                                        date.add(const Duration(hours: 1));
                                  });
                                }
                              });
                            },
                            child: Text(
                              DateFormat('EEEE, dd-MM-y', 'pt-BR')
                                  .format(task!.from),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate:
                                    DateTime(DateTime.now().year + 1, 12, 31),
                              ).then((DateTime? date) {
                                if (date != null &&
                                    task!.from.compareTo(date) < 0) {
                                  setState(() {
                                    task!.to = date;
                                    if (date.compareTo(task!.from) < 0) {
                                      task!.from = DateTime(
                                        task!.to.year,
                                        task!.to.month,
                                        task!.to.day,
                                        date.hour,
                                        date.minute,
                                      );
                                    }
                                  });
                                }
                              });
                            },
                            child: Text(
                              DateFormat('EEEE, dd-MM-y', 'pt-BR')
                                  .format(task!.to),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox(width: 1)),
                      Visibility(
                        visible: !task!.isAllDay,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: task!.from.hour,
                                    minute: task!.from.minute,
                                  ),
                                ).then((TimeOfDay? time) {
                                  late DateTime timeNow;
                                  if (time != null) {
                                    timeNow = DateTime(
                                      task!.from.year,
                                      task!.from.month,
                                      task!.from.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  }
                                  if (time != null &&
                                      DateTime.now().compareTo(timeNow) < 0) {
                                    setState(() {
                                      task!.from = DateTime(
                                        task!.from.year,
                                        task!.from.month,
                                        task!.from.day,
                                        time.hour,
                                        time.minute,
                                      );
                                      int hrTask = time.hour + 1;
                                      task!.to = DateTime(
                                        task!.to.year,
                                        task!.to.month,
                                        task!.to.day,
                                        hrTask,
                                        time.minute,
                                      );
                                    });
                                  }
                                });
                              },
                              child: Text(
                                DateFormat.Hm('pt-BR').format(task!.from),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                      hour: task!.to.hour,
                                      minute: task!.to.minute),
                                ).then((TimeOfDay? time) {
                                  late DateTime timeNow;
                                  if (time != null) {
                                    timeNow = DateTime(
                                      task!.from.year,
                                      task!.from.month,
                                      task!.from.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  }
                                  if (time != null &&
                                      DateTime.now().compareTo(timeNow) < 0) {
                                    setState(() {
                                      task!.to = DateTime(
                                        task!.to.year,
                                        task!.to.month,
                                        task!.to.day,
                                        time.hour,
                                        time.minute,
                                      );
                                    });
                                  }
                                });
                              },
                              child: Text(
                                DateFormat.Hm('pt-BR').format(task!.to),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.replay_outlined),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          // repetir tarefa
                        },
                        child: const Text(
                          "Repete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("Descrição da tarefa:",
                      style: TextStyle(color: Colors.blue)),
                  TextFormField(
                    controller: descricaoController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        task!.descricao = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                      suffixIcon: descricaoController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                descricaoController.clear();
                                setState(() {
                                  task!.descricao = "";
                                });
                              },
                              icon:
                                  const Icon(Icons.cancel, color: Colors.grey),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
