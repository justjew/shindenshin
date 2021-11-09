import 'package:shindenshin/src/base_store.dart';
import 'package:shindenshin/src/subscriptable.dart';

abstract class BaseRepo<T extends BaseStore> extends Subscriptable {
  final T store;

  BaseRepo(this.store);
}
