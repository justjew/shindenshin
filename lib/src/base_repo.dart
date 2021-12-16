import 'package:shindenshin/shindenshin.dart';
import 'package:shindenshin/src/subscriptable.dart';

abstract class BaseRepo extends Subscriptable {
  final BaseStore store;

  BaseRepo(this.store);

  void dispose() {
    eventPool.close();
  }
}
