import 'package:shindenshin/shindenshin.dart';

abstract class BaseRepo extends Subscriptable {
  final BaseStore store;

  BaseRepo(this.store);

  void dispose() {
    eventPool.close();
  }
}
