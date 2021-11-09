import 'package:example/cubit/app_navigator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'store/store.dart';
import 'views/main/main.dart';


void main() {
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final Store store = Store();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppNavigatorCubit>(
      create: (_) => AppNavigatorCubit(store),
      child: Main(
        store: store,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
