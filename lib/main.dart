import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wiet_assignment/pages/home/presentation/home_page.dart';
import 'package:wiet_assignment/utils/bloc_observer.dart';
import 'package:wiet_assignment/utils/blocs/home_bloc_injection.dart';
import 'package:wiet_assignment/utils/di.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    setupLocator();
    Bloc.observer = const Observer();
    runApp(const App());
  }, (e, stack) {
    log(e.toString());
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeBlocInjection(
      child: MaterialApp(
        title: 'Flutter Cat App',
        home: HomePage(),
      ),
    );
  }
}
