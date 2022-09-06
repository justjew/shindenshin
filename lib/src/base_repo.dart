import 'package:shindenshin/shindenshin.dart';

abstract class BaseRepo extends Subscriptable {
  final BaseStore store;

  BaseRepo(this.store);

  void onRegisterComplete() {}

  void dispose() {
    eventPool.close();
  }
}
