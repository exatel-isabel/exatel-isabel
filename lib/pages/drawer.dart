import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:isabel/providers/calendar_provider.dart';
import 'package:isabel/providers/drawer_provider.dart';
import 'package:isabel/providers/funcionario_provider.dart';
import 'package:provider/provider.dart';
import 'package:isabel/apis/firebase_auth.dart';
import 'package:isabel/routes.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final GlobalKey<SliderDrawerState> sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SliderDrawer(
          appBar: SliderAppBar(
            appBarHeight: 50,
            drawerIconColor: Colors.white,
            appBarColor: Colors.blue,
            appBarPadding: EdgeInsets.zero,
            title: isSearch
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            context.watch<DrawerProvider>().title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Pesquise a tarefa...",
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    context.watch<DrawerProvider>().title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            trailing: (Provider.of<DrawerProvider>(context, listen: false)
                        .title !=
                    "Agenda")
                ? null
                : Row(
                    children: [
                      IconButton(
                        tooltip: "Pesquisar Tarefa",
                        onPressed: () {
                          setState(() {
                            isSearch = !isSearch;
                            searchController.clear();
                          });
                        },
                        icon: Icon(
                          isSearch ? Icons.cancel : Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        tooltip: "Hoje",
                        onPressed: () {
                          context.read<CalendarProvider>().goToHoje();
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        tooltip: "Atualizar tarefas",
                        onPressed: () {}, // atualizar tarefas
                        icon: const Icon(
                          Icons.update_rounded,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        tooltip: "Escolher data",
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 12, 31))
                              .then((DateTime? date) {
                            if (date != null) {
                              context.read<CalendarProvider>().goToDate(date);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.edit_calendar,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
          key: sliderDrawerKey,
          sliderOpenSize: (Theme.of(context).platform == TargetPlatform.android)
              ? 200
              : 190,
          slider: _SliderView(
            onItemClick: (titles) async {
              switch (titles) {
                case "Sair":
                  {
                    await FireAuth().logout().then((value) =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.signinPage, (route) => false));
                  }
                default:
                  null;
              }
              sliderDrawerKey.currentState!.closeSlider();
              setState(() {
                context.read<DrawerProvider>().mudarAddTarefa(false);
                context.read<DrawerProvider>().updateTitle(titles);
              });
            },
          ),
          child: context.watch<DrawerProvider>().pagesChild(),
        ),
      ),
    );
  }
}

class _SliderView extends StatefulWidget {
  final Function(String)? onItemClick;

  const _SliderView({
    Key? key,
    this.onItemClick,
  }) : super(key: key);

  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 65,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              backgroundImage: NetworkImage(
                  "data:image/jpeg;base64,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"), // Adicionar imagem do funcionario
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            context.watch<FuncionarioProvider>().funcionario.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 20),
          ...[
            Menu(Icons.calendar_month, 'Agenda'),
            Menu(Icons.person_outline, 'Perfil'),
            Menu(Icons.app_registration, 'Cadastros'),
            Menu(Icons.area_chart_rounded, 'Relatorios'),
            Menu(Icons.settings, 'Configurações'),
            Menu(Icons.logout_rounded, 'Sair')
          ]
              .map((menu) => _SliderMenuItem(
                  title: menu.title,
                  iconData: menu.iconData,
                  onTap: widget.onItemClick))
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'BalsamiqSans_Regular',
          ),
        ),
        leading: Icon(
          iconData,
          color: Colors.black,
        ),
        onTap: () => onTap?.call(title));
  }
}

class Menu {
  final IconData iconData;
  final String title;

  Menu(this.iconData, this.title);
}
