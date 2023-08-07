import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isabel/providers/calendar_provider.dart';
import 'package:isabel/providers/drawer_provider.dart';
import 'package:isabel/providers/funcionario_provider.dart';
import 'package:isabel/routes.dart';
import 'package:provider/provider.dart';
import 'apis/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FuncionarioProvider()),
          ChangeNotifierProvider(create: (_) => CalendarProvider()),
          ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: [Locale('pt', 'BR')],
      locale: Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      title: 'Isabel',
      initialRoute: "/",
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
