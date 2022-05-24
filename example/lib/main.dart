import 'package:example/cubit/app_navigator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shindenshin/shindenshin.dart';

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

  late final BaseApiClient apiClient;
  late final Store store;

  @override
  void initState() {
    super.initState();

    final BaseOptions options = BaseOptions(
      baseUrl: 'https://example.com/api/v1/',
    );
    apiClient = BaseApiClient(Dio(options));
    store = Store(apiClient);
  }

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
