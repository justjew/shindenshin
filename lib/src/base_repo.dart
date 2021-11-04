import 'package:shindenshin/src/base_store.dart';
import 'package:shindenshin/src/subscriptable.dart';

abstract class BaseRepo extends Subscriptable {
  final BaseStore store;

  BaseRepo(this.store);
}
