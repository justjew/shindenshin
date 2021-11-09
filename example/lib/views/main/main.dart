import 'package:example/cubit/app_navigator_cubit.dart';
import 'package:example/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Main extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Store store;

  const Main({
    Key? key,
    required this.store,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getThemeData(),
      home: BlocBuilder<AppNavigatorCubit, AppNavigatorState>(
        builder: builder,
      ),
    );
  }

  ThemeData getThemeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
    );
  }

  Widget builder(BuildContext context, AppNavigatorState state) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        pages: List.of(state.pages),
        onPopPage: context.read<AppNavigatorCubit>().onPopPage,
      ),
    );
  }
}
